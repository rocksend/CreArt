import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Artwork {
  final String id;
  final String title;
  final String creator;
  final String? creatorUid;
  final String category;
  final String description;
  final String? imageUrl;
  final Color color1;
  final Color color2;
  final DateTime createdAt;

  int likes;
  bool isLiked;
  bool isSaved;
  final List<String> savedBy;

  Artwork({
    required this.id,
    required this.title,
    required this.creator,
    this.creatorUid,
    required this.category,
    required this.description,
    this.imageUrl,
    this.color1 = const Color(0xFFE9DDFB),
    this.color2 = const Color(0xFFF3C7A7),
    this.likes = 0,
    this.isLiked = false,
    this.isSaved = false,
    List<String> savedBy = const [],
    DateTime? createdAt,
  }) : savedBy = List<String>.from(savedBy),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'creator': creator,
      'creatorUid': creatorUid,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'color1': color1.toARGB32(),
      'color2': color2.toARGB32(),
      'likes': likes,
      'isLiked': isLiked,
      'savedBy': savedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Artwork.fromFirestore(
    String docId,
    Map<String, dynamic> data, {
    String? currentUserId,
  }) {
    final ts = data['createdAt'];
    final rawImageUrl = data['imageUrl'];
    final rawSavedBy = data['savedBy'];
    final savedBy = rawSavedBy is List
        ? rawSavedBy.whereType<String>().toList()
        : <String>[];
    return Artwork(
      id: docId,
      title: data['title'] ?? '',
      creator: data['creator'] ?? '',
      creatorUid: data['creatorUid'] as String?,
      category: data['category'] ?? 'Lainnya',
      description: data['description'] ?? '',
      imageUrl: (rawImageUrl is String && rawImageUrl.isNotEmpty)
          ? rawImageUrl
          : null,
      color1: Color(data['color1'] ?? 0xFFE9DDFB),
      color2: Color(data['color2'] ?? 0xFFF3C7A7),
      likes: data['likes'] ?? 0,
      isLiked: data['isLiked'] ?? false,
      isSaved: currentUserId != null && savedBy.contains(currentUserId),
      savedBy: savedBy,
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }
}

class CreArtStore extends ChangeNotifier {
  CreArtStore._() {
    FirebaseAuth.instance.authStateChanges().listen(_handleAuthChange);
    _handleAuthChange(FirebaseAuth.instance.currentUser);
    initFirestoreListener();
  }

  static final CreArtStore instance = CreArtStore._();

  // <-- INI BAGIAN YANG DIGANTI (baris 83-84)
  static const String _cloudinaryCloudName = 'wbesiexk';
  static const String _cloudinaryUploadPreset = 'creart_unsigned';

  final _artworksRef = FirebaseFirestore.instance.collection('artworks');

  String userName = '';
  String username = '';
  String email = '';
  String phoneNumber = '';
  String bio = '';
  String? profilePhotoUrl;
  String? profileLoadError;
  String? _currentUserId;
  Set<String> _creatorNames = {};

  List<Artwork> artworks = [];
  bool isLoading = true;
  bool isProfileLoading = false;

  void _handleAuthChange(User? user) {
    _currentUserId = user?.uid;
    if (user == null) {
      userName = '';
      username = '';
      email = '';
      phoneNumber = '';
      bio = '';
      profilePhotoUrl = null;
      profileLoadError = null;
      isProfileLoading = false;
      _creatorNames = {};
      artworks = artworks
          .map((artwork) => _withSavedState(artwork, false))
          .toList();
      notifyListeners();
      return;
    }

    userName = user.displayName ?? '';
    username = '';
    email = user.email ?? '';
    phoneNumber = '';
    bio = '';
    profilePhotoUrl = null;
    profileLoadError = null;
    isProfileLoading = true;
    _creatorNames = userName.isEmpty ? {} : {userName};
    _loadUserProfile(user);
    artworks = artworks
        .map(
          (artwork) =>
              _withSavedState(artwork, artwork.savedBy.contains(user.uid)),
        )
        .toList();
    notifyListeners();
  }

  Future<void> _loadUserProfile(User user) async {
    try {
      final profile = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (_currentUserId != user.uid) return;

      final data = profile.data() ?? <String, dynamic>{};
      final authenticatedEmail = user.email;
      final profileEmail = data['email'] as String?;
      if (authenticatedEmail != null && profileEmail != authenticatedEmail) {
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final username = data['username'] as String? ?? '';
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final usernameRef = FirebaseFirestore.instance
              .collection('usernames')
              .doc(username.toLowerCase());
          await transaction.get(userRef);
          if (username.isNotEmpty) await transaction.get(usernameRef);
          transaction.set(userRef, {
            'email': authenticatedEmail,
            'pendingEmail': FieldValue.delete(),
          }, SetOptions(merge: true));
          if (username.isNotEmpty) {
            transaction.set(usernameRef, {
              'uid': user.uid,
              'email': authenticatedEmail,
            }, SetOptions(merge: true));
          }
        });
      }

      userName = data['displayName'] as String? ?? user.displayName ?? '';
      username = data['username'] as String? ?? '';
      email = authenticatedEmail ?? profileEmail ?? '';
      phoneNumber = data['phoneNumber'] as String? ?? '';
      bio = data['bio'] as String? ?? '';
      profilePhotoUrl = data['photoUrl'] as String?;
      final creatorNames = data['creatorNames'];
      _creatorNames = creatorNames is List
          ? creatorNames.whereType<String>().toSet()
          : <String>{};
      if (userName.isNotEmpty) _creatorNames.add(userName);
      profileLoadError = null;
      isProfileLoading = false;
      notifyListeners();
    } catch (error) {
      if (_currentUserId != user.uid) return;
      profileLoadError = error.toString();
      isProfileLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) await _loadUserProfile(user);
  }

  void initFirestoreListener() {
    _artworksRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            artworks = snapshot.docs
                .map(
                  (doc) => Artwork.fromFirestore(
                    doc.id,
                    doc.data(),
                    currentUserId: _currentUserId,
                  ),
                )
                .toList();
            isLoading = false;
            notifyListeners();
          },
          onError: (error) {
            isLoading = false;
            notifyListeners();
          },
        );
  }

  Future<String> _uploadToCloudinary(File imageFile) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudinaryCloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _cloudinaryUploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200 &&
        streamedResponse.statusCode != 201) {
      throw Exception(
        'Upload ke Cloudinary gagal (${streamedResponse.statusCode}): $responseBody',
      );
    }

    final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
    final secureUrl = decoded['secure_url'] as String?;
    if (secureUrl == null || secureUrl.isEmpty) {
      throw Exception('URL gambar tidak ditemukan pada respons Cloudinary.');
    }

    return secureUrl;
  }

  Future<void> updateProfilePhoto(File imageFile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('Tidak ada pengguna yang masuk.');

    final photoUrl = await _uploadToCloudinary(imageFile);
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'photoUrl': photoUrl,
    }, SetOptions(merge: true));
    profilePhotoUrl = photoUrl;
    notifyListeners();
  }

  Future<void> addArtwork({
    required String title,
    required String description,
    required String category,
    File? imageFile,
  }) async {
    String? uploadedImageUrl;
    if (imageFile != null) {
      uploadedImageUrl = await _uploadToCloudinary(imageFile);
    }

    final newArt = Artwork(
      id: '',
      title: title,
      creator: userName,
      creatorUid: _currentUserId,
      category: category,
      description: description,
      imageUrl: uploadedImageUrl,
    );

    await _artworksRef.add(newArt.toMap());
  }

  Future<void> toggleLike(Artwork artwork) async {
    artwork.isLiked = !artwork.isLiked;
    artwork.likes += artwork.isLiked ? 1 : -1;
    notifyListeners();

    if (artwork.id.isNotEmpty) {
      await _artworksRef.doc(artwork.id).update({
        'likes': artwork.likes,
        'isLiked': artwork.isLiked,
      });
    }
  }

  Future<void> toggleSave(Artwork artwork) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('Tidak ada pengguna yang masuk.');

    final shouldSave = !artwork.isSaved;
    if (artwork.id.isNotEmpty) {
      await _artworksRef.doc(artwork.id).update({
        'savedBy': shouldSave
            ? FieldValue.arrayUnion([userId])
            : FieldValue.arrayRemove([userId]),
      });
    }

    artwork.isSaved = shouldSave;
    if (shouldSave) {
      artwork.savedBy.add(userId);
    } else {
      artwork.savedBy.remove(userId);
    }
    notifyListeners();
  }

  List<Artwork> get savedArtworks =>
      artworks.where((art) => art.isSaved).toList();

  List<Artwork> get myArtworks => artworks
      .where(
        (art) =>
            (_currentUserId != null && art.creatorUid == _currentUserId) ||
            (art.creator.isNotEmpty && _creatorNames.contains(art.creator)),
      )
      .toList();

  Artwork _withSavedState(Artwork artwork, bool isSaved) {
    return Artwork(
      id: artwork.id,
      title: artwork.title,
      creator: artwork.creator,
      creatorUid: artwork.creatorUid,
      category: artwork.category,
      description: artwork.description,
      imageUrl: artwork.imageUrl,
      color1: artwork.color1,
      color2: artwork.color2,
      likes: artwork.likes,
      isLiked: artwork.isLiked,
      isSaved: isSaved,
      savedBy: artwork.savedBy,
      createdAt: artwork.createdAt,
    );
  }

  bool login(String identifier, String password) {
    if (identifier.trim().isEmpty || password.trim().isEmpty) return false;
    return true;
  }
}
