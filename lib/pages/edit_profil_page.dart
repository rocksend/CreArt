import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth_service.dart';
import '../creart_store.dart';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({
    super.key,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
  });

  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.fullName);
  late final _usernameController = TextEditingController(text: widget.username);
  late final _emailController = TextEditingController(text: widget.email);
  late final _phoneController = TextEditingController(text: widget.phoneNumber);
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final emailVerificationPending = await CreArtAuthService.instance
          .updateProfile(
            fullName: _nameController.text,
            username: _usernameController.text,
            email: _emailController.text,
            phoneNumber: _phoneController.text,
          );
      await CreArtStore.instance.refreshUserProfile();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      if (emailVerificationPending) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Tautan verifikasi email telah dikirim. Email akun berubah '
              'setelah tautan dibuka.',
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      _showError(authErrorMessage(error));
    } on FirebaseException catch (error) {
      _showError(authErrorMessage(error));
    } on ArgumentError catch (error) {
      _showError(error.message?.toString() ?? 'Data profil tidak valid.');
    } catch (error) {
      _showError('Gagal menyimpan profil: $error');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profil')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Informasi akun',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Perbarui informasi yang tampil di profilmu.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nama lengkap',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama lengkap wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.alternate_email),
                ),
                validator: (value) {
                  final username = value?.trim() ?? '';
                  if (!RegExp(r'^[a-zA-Z0-9._]{3,20}$').hasMatch(username)) {
                    return 'Gunakan 3–20 huruf, angka, titik, atau garis bawah.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                    return 'Masukkan alamat email yang valid.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor telepon',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Simpan perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
