import 'package:flutter/material.dart';

import '../creart_store.dart';
import 'detail_postingan_page.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  static const _categories = [
    _CategoryInfo(
      name: 'Semua',
      description: 'Jelajahi semua karya',
      icon: Icons.grid_view_rounded,
    ),
    _CategoryInfo(
      name: 'Ilustrasi',
      description: 'Sketsa dan cerita visual',
      icon: Icons.draw_outlined,
    ),
    _CategoryInfo(
      name: 'Fotografi',
      description: 'Momen dari berbagai sudut',
      icon: Icons.camera_alt_outlined,
    ),
    _CategoryInfo(
      name: 'Desain',
      description: 'Bentuk dan identitas',
      icon: Icons.auto_awesome_outlined,
    ),
    _CategoryInfo(
      name: 'Digital Art',
      description: 'Eksperimen seni digital',
      icon: Icons.palette_outlined,
    ),
    _CategoryInfo(
      name: 'Lainnya',
      description: 'Karya kreatif lainnya',
      icon: Icons.more_horiz,
    ),
  ];

  final _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = CreArtStore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jelajahi kategori',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, child) {
          final query = _searchQuery.toLowerCase();
          final visibleCategories = _categories.where((category) {
            return query.isEmpty ||
                category.name.toLowerCase().contains(query) ||
                category.description.toLowerCase().contains(query);
          }).toList();
          final visibleArtworks = store.artworks.where((artwork) {
            final matchesCategory =
                _selectedCategory == 'Semua' ||
                artwork.category.toLowerCase() ==
                    _selectedCategory.toLowerCase();
            final matchesSearch =
                query.isEmpty ||
                artwork.title.toLowerCase().contains(query) ||
                artwork.creator.toLowerCase().contains(query) ||
                artwork.category.toLowerCase().contains(query);
            return matchesCategory && matchesSearch;
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Temukan inspirasimu',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Jelajahi karya berdasarkan bidang seni.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _searchController,
                  onChanged: (value) =>
                      setState(() => _searchQuery = value.trim()),
                  decoration: InputDecoration(
                    hintText: 'Cari kategori, karya, atau kreator',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE9E3F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE9E3F0)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kategori seni',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${visibleCategories.length} kategori',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (visibleCategories.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'Kategori tidak ditemukan.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    itemCount: visibleCategories.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.65,
                        ),
                    itemBuilder: (context, index) {
                      final category = visibleCategories[index];
                      final count = category.name == 'Semua'
                          ? store.artworks.length
                          : store.artworks
                                .where(
                                  (artwork) =>
                                      artwork.category.toLowerCase() ==
                                      category.name.toLowerCase(),
                                )
                                .length;
                      return _buildCategoryCard(category, count);
                    },
                  ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _selectedCategory == 'Semua'
                            ? 'Karya terbaru'
                            : 'Karya $_selectedCategory',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${visibleArtworks.length} karya',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (store.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (visibleArtworks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? 'Belum ada karya di kategori ini.'
                            : 'Tidak ada karya yang cocok dengan pencarian.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    itemCount: visibleArtworks.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.86,
                        ),
                    itemBuilder: (context, index) =>
                        _buildArtworkCard(context, visibleArtworks[index]),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(_CategoryInfo category, int count) {
    final isSelected = _selectedCategory == category.name;
    final primary = Theme.of(context).colorScheme.primary;

    return Material(
      color: isSelected ? const Color(0xFFF5F0FC) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _selectedCategory = category.name),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFB7A2E8)
                  : const Color(0xFFE9E3F0),
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE9DDFB)
                      : const Color(0xFFF5F0FC),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(category.icon, size: 20, color: primary),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    Text(
                      '$count karya',
                      style: const TextStyle(
                        color: Color(0xFF7052C8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, size: 17, color: primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtworkCard(BuildContext context, Artwork artwork) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => DetailPostinganPage(artwork: artwork),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE9E3F0)),
            borderRadius: BorderRadius.circular(14),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 90,
                width: double.infinity,
                child: _buildArtworkImage(context, artwork),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artwork.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        artwork.creator,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            artwork.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 14,
                            color: artwork.isLiked ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${artwork.likes}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                          const Spacer(),
                          Flexible(
                            child: Text(
                              artwork.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF7052C8),
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtworkImage(BuildContext context, Artwork artwork) {
    if (artwork.imageUrl != null) {
      return Image.network(
        artwork.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildArtworkPlaceholder(artwork),
      );
    }
    return _buildArtworkPlaceholder(artwork);
  }

  Widget _buildArtworkPlaceholder(Artwork artwork) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [artwork.color1, artwork.color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.palette_outlined, color: Color(0xFF7052C8), size: 30),
      ),
    );
  }
}

class _CategoryInfo {
  const _CategoryInfo({
    required this.name,
    required this.description,
    required this.icon,
  });

  final String name;
  final String description;
  final IconData icon;
}
