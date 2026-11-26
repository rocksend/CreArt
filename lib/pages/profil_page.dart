import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../auth_service.dart';
import '../creart_store.dart';
import 'edit_profil_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _showSavedWorks = false;
  bool _isUpdatingPhoto = false;
  bool _isSigningOut = false;

  Future<void> _selectProfilePhoto() async {
    if (_isUpdatingPhoto) return;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Ambil foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pilih dari camera roll'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    try {
      final pickedImage = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (pickedImage == null || !mounted) return;

      setState(() => _isUpdatingPhoto = true);
      await CreArtStore.instance.updateProfilePhoto(File(pickedImage.path));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui foto profil: $error')),
      );
    } finally {
      if (mounted) setState(() => _isUpdatingPhoto = false);
    }
  }

  Future<void> _signOut() async {
    if (_isSigningOut) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu akan kembali ke halaman login.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isSigningOut = true);
    try {
      await CreArtAuthService.instance.signOut();
    } on FirebaseAuthException catch (error) {
      _showSignOutError(authErrorMessage(error));
    } on FirebaseException catch (error) {
      _showSignOutError(authErrorMessage(error));
    } catch (error) {
      _showSignOutError('Gagal keluar dari akun: $error');
    } finally {
      if (mounted) setState(() => _isSigningOut = false);
    }
  }

  void _showSignOutError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final store = CreArtStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, child) {
        final myArtworks = store.myArtworks;
        final savedArtworks = store.savedArtworks;
        final shownArtworks = _showSavedWorks ? savedArtworks : myArtworks;
        final appreciationCount = myArtworks.fold<int>(
          0,
          (total, artwork) => total + artwork.likes,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Profil akun',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const SizedBox(height: 24),
              if (store.profileLoadError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Gagal memuat data akun: ${store.profileLoadError}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF8F302A)),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    button: true,
                    label: 'Ubah foto profil',
                    child: GestureDetector(
                      onTap: _selectProfilePhoto,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: const Color(0xFFE9DDFB),
                            backgroundImage: store.profilePhotoUrl == null
                                ? null
                                : NetworkImage(store.profilePhotoUrl!),
                            child: store.profilePhotoUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: 38,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  )
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary,
                              child: _isUpdatingPhoto
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.userName.isEmpty
                            ? 'Nama pengguna'
                            : store.userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        store.username.isEmpty ? '@' : '@${store.username}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (store.bio.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                  child: Text(
                    store.bio,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatItem(angka: '${myArtworks.length}', label: 'Karya'),
                    _StatItem(angka: '$appreciationCount', label: 'Apresiasi'),
                    _StatItem(
                      angka: '${savedArtworks.length}',
                      label: 'Tersimpan',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: const BorderSide(color: Color(0xFFDCD1F2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: store.isProfileLoading
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => EditProfilPage(
                              fullName: store.userName,
                              username: store.username,
                              email: store.email,
                              phoneNumber: store.phoneNumber,
                            ),
                          ),
                        ),
                  child: store.isProfileLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Edit profil'),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildProfileTab(
                    context,
                    'Karya saya (${myArtworks.length})',
                    false,
                  ),
                  _buildProfileTab(
                    context,
                    'Koleksi tersimpan (${savedArtworks.length})',
                    true,
                  ),
                ],
              ),
              if (shownArtworks.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 44, 24, 44),
                  child: Column(
                    children: [
                      Icon(
                        _showSavedWorks
                            ? Icons.bookmark_border
                            : Icons.palette_outlined,
                        size: 42,
                        color: const Color(0xFFAAA4B4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _showSavedWorks
                            ? 'Belum ada karya tersimpan.'
                            : 'Kamu belum membagikan karya.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    itemCount: shownArtworks.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                    itemBuilder: (context, index) =>
                        _buildArtworkCard(shownArtworks[index]),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: OutlinedButton.icon(
                  onPressed: _isSigningOut ? null : _signOut,
                  icon: _isSigningOut
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout),
                  label: Text(_isSigningOut ? 'Keluar...' : 'Keluar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFB64036),
                    side: const BorderSide(color: Color(0xFFE7C8C5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArtworkCard(Artwork artwork) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9E3F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [artwork.color1, artwork.color2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: artwork.imageUrl == null
                  ? const Icon(
                      Icons.palette_outlined,
                      size: 42,
                      color: Color(0xFF7052C8),
                    )
                  : Image.network(
                      artwork.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image_outlined,
                        size: 36,
                        color: Color(0xFF7052C8),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artwork.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _showSavedWorks ? artwork.creator : artwork.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${artwork.likes}',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
              textAlign: TextAlign.center,
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
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.angka, required this.label});

  final String angka;
  final String label;

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
