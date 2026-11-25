import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreArtAuthService {
  CreArtAuthService._();

  static final instance = CreArtAuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');
  CollectionReference<Map<String, dynamic>> get _usernames =>
      _firestore.collection('usernames');

  Future<String> _emailForIdentifier(String identifier) async {
    final value = identifier.trim();
    if (value.contains('@')) return value.toLowerCase();

    final username = value.toLowerCase();
    final snapshot = await _usernames.doc(username).get();
    final email = snapshot.data()?['email'];
    if (email is! String || email.isEmpty) {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    return email;
  }

  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    final email = await _emailForIdentifier(identifier);
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    final normalizedUsername = username.trim().toLowerCase();
    final normalizedEmail = email.trim().toLowerCase();
    final credential = await _auth.createUserWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );
    final user = credential.user!;

    final userRef = _users.doc(user.uid);
    final usernameRef = _usernames.doc(normalizedUsername);

    try {
      await user.updateDisplayName(fullName.trim());
      await _firestore.runTransaction((transaction) async {
        final existingUsername = await transaction.get(usernameRef);
        if (existingUsername.exists) throw _UsernameAlreadyTaken();

        transaction.set(userRef, {
          'uid': user.uid,
          'displayName': fullName.trim(),
          'username': username.trim(),
          'usernameLowercase': normalizedUsername,
          'email': normalizedEmail,
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });
        transaction.set(usernameRef, {
          'uid': user.uid,
          'email': normalizedEmail,
        });
      });
    } on _UsernameAlreadyTaken {
      await user.delete();
      throw FirebaseAuthException(code: 'username-already-in-use');
    } on FirebaseException {
      await user.delete();
      rethrow;
    }
  }

  Future<void> sendPasswordReset(String identifier) async {
    final email = await _emailForIdentifier(identifier);
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> isAdmin(String uid) async {
    final profile = await _users.doc(uid).get();
    return profile.data()?['role'] == 'admin';
  }

  Future<void> signOut() => _auth.signOut();
}

class _UsernameAlreadyTaken implements Exception {}

String authErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'invalid-email' => 'Format email belum benar.',
      'user-not-found' || 'wrong-password' || 'invalid-credential' =>
        'Email/nama pengguna atau kata sandi tidak sesuai.',
      'email-already-in-use' => 'Email ini sudah terdaftar.',
      'username-already-in-use' => 'Nama pengguna sudah dipakai.',
      'weak-password' =>
        'Kata sandi terlalu lemah. Gunakan minimal 6 karakter.',
      'too-many-requests' =>
        'Terlalu banyak percobaan. Coba lagi beberapa saat.',
      'network-request-failed' => 'Koneksi internet bermasalah. Coba lagi.',
      _ => error.message ?? 'Autentikasi gagal. Silakan coba lagi.',
    };
  }
  if (error is FirebaseException) {
    return 'Tidak dapat mengakses data akun. Periksa koneksi dan aturan Firebase.';
  }
  return 'Terjadi kesalahan. Silakan coba lagi.';
}
