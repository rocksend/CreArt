import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../auth_service.dart';

class BerandaAdminPage extends StatelessWidget {
  const BerandaAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin CreArt', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await CreArtAuthService.instance.signOut();
              } on FirebaseException catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(authErrorMessage(error))),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ringkasan pengelolaan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Data contoh untuk rancangan admin.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 20),
            // Statistik
            Row(
              children: [
                Expanded(child: _buildStatCard('128', 'Pengguna')),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('246', 'Karya')),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('3', 'Laporan baru', isAlert: true)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Kelola Postingan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            // List Karya untuk di-manage/dihapus
            _buildAdminPostItem('Fragmen Malam', 'Laporan hak cipta - Karya', 'Tinjau'),
            _buildAdminPostItem('Garis Kota', 'Komentar tidak pantas', 'Hapus'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String number, String label, {bool isAlert = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAlert ? Colors.red[50] : Colors.white,
        border: Border.all(color: isAlert ? Colors.red : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(number, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isAlert ? Colors.red : Colors.black)),
          Text(label, style: TextStyle(fontSize: 10, color: isAlert ? Colors.red : Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAdminPostItem(String title, String subtitle, String actionLabel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: OutlinedButton(
          onPressed: () {},
          child: Text(actionLabel, style: TextStyle(color: actionLabel == 'Hapus' ? Colors.red : Colors.black)),
        ),
      ),
    );
  }
}
