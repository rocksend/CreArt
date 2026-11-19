import 'package:flutter/material.dart';

class KategoriPage extends StatelessWidget {
  const KategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jelajahi kategori', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ikuti rasa ingin tahumu.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Temukan karya dari beragam sudut seni.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari kategori, karya, atau kreator',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
            const SizedBox(height: 20),
            // List Kategori
            _buildCategoryItem('Ilustrasi', 'Sketsa, karakter, dan cerita visual'),
            _buildCategoryItem('Fotografi', 'Momen dari sudut pandang'),
            _buildCategoryItem('Desain', 'Bentuk, tata letak, dan identitas'),
            _buildCategoryItem('Digital Art', 'Eksperimen seni digital'),
            _buildCategoryItem('Lainnya', 'Tulisan dan bentuk kreatif lainnya'),
            const SizedBox(height: 24),
            // Section Pilihan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pilihan Ilustrasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('Lihat semua', style: TextStyle(color: Colors.grey, fontSize: 12))),
              ],
            ),
            // Grid Pilihan
            Row(
              children: [
                Expanded(child: _buildGridItem('Senja di Kota', '24')),
                const SizedBox(width: 16),
                Expanded(child: _buildGridItem('Kebun Imaji', '41')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }

  Widget _buildGridItem(String title, String likes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
          child: const Center(child: Text('Ilustrasi', style: TextStyle(color: Colors.grey))),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Row(
          children: [
            const Icon(Icons.favorite_border, size: 12, color: Colors.grey),
            const SizedBox(width: 4),
            Text(likes, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        )
      ],
    );
  }
}