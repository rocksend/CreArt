import 'package:flutter/material.dart';
import 'pages/login_page.dart'; // Import halaman pertama

void main() {
  runApp(const CreArtApp());
}

class CreArtApp extends StatelessWidget {
  const CreArtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CreArt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ... (Aturan warna dan font tema) ...
      ),
      home: const LoginPage(), // Langsung memanggil LoginPage
    );
  }
}