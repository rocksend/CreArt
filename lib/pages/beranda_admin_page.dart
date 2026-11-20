
import 'package:flutter/material.dart';
import '../creart_store.dart';

class BerandaAdminPage extends StatelessWidget {
  const BerandaAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = CreArtStore.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, child) {
        final activePosts = store.activeArtworks;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Admin CreArt',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Fitur logout akan diintegrasikan pada tahap login Admin.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ringkasan pengelolaan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Pantau dan kelola postingan pengguna CreArt.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 20),

                // Statistik Dashboard
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        store.totalActiveArtworks.toString(),
                        'Postingan aktif',
                        Icons.image_outlined,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        store.totalDeletedArtworks.toString(),
                        'Terhapus',
                        Icons.delete_outline,
                        Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kelola Postingan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${activePosts.length} postingan',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Daftar postingan aktif
                if (activePosts.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 42,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Belum ada postingan aktif.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                else
                  ...activePosts.map(
                    (artwork) => _buildAdminPostItem(
                      context,
                      artwork,
                      store,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget statistik
  Widget _buildStatCard(
    String number,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            number,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Widget daftar postingan
  Widget _buildAdminPostItem(
    BuildContext context,
    Artwork artwork,
    CreArtStore store,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [artwork.color1, artwork.color2],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.image_outlined,
            color: Colors.white,
          ),
        ),

        title: Text(
          artwork.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${artwork.creator} • ${artwork.category}',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'detail') {
              _showArtworkDetail(context, artwork);
            } else if (value == 'delete') {
              _confirmDelete(context, artwork, store);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'detail',
              child: Row(
                children: [
                  Icon(Icons.visibility_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Detail'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Hapus',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menampilkan detail postingan
  void _showArtworkDetail(
    BuildContext context,
    Artwork artwork,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Detail Postingan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                artwork.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 12),
              Text('Kreator: ${artwork.creator}'),
              Text('Kategori: ${artwork.category}'),
              Text('Apresiasi: ${artwork.likes}'),
              const SizedBox(height: 12),
              const Text(
                'Deskripsi:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(artwork.description),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  // Konfirmasi penghapusan postingan
  void _confirmDelete(
    BuildContext context,
    Artwork artwork,
    CreArtStore store,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Postingan?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus postingan "${artwork.title}"? '
            'Status postingan akan diubah menjadi terhapus.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final success = store.deleteArtwork(artwork.id);

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Postingan berhasil dihapus.'
                          : 'Postingan gagal dihapus.',
                    ),
                  ),
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
