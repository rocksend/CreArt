import 'package:flutter/material.dart';

import 'tentang_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool _showSavedWorks = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil akun',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Pindah ke Halaman Tentang CreArt
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TentangPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Info User
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFE9DDFB),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ardiansyah',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@ardiansyahganteng',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Merekam cerita kota lewat garis dan warna. Selalu mencari sudut pandang baru.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            // Statistik
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(angka: '12', label: 'Karya'),
                _StatItem(angka: '248', label: 'Apresiasi'),
                _StatItem(angka: '8', label: 'Tersimpan'),
              ],
            ),
            const SizedBox(height: 20),
            // Tombol Edit Profil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: const BorderSide(color: Color(0xFFDCD1F2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Edit profil'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Tab Kategori (Karya Saya / Koleksi Tersimpan)
            Row(
              children: [
                _buildProfileTab(context, 'Karya saya (12)', false),
                _buildProfileTab(context, 'Koleksi tersimpan (8)', true),
              ],
            ),
            // Grid Karya
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
                children: [
                  _buildArtGridItem(
                    _showSavedWorks ? 'Ruang Sunyi' : 'Senja di Kota',
                    _showSavedWorks ? '86' : '24',
                  ),
                  _buildArtGridItem(
                    _showSavedWorks ? 'Jeda di Pagi Hari' : 'Garis Kota',
                    _showSavedWorks ? '52' : '32',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context, String label, bool isSavedTab) {
    final isSelected = _showSavedWorks == isSavedTab;
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : const Color(0xFFAAA4B4);
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _showSavedWorks = isSavedTab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? color : const Color(0xFFE9E3F0),
                width: isSelected ? 2 : 1,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF29243A) : color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArtGridItem(String title, String likes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF3C7A7), Color(0xFFE9DDFB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.palette_outlined, color: Color(0xFF7052C8)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Dimas Pratama',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Row(
              children: [
                const Icon(Icons.favorite_border, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  likes,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String angka;
  final String label;

  const _StatItem({required this.angka, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          angka,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
