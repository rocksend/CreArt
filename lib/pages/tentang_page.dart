import 'package:flutter/material.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tentang CreArt', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CreArt',
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'Serif',
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('Create + Art', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            const Text(
              'Ruang berbagi karya, tempat tumbuhnya inspirasi.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'CreArt adalah wadah untuk membagikan dan mengeksplorasi karya seni digital maupun tulisan. Setiap karya membuka percakapan, apresiasi, dan ide baru.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 32),
            const Text(
              'Untuk siapa saja',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.brush,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text(
                'Untuk kreator',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Bagikan karya dan tulisan, bangun profil, dan terhubung lewat apresiasi.',
              ),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(
                Icons.visibility,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: const Text(
                'Untuk penikmat seni',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Jelajahi kategori, temukan kreator, dan simpan inspirasi dalam koleksi.',
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
