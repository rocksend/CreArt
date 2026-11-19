import 'package:flutter/material.dart';
import 'detail_postingan_page.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreArt', style: TextStyle(fontFamily: 'Serif')),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Halo, Ardi.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Temukan ide untuk karya berikutnya.', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 20),
            
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari karya atau kreator',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 16),
            
            // Kategori Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildChip('Semua', true),
                  _buildChip('Ilustrasi', false),
                  _buildChip('Fotografi', false),
                  _buildChip('Desain', false),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Section: Untuk inspirasimu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Untuk inspirasimu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: const Text('Lihat semua', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
              ],
            ),
            
            // Horizontal Card List
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildArtCard(context, 'Ruang Sunyi', 'Nara Putri', '86', 'Digital Art'),
                  _buildArtCard(context, 'Jeda di Pagi Hari', 'Ayu Laras', '52', 'Fotografi'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Section: Karya terbaru
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Karya terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: const Text('Jelajahi', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
              ],
            ),
            
            // Vertical List (Karya Terbaru)
            _buildListArtCard('Senja di Kota', 'Dimas Pratama', 'Ilustrasi • 24 apresiasi'),
            _buildListArtCard('Bentuk dan Ruang', 'Bima Aditya', 'Desain • 18 apresiasi'),
          ],
        ),
      ),
    );
  }

  // Widget bantuan untuk Chip Kategori
  Widget _buildChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(
          label, 
          style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12)
        ),
        backgroundColor: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // Widget bantuan untuk Kartu "Untuk inspirasimu"
  Widget _buildArtCard(BuildContext context, String title, String creator, String likes, String category) {
    return GestureDetector(
      onTap: () {
        // Perintah untuk pindah ke halaman Detail Postingan
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailPostinganPage()),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text(category, style: const TextStyle(color: Colors.grey))),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(creator, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                Row(
                  children: [
                    const Icon(Icons.favorite_border, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(likes, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                )
              ],
            )
          ],
        ),
      ), // <-- PENUTUP CONTAINER
    ); // <-- INI PENUTUP GESTURE DETECTOR YANG TADI HILANG
  }

  // Widget bantuan untuk Kartu "Karya terbaru"
  Widget _buildListArtCard(String title, String creator, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text('Img', style: TextStyle(color: Colors.grey, fontSize: 12))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(creator, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}