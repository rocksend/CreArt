
import 'package:flutter/material.dart';
import '../creart_store.dart';
import 'detail_postingan_page.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final CreArtStore _store = CreArtStore.instance;
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  final List<String> categories = [
    'Semua',
    'Ilustrasi',
    'Fotografi',
    'Desain',
    'Digital Art',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CreArt',
          style: TextStyle(fontFamily: 'Serif'),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _store,
        builder: (context, child) {
          if (_store.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Hanya menampilkan karya yang aktif
          final activeArtworks = _store.activeArtworks;

          // Filter kategori dan pencarian
          final filteredArtworks = activeArtworks.where((art) {
            final matchesCategory = _selectedCategory == 'Semua' ||
                art.category.toLowerCase() ==
                    _selectedCategory.toLowerCase();

            final matchesSearch = _searchQuery.isEmpty ||
                art.title.toLowerCase().contains(_searchQuery) ||
                art.creator.toLowerCase().contains(_searchQuery);

            return matchesCategory && matchesSearch;
          }).toList();

          final inspirationArtworks =
              filteredArtworks.take(2).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${_store.userName}.',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
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
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari karya atau kreator',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
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

                // Kategori
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      return _buildChip(category);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Section Inspirasi
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

                // Horizontal Card
                SizedBox(
                  height: 205,
                  child: inspirationArtworks.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada karya tersedia.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: inspirationArtworks.length,
                          itemBuilder: (context, index) {
                            final art = inspirationArtworks[index];
                            return _buildArtCard(context, art);
                          },
                        ),
                ),
                const SizedBox(height: 24),

                // Section Karya Terbaru
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
                      child: Text(
                        'Tidak ada karya yang sesuai.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredArtworks.length,
                    itemBuilder: (context, index) {
                      final art = filteredArtworks[index];
                      return _buildListArtCard(context, art);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Chip kategori
  Widget _buildChip(String label) {
    final isSelected = _selectedCategory == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
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

  // Card untuk inspirasi
  Widget _buildArtCard(BuildContext context, Artwork art) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPostinganPage(
              artwork: art,
            ),
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
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                gradient: art.imageUrl == null
                    ? LinearGradient(
                        colors: [art.color1, art.color2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: art.imageUrl != null
                  ? Image.network(
                      art.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Center(
                          child: Text(
                            art.category,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        art.category,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              art.title,
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
                    art.creator,
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
                    Icon(
                      art.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 12,
                      color: art.isLiked ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${art.likes}',
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

  // Card untuk karya terbaru
  Widget _buildListArtCard(BuildContext context, Artwork art) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPostinganPage(
                artwork: art,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                gradient: art.imageUrl == null
                    ? LinearGradient(
                        colors: [art.color1, art.color2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: art.imageUrl != null
                  ? Image.network(
                      art.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Icon(
                          Icons.palette_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        );
                      },
                    )
                  : Icon(
                      Icons.palette_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    art.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    art.creator,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${art.category} • ${art.likes} apresiasi',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
