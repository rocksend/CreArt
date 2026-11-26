
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Artwork {
  final String id;
  final String title;
  final String creator;
  final String category;
  final String description;
  final String? imageUrl;
  final Color color1;
  final Color color2;
  final DateTime createdAt;

  int likes;
  bool isLiked;
  bool isSaved;
  String status;

  Artwork({
    required this.id,
    required this.title,
    required this.creator,
    required this.category,
    required this.description,
    this.imageUrl,
    this.color1 = const Color(0xFFE9DDFB),
    this.color2 = const Color(0xFFF3C7A7),
    this.likes = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.status = 'aktif',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "creator": creator,
      "category": category,
      "description": description,
      "imageUrl": imageUrl,
      "color1": color1.value,
      "color2": color2.value,
      "likes": likes,
      "isLiked": isLiked,
      "isSaved": isSaved,
      "status": status,
      "createdAt": Timestamp.fromDate(createdAt),
    };
  }

  factory Artwork.fromFirestore(
    String docId,
    Map<String, dynamic> data,
  ) {
    final ts = data['createdAt'];
    final rawImageUrl = data['imageUrl'];

    return Artwork(
      id: docId,
      title: data['title'] ?? '',
      creator: data['creator'] ?? '',
      category: data['category'] ?? 'Lainnya',
      description: data['description'] ?? '',
      imageUrl: rawImageUrl is String && rawImageUrl.isNotEmpty
          ? rawImageUrl
          : null,
      color1: Color(data['color1'] ?? 0xFFE9DDFB),
      color2: Color(data['color2'] ?? 0xFFF3C7A7),
      likes: data['likes'] ?? 0,
      isLiked: data['isLiked'] ?? false,
      isSaved: data['isSaved'] ?? false,
      status: data['status'] ?? 'aktif',
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }
}

class CreArtStore extends ChangeNotifier {
  CreArtStore._() {
    initFirestoreListener();
  }

  static final CreArtStore instance = CreArtStore._();

  static const String _cloudinaryCloudName = 'wbesiexk';
  static const String _cloudinaryUploadPreset = 'creart_unsigned';

  final _artworksRef =
      FirebaseFirestore.instance.collection('artworks');

  String userName = 'Ardiansyah';
  String username = 'ardiansyahganteng';
  String email = 'ardi@email.com';
  String bio =
      'Merekam cerita kota lewat garis dan warna. '
      'Selalu mencari sudut pandang baru.';

  List<Artwork> artworks = [];
  List<String> comments = [];

  bool isLoading = true;

  void initFirestoreListener() {
    _artworksRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      artworks = snapshot.docs
          .map((doc) => Artwork.fromFirestore(doc.id, doc.data()))
          .toList();

      isLoading = false;
      notifyListeners();
    }, onError: (error) {
      isLoading = false;
      notifyListeners();
    });
  }

  Future<String> _uploadToCloudinary(File imageFile) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/'
      '$_cloudinaryCloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _cloudinaryUploadPreset
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

    final streamedResponse = await request.send();
    final responseBody =
        await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200 &&
        streamedResponse.statusCode != 201) {
      throw Exception(
        'Upload ke Cloudinary gagal '
        '(${streamedResponse.statusCode}): $responseBody',
      );
    }

    final decoded =
        jsonDecode(responseBody) as Map<String, dynamic>;

    final secureUrl = decoded['secure_url'] as String?;

    if (secureUrl == null || secureUrl.isEmpty) {
      throw Exception(
        'URL gambar tidak ditemukan pada respons Cloudinary.',
 
      );
    }

    return secureUrl;
  }

  Future<void> addArtwork({
    required String title,
    required String description,
    required String category,
    File? imageFile,
  }) async {
    String? uploadedImageUrl;

    if (imageFile != null) {
      uploadedImageUrl =
          await _uploadToCloudinary(imageFile);
    }

    final newArt = Artwork(
      id: '',
      title: title,
      creator: userName,
      category: category,
      description: description,
      imageUrl: uploadedImageUrl,
      status: 'aktif',
    );

    await _artworksRef.add(newArt.toMap());
  }

  Future<void> toggleLike(Artwork artwork) async {
    if (artwork.status == 'terhapus') return;

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
    if (artwork.status == 'terhapus') return;

    artwork.isSaved = !artwork.isSaved;

    notifyListeners();

    if (artwork.id.isNotEmpty) {
      await _artworksRef.doc(artwork.id).update({
        'isSaved': artwork.isSaved,
      });
    }
  }

  // Postingan yang masih aktif
  List<Artwork> get activeArtworks =>
      artworks.where((art) => art.status == 'aktif').toList();

  // Postingan yang telah dihapus Admin
  List<Artwork> get deletedArtworks =>
      artworks.where((art) => art.status == 'terhapus').toList();

  // Jumlah postingan aktif
  int get totalActiveArtworks => activeArtworks.length;

  // Jumlah postingan terhapus
  int get totalDeletedArtworks => deletedArtworks.length;

  // Karya tersimpan dan masih aktif
  List<Artwork> get savedArtworks =>
      activeArtworks.where((art) => art.isSaved).toList();

  // Karya milik pengguna dan masih aktif
  List<Artwork> get myArtworks =>
      activeArtworks.where((art) => art.creator == userName).toList();

  // Cari artwork berdasarkan ID
  Artwork? getArtworkById(String id) {
    try {
      return artworks.firstWhere((art) => art.id == id);
    } catch (_) {
      return null;
    }
  }

  // Soft delete artwork melalui Firebase
  Future<bool> deleteArtwork(String id) async {
    final artwork = getArtworkById(id);

    if (artwork == null || artwork.status == 'terhapus') {
      return false;
    }

    try {
      await _artworksRef.doc(id).update({
        'status': 'terhapus',
      });

      artwork.status = 'terhapus';
      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  // Menambahkan komentar lokal
  void addComment(String comment) {
    if (comment.trim().isEmpty) return;

    comments.insert(0, comment.trim());
    notifyListeners();
  }

  bool login(String identifier, String password) {
    if (identifier.trim().isEmpty || password.trim().isEmpty) {
      return false;
    }

    return true;
  }

  bool register({
    required String name,
    required String username,
    required String email,
    required String password,
    required String confirmation,
  }) {
    if (name.trim().isEmpty ||
        username.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty ||
        confirmation.isEmpty ||
        !email.contains('@') ||
        password.length < 6 ||
        password != confirmation) {
      return false;
    }

    userName = name.trim();
    this.username = username.trim();
    this.email = email.trim();

    notifyListeners();
    return true;
  }

  void updateProfile({
    required String name,
    required String username,
    required String bio,
  }) {
    userName = name;
    this.username = username;
    this.bio = bio;

    notifyListeners();
  }
}
