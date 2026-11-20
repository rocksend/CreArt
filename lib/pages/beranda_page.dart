
import 'package:flutter/material.dart';
import 'beranda_admin_page.dart';
import '../creart_store.dart';
import 'detail_postingan_page.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    final store = CreArtStore.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, child) {
        // Mengambil hanya postingan yang masih aktif.
        final activeArtworks = store.activeArtworks;

        // Filter berdasarkan kategori yang dipilih.
        final filteredArtworks = _selectedCategory == 'Semua'
            ? activeArtworks
            : activeArtworks
                .where((art) => art.category == _selectedCategory)
                .toList();

        // Dua karya pertama untuk bagian inspirasi.
        final inspirationArtworks = filteredArtworks.take(2).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'CreArt',
              style: TextStyle(fontFamily: 'Serif'),
            ),
            centerTitle: false,
            actions: [
  IconButton(
    icon: const Icon(Icons.admin_panel_settings_outlined),
    tooltip: 'Buka Dashboard Admin',
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BerandaAdminPage(),
        ),
      );
    },
  ),
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
                const Text(
                  'Halo, Ardi.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Temukan ide untuk karya berikutnya.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari karya atau kreator',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Kategori Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChip('Semua'),
                      _buildChip('Ilustrasi'),
                      _buildChip('Fotografi'),
                      _buildChip('Desain'),
                      _buildChip('Digital Art'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section: Untuk inspirasimu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Untuk inspirasimu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Lihat semua',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                // Horizontal Card List
                SizedBox(
                  height: 200,
                  child: inspirationArtworks.isEmpty
                      ? const Center(
                          child: Text('Belum ada karya tersedia.'),
                        )
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          children: inspirationArtworks.map((art) {
                            return _buildArtCard(context, art);
                          }).toList(),
                        ),
                ),

                const SizedBox(height: 24),

                // Section: Karya terbaru
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Karya terbaru',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Jelajahi',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                // Vertical List
                if (filteredArtworks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text('Tidak ada karya dalam kategori ini.'),
                    ),
                  )
                else
                  ...filteredArtworks.map((art) {
                    return _buildListArtCard(art);
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget Chip Kategori
  Widget _buildChip(String label) {
    final isSelected = _selectedCategory == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : const Color(0xFF514B5E),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _selectedCategory = label;
          });
        },
        selectedColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.white,
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : const Color(0xFFE9E3F0),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  // Kartu Untuk Inspirasimu
  Widget _buildArtCard(BuildContext context, Artwork artwork) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DetailPostinganPage(),
          ),
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
                gradient: LinearGradient(
                  colors: [
                    artwork.color1,
                    artwork.color2,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  artwork.category,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              artwork.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    artwork.creator,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      artwork.likes.toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Kartu Karya Terbaru
  Widget _buildListArtCard(Artwork artwork) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  artwork.color1,
                  artwork.color2,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.image_outlined,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artwork.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  artwork.creator,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '${artwork.category} • ${artwork.likes} apresiasi',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
