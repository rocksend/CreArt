import 'package:flutter/material.dart';
import '../creart_store.dart';

class BuatPostinganPage extends StatefulWidget {
  const BuatPostinganPage({super.key});

  @override
  State<BuatPostinganPage> createState() => _BuatPostinganPageState();
}

class _BuatPostinganPageState extends State<BuatPostinganPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isVisual = true;
  bool _isLoading = false;
  String? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _publishArtwork() async {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul karya wajib diisi!')),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih kategori karya!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await CreArtStore.instance.addArtwork(
        title: title,
        description: desc.isEmpty ? 'Karya seni tanpa deskripsi.' : desc,
        category: _selectedCategory!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Karya berhasil dipublikasikan!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mempublikasikan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buat postingan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Visual / Tulisan
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isVisual
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      foregroundColor: _isVisual
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => setState(() => _isVisual = true),
                    child: const Text('Karya visual'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: !_isVisual
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      backgroundColor: !_isVisual
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      side: const BorderSide(color: Color(0xFFE9E3F0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => setState(() => _isVisual = false),
                    child: const Text('Tulisan'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Box Upload (Placeholder sebelum integrasi Cloudinary)
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0FC),
                border: Border.all(color: const Color(0xFFDCD1F2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isVisual ? Icons.upload_file : Icons.edit_note,
                    size: 32,
                    color: const Color(0xFF7052C8),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isVisual
                        ? 'Pilih karya dari perangkat'
                        : 'Tambahkan sampul tulisan (opsional)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isVisual
                        ? 'Pratinjau karya akan muncul di sini'
                        : 'Kamu bisa menulis cerita di bagian deskripsi',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Input Judul
            const Text(
              'Judul karya',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Beri judul untuk karyamu',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Input Deskripsi
            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ceritakan ide atau proses di balik karya ini...',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Pilihan Kategori
            const Text(
              'Kategori',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategory,
                  hint: const Text(
                    'Pilih kategori seni',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: <String>[
                    'Ilustrasi',
                    'Fotografi',
                    'Desain',
                    'Digital Art',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Tombol Publikasikan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isLoading ? null : _publishArtwork,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Publikasikan karya',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}