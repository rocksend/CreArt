import 'package:flutter/material.dart';

class RegistrasiPage extends StatelessWidget {
  const RegistrasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('CreArt', style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mulai berkarya.', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Buat akun untuk berbagi karya, memberi apresiasi, dan menyimpan inspirasi.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              
              _buildInputLabel('Nama lengkap'),
              _buildTextField('Nama yang ditampilkan di profil'),
              const SizedBox(height: 16),
              
              _buildInputLabel('Nama pengguna'),
              _buildTextField('Pilih nama pengguna'),
              const SizedBox(height: 16),
              
              _buildInputLabel('Email'),
              _buildTextField('nama@email.com'),
              const SizedBox(height: 16),
              
              _buildInputLabel('Kata sandi'),
              _buildTextField('Buat kata sandi', isPassword: true),
              const SizedBox(height: 16),
              
              _buildInputLabel('Konfirmasi kata sandi'),
              _buildTextField('Ulangi kata sandi', isPassword: true),
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // Logika daftar di sini
                  },
                  child: const Text('Daftar', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Sudah punya akun? ',
                      style: TextStyle(color: Colors.grey),
                      children: [TextSpan(text: 'Masuk', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: isPassword ? const Icon(Icons.visibility_off, size: 20) : null,
      ),
    );
  }
}