import 'package:flutter/material.dart';
import '../creart_store.dart';

class DetailPostinganPage extends StatefulWidget {
  final Artwork artwork;

  const DetailPostinganPage({
    super.key,
    required this.artwork,
  });

  @override
  State<DetailPostinganPage> createState() => _DetailPostinganPageState();
}

class _DetailPostinganPageState extends State<DetailPostinganPage> {
  final CreArtStore _store = CreArtStore.instance;
  final TextEditingController _commentController = TextEditingController();

  final Map<String, List>_commentsByArtworkId = {
    '1': [
      {
        'author': 'Ayu Laras',
        'time': '15 menit lalu',
        'text': 'Suka suasananya, terasa hangat!',
      },
    ],
  };

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment(String artworkId) {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      final list = _commentsByArtworkId.putIfAbsent(artworkId, () => []);
      list.insert(0, {
        'author': _store.userName,
        'time': 'Baru saja',
        'text': text,
      });
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, child) {
        final Artwork artwork = _store.artworks.cast<Artwork?>().firstWhere(
              (item) => item?.id == widget.artwork.id && item!.id.isNotEmpty,
              orElse: () => widget.artwork,
            ) ??
            widget.artwork;

        final comments = _commentsByArtworkId[artwork.id] ?? const [];

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Detail karya',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        artwork.color1,
                        artwork.color2,
                        const Color(0xFFD8E8E3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.palette_outlined,
                      size: 48,
                      color: Color(0xFF7052C8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  artwork.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  artwork.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artwork.creator,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '@${artwork.creator.toLowerCase().replaceAll(' ', '')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Lihat profil',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildActionButton(
                      context,
                      artwork.isLiked ? Icons.favorite : Icons.favorite_border,
                      '${artwork.likes} apresiasi',
                      isActive: artwork.isLiked,
                      onPressed: () => _store.toggleLike(artwork),
                    ),
                    _buildActionButton(
                      context,
                      artwork.isSaved
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      artwork.isSaved ? 'Tersimpan' : 'Simpan',
                      isActive: artwork.isSaved,
                      onPressed: () => _store.toggleSave(artwork),
                    ),
                    _buildActionButton(
                      context,
                      Icons.share_outlined,
                      'Bagikan',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tautan "${artwork.title}" disalin.'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  artwork.description,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                const Divider(height: 36, thickness: 1),
                Text(
                  'Komentar (${comments.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                if (comments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Belum ada komentar. Jadilah yang pertama berkomentar!',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 16,
                          child: const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                comment['author'] ?? 'Pengguna',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              comment['time'] ?? '',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(comment['text'] ?? ''),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submitComment(artwork.id),
                      decoration: InputDecoration(
                        hintText: 'Tulis komentar...',
                        hintStyle: const TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => _submitComment(artwork.id),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
        side: BorderSide(
          color: isActive ? color : const Color(0xFFE9E3F0),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: Icon(icon, size: 16, color: color),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onPressed,
    );
  }
}