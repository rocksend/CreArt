import 'package:flutter/material.dart';
import '../creart_store.dart';

class DetailPostinganPage extends StatefulWidget {
  const DetailPostinganPage({super.key});

  @override
  State<DetailPostinganPage> createState() =>
      _DetailPostinganPageState();
}

class _DetailPostinganPageState
    extends State<DetailPostinganPage> {

  final CreArtStore store = CreArtStore.instance;

  late final Artwork artwork = store.artworks.first;
  bool _isLiked = false;
  int _likes = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Detail karya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {})],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Postingan
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF3C7A7), Color(0xFFE9DDFB), Color(0xFFD8E8E3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(Icons.palette_outlined, size: 48, color: Color(0xFF7052C8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('ILUSTRASI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 4),
                  const Text('Senja di Kota', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // Profil Kreator
                  Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.grey[300], child: const Icon(Icons.person, color: Colors.grey)),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dimas Pratama', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('@dimaspratama', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      TextButton(onPressed: () {}, child: const Text('Lihat profil', style: TextStyle(color: Colors.black))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tombol Aksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(
                        context,
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        '$_likes apresiasi',
                        isActive: _isLiked,
                        onPressed: () => setState(() {
                          _isLiked = !_isLiked;
                          _likes += _isLiked ? 1 : -1;
                        }),
                      ),
                      _buildActionButton(
                        context,
                        artwork.isSaved ? Icons.bookmark : Icons.bookmark_border,
artwork.isSaved ? 'Tersimpan' : 'Simpan',
isActive: artwork.isSaved,
onPressed: () {
  store.toggleSave(artwork);
  setState(() {});
},
                      ),
                      _buildActionButton(
                        context,
                        Icons.share_outlined,
                        'Bagikan',
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sebuah jeda di tengah riuh kota. Eksplorasi cahaya senja dan siluet bangunan yang menyimpan banyak cerita.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const Divider(height: 40, thickness: 1),
                  // Komentar
                  const Text('Komentar (1)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(backgroundColor: Colors.grey[300], radius: 16, child: const Icon(Icons.person, size: 16, color: Colors.grey)),
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ayu Laras', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('15 menit lalu', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    subtitle: const Text('Suka suasananya, terasa hangat!'),
                  )
                ],
              ),
            ),
          ),
          // TextBox Komentar (Sticky di bawah)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tulis komentar...',
                      hintStyle: const TextStyle(fontSize: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: () {}),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label, {
    bool isActive = false,
    required VoidCallback onPressed,
  }) {
    final color = isActive
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.primary;
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: isActive ? color : const Color(0xFFE9E3F0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      icon: Icon(icon, size: 16, color: color),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onPressed,
    );
  }
}