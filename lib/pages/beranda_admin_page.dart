
import 'package:flutter/material.dart';
import '../creart_store.dart';

class BerandaAdminPage extends StatefulWidget {
  const BerandaAdminPage({super.key});

  @override
  State<BerandaAdminPage> createState() => _BerandaAdminPageState();
}

class _BerandaAdminPageState extends State<BerandaAdminPage> {
  final CreArtStore store = CreArtStore.instance;

  int selectedMenu = 0;

  static const Color primary = Color(0xFF8B5CC7);
  static const Color lightPurple = Color(0xFFF1E8FF);
  static const Color background = Color(0xFFFAF8FD);
  static const Color textDark = Color(0xFF29233F);

  final List<String> menuTitles = [
    'Dashboard',
    'Manajemen Postingan',
    'Manajemen Pengguna',
    'Statistik',
    'Pengaturan',
  ];

  final List<IconData> menuIcons = [
    Icons.dashboard_outlined,
    Icons.image_outlined,
    Icons.people_outline,
    Icons.bar_chart_outlined,
    Icons.settings_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 850;

            if (isDesktop) {
              return _buildDesktopLayout();
            }

            return _buildMobileLayout();
          },
        );
      },
    );
  }

  // ================= DESKTOP LAYOUT =================

  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: background,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildDesktopHeader(),
                Expanded(
                  child: _buildPageContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 245,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 28),

          // Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.palette_outlined,
                color: primary,
                size: 35,
              ),
              const SizedBox(width: 8),
              const Text(
                'CreArt',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'ADMIN',
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),

          const SizedBox(height: 35),

          ...List.generate(menuTitles.length, (index) {
            return _buildMenuItem(index);
          }),

          const Spacer(),

          _buildAdminProfile(),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildLogoutButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index) {
    final isSelected = selectedMenu == index;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 4,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          setState(() {
            selectedMenu = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: isSelected ? lightPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                menuIcons[index],
                color: isSelected ? primary : textDark,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  menuTitles[index],
                  style: TextStyle(
                    color: isSelected ? primary : textDark,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: lightPurple,
            child: const Text(
              'A',
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin CreArt',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Administrator',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEDE8F4)),
        ),
      ),
      child: Row(
        children: [
          Text(
            menuTitles[selectedMenu],
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            backgroundColor: lightPurple,
            child: Text(
              'A',
              style: TextStyle(color: primary),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Admin CreArt',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ================= MOBILE LAYOUT =================

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: const Text(
          'CreArt Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),

              const Icon(
                Icons.palette_outlined,
                color: primary,
                size: 45,
              ),

              const SizedBox(height: 8),

              const Text(
                'CreArt',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'ADMIN PANEL',
                style: TextStyle(
                  color: primary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              _buildAdminProfile(),

              const SizedBox(height: 25),

              ...List.generate(menuTitles.length, (index) {
                return _buildMenuItem(index);
              }),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.all(18),
                child: _buildLogoutButton(),
              ),
            ],
          ),
        ),
      ),

      body: _buildPageContent(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedMenu,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: (index) {
          setState(() {
            selectedMenu = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image_outlined),
            label: 'Postingan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Pengguna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Statistik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }

  // ================= PAGE CONTENT =================

  Widget _buildPageContent() {
    switch (selectedMenu) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildPostManagement();
      case 2:
        return _buildUserManagement();
      case 3:
        return _buildStatistics();
      case 4:
        return _buildSettings();
      default:
        return _buildDashboard();
    }
  }

  // ================= DASHBOARD =================

  Widget _buildDashboard() {
    final activePosts = store.activeArtworks;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFF1E8FF),
                  Color(0xFFE5D6FA),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, Admin CreArt! 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Pantau dan kelola aktivitas komunitas kreatif CreArt.',
                  style: TextStyle(color: textDark),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Statistik
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount =
                  constraints.maxWidth > 650 ? 4 : 2;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisExtent: 145,
                children: [
                  _buildStatCard(
                    store.totalActiveArtworks.toString(),
                    'Postingan Aktif',
                    Icons.image_outlined,
                    const Color(0xFF8B5CC7),
                  ),
                  _buildStatCard(
                    store.totalDeletedArtworks.toString(),
                    'Post Terhapus',
                    Icons.delete_outline,
                    Colors.redAccent,
                  ),
                  _buildStatCard(
                    activePosts.length.toString(),
                    'Konten Tersedia',
                    Icons.collections_outlined,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    '—',
                    'Total Pengguna',
                    Icons.people_outline,
                    Colors.orange,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 28),

          _buildSectionHeader(
            'Postingan Terbaru',
            '${activePosts.length} postingan',
          ),

          const SizedBox(height: 12),

          if (activePosts.isEmpty)
            _buildEmptyState()
          else
            ...activePosts.take(5).map(
              (artwork) => _buildAdminPostItem(
                context,
                artwork,
                store,
              ),
            ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedMenu = 1;
                });
              },
              child: const Text('Lihat Semua Postingan'),
            ),
          ),
        ],
      ),
    );
  }

  // ================= POST MANAGEMENT =================

  Widget _buildPostManagement() {
    final activePosts = store.activeArtworks;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kelola seluruh postingan yang dibagikan di CreArt.',
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 20),

          _buildStatCard(
            activePosts.length.toString(),
            'Postingan Aktif',
            Icons.image_outlined,
            primary,
          ),

          const SizedBox(height: 24),

          _buildSectionHeader(
            'Daftar Postingan',
            '${activePosts.length} konten',
          ),

          const SizedBox(height: 12),

          if (activePosts.isEmpty)
            _buildEmptyState()
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
    );
  }

  // ================= USER MANAGEMENT =================

  Widget _buildUserManagement() {
    return _buildPlaceholderPage(
      Icons.people_outline,
      'Manajemen Pengguna',
      'Halaman pengelolaan pengguna CreArt akan dikembangkan pada tahap berikutnya.',
    );
  }

  // ================= STATISTICS =================

  Widget _buildStatistics() {
    return _buildPlaceholderPage(
      Icons.bar_chart_outlined,
      'Statistik CreArt',
      'Visualisasi data aktivitas, pertumbuhan pengguna, dan postingan akan tersedia di sini.',
    );
  }

  // ================= SETTINGS =================

  Widget _buildSettings() {
    return _buildPlaceholderPage(
      Icons.settings_outlined,
      'Pengaturan Admin',
      'Pengaturan akun dan informasi administrator akan tersedia di halaman ini.',
    );
  }

  Widget _buildPlaceholderPage(
    IconData icon,
    String title,
    String description,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: lightPurple,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 45,
                color: primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ================= COMPONENTS =================

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String number,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDE8F4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            number,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 45,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            'Belum ada postingan aktif.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminPostItem(
    BuildContext context,
    Artwork artwork,
    CreArtStore store,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFEDE8F4)),
        borderRadius: BorderRadius.circular(16),
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
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.image_outlined,
            color: Colors.white,
          ),
        ),
        title: Text(
          artwork.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${artwork.creator} • ${artwork.category}',
            maxLines: 2,
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

  // ================= POST DETAIL =================

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

  // ================= DELETE POST =================

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
            'Apakah kamu yakin ingin menghapus postingan '
            '"${artwork.title}"? Status postingan akan diubah menjadi terhapus.',
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
              onPressed: () async {
                try {
                  final success = await store.deleteArtwork(artwork.id);

                  if (!dialogContext.mounted) return;
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
                } catch (e) {
                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Post gagal dihapus.'),
                    ),
                  );
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // ================= LOGOUT =================

  Widget _buildLogoutButton() {
    return OutlinedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout Firebase akan kita sambungkan berikutnya.'),
          ),
        );
      },
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text(
        'Logout',
        style: TextStyle(color: Colors.red),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: const BorderSide(color: Colors.redAccent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
