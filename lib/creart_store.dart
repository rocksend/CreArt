

import 'package:flutter/material.dart';

class Artwork {
  final String id;
  final String title;
  final String creator;
  final String category;
  final String description;
  final Color color1;
  final Color color2;
  final DateTime createdAt;

  int likes;
  bool isLiked;
  bool isSaved;

  // Status moderasi postingan
  String status;

  Artwork({
    required this.id,
    required this.title,
    required this.creator,
    required this.category,
    required this.description,
    this.color1 = const Color(0xFFE9DDFB),
    this.color2 = const Color(0xFFF3C7A7),
    this.likes = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.status = 'aktif',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class CreArtStore extends ChangeNotifier {
  CreArtStore._();

  static final CreArtStore instance = CreArtStore._();

  String userName = 'Ardiansyah';
  String username = 'ardiansyahganteng';
  String email = 'ardi@email.com';
  String bio =
      'Merekam cerita kota lewat garis dan warna. Selalu mencari sudut pandang baru.';

  final List<Artwork> artworks = [
    Artwork(
      id: '1',
      title: 'Senja di Kota',
      creator: 'Dimas Pratama',
      category: 'Ilustrasi',
      description: 'Sebuah jeda di tengah riuh kota.',
      likes: 24,
    ),
    Artwork(
      id: '2',
      title: 'Ruang Sunyi',
      creator: 'Nara Putri',
      category: 'Digital Art',
      description: 'Tentang ruang, ketenangan, dan imajinasi.',
      likes: 86,
    ),
    Artwork(
      id: '3',
      title: 'Jeda di Pagi Hari',
      creator: 'Ayu Laras',
      category: 'Fotografi',
      description: 'Mengabadikan keindahan pagi.',
      likes: 52,
    ),
    Artwork(
      id: '4',
      title: 'Garis Kota',
      creator: 'Bima Aditya',
      category: 'Desain',
      description: 'Eksplorasi bentuk dan ruang perkotaan.',
      likes: 32,
    ),
    Artwork(
      id: '5',
      title: 'Kebun Imaji',
      creator: 'Nara Putri',
      category: 'Ilustrasi',
      description: 'Taman kecil penuh warna dan cerita.',
      likes: 41,
    ),
  ];

  final List<String> comments = [];

  // Mengambil postingan yang masih aktif
  List<Artwork> get activeArtworks =>
      artworks.where((art) => art.status == 'aktif').toList();

  // Mengambil postingan yang sudah dihapus
  List<Artwork> get deletedArtworks =>
      artworks.where((art) => art.status == 'terhapus').toList();

  // Menghitung jumlah postingan aktif
  int get totalActiveArtworks => activeArtworks.length;

  // Menghitung jumlah postingan terhapus
  int get totalDeletedArtworks => deletedArtworks.length;

  // Mengambil karya yang disimpan dan masih aktif
  List<Artwork> get savedArtworks =>
      activeArtworks.where((art) => art.isSaved).toList();

  // Mengambil karya milik pengguna yang masih aktif
  List<Artwork> get myArtworks =>
      activeArtworks.where((art) => art.creator == userName).toList();

  // Mencari postingan berdasarkan ID
  Artwork? getArtworkById(String id) {
    try {
      return artworks.firstWhere((art) => art.id == id);
    } catch (_) {
      return null;
    }
  }

  // Mengubah status postingan menjadi terhapus
  bool deleteArtwork(String id) {
    final artwork = getArtworkById(id);

    if (artwork == null || artwork.status == 'terhapus') {
      return false;
    }

    artwork.status = 'terhapus';
    notifyListeners();
    return true;
  }

  void addArtwork({
    required String title,
    required String description,
    required String category,
  }) {
    artworks.insert(
      0,
      Artwork(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        creator: userName,
        category: category,
        description: description,
        color1: const Color(0xFFE9DDFB),
        color2: const Color(0xFFD8E8E3),
      ),
    );
    notifyListeners();
  }

  void toggleLike(Artwork artwork) {
    if (artwork.status == 'terhapus') return;

    artwork.isLiked = !artwork.isLiked;
    artwork.likes += artwork.isLiked ? 1 : -1;
    notifyListeners();
  }

  void toggleSave(Artwork artwork) {
    if (artwork.status == 'terhapus') return;

    artwork.isSaved = !artwork.isSaved;
    notifyListeners();
  }

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

