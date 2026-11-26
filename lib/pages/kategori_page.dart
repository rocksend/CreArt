import 'package:flutter/material.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  String _selectedCategory = 'Ilustrasi';

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
            _buildCategoryItem(
              'Ilustrasi',
              'Sketsa, karakter, dan cerita visual',
              Icons.draw_outlined,
            ),
            _buildCategoryItem(
              'Fotografi',
              'Momen dari sudut pandang',
              Icons.camera_alt_outlined,
            ),
            _buildCategoryItem(
              'Desain',
              'Bentuk, tata letak, dan identitas',
              Icons.auto_awesome_outlined,
            ),
            _buildCategoryItem(
              'Digital Art',
              'Eksperimen seni digital',
              Icons.palette_outlined,
            ),
            _buildCategoryItem(
              'Lainnya',
              'Tulisan dan bentuk kreatif lainnya',
              Icons.more_horiz,
            ),
            const SizedBox(height: 24),
            // Section Pilihan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pilihan $_selectedCategory',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text('Lihat semua', style: TextStyle(color: Colors.grey, fontSize: 12))),
              ],
            ),
            // Grid Pilihan
            Row(
              children: [
                Expanded(child: _buildGridItem(context, 'Senja di Kota', '24')),
                const SizedBox(width: 16),
                Expanded(child: _buildGridItem(context, 'Kebun Imaji', '41')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, String subtitle, IconData icon) {
    final isSelected = _selectedCategory == title;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF5F0FC) : Colors.white,
        border: Border.all(
          color: isSelected
              ? const Color(0x5C7052C8)
              : const Color(0xFFE9E3F0),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSelected
              ? const Color(0xFFE9DDFB)
              : const Color(0xFFF5F0FC),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Icon(
          isSelected ? Icons.check_circle : Icons.chevron_right,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
        onTap: () => setState(() => _selectedCategory = title),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, String likes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF3C7A7), Color(0xFFE9DDFB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.palette_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
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