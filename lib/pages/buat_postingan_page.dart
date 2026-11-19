import 'package:flutter/material.dart';

class BuatPostinganPage extends StatefulWidget {
  const BuatPostinganPage({super.key});

  @override
  State<BuatPostinganPage> createState() => _BuatPostinganPageState();
}

class _BuatPostinganPageState extends State<BuatPostinganPage> {
  bool _isVisual = true;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat postingan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => setState(() => _isVisual = false),
                    child: const Text('Tulisan'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Upload Box
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
                    color: Color(0xFF7052C8),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _isVisual
                        ? 'Pilih karya dari perangkat'
                        : 'Tambahkan sampul tulisan (opsional)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _isVisual
                        ? 'Pratinjau karya akan muncul di sini'
                        : 'Kamu bisa menulis cerita di bagian deskripsi',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Form Inputs
            const Text('Judul karya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 8),
            _buildTextField('Beri judul untuk karyamu'),
            const SizedBox(height: 16),
            
            const Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 8),
            _buildTextField('Ceritakan ide atau proses di balik karya ini...', maxLines: 3),
            const SizedBox(height: 16),
            
            const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
                  hint: const Text('Pilih kategori seni', style: TextStyle(fontSize: 14)),
                  items: <String>['Ilustrasi', 'Fotografi', 'Desain'].map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            const Text('Tag (opsional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 8),
            _buildTextField('Misalnya: kota, senja, sketsa'),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {},
                child: const Text('Publikasikan karya', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}