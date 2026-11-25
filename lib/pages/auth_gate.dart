import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth_service.dart';
import 'beranda_admin_page.dart';
import 'login_page.dart';
import 'main_navigation.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _AuthLoading();
        }
        if (snapshot.hasError) {
          return _AuthError(message: authErrorMessage(snapshot.error!));
        }

        final user = snapshot.data;
        if (user == null) return const LoginPage();

        return FutureBuilder<bool>(
          future: CreArtAuthService.instance.isAdmin(user.uid),
          builder: (context, adminSnapshot) {
            if (adminSnapshot.connectionState == ConnectionState.waiting) {
              return const _AuthLoading();
            }
            if (adminSnapshot.hasError) {
              return _AuthError(
                message: authErrorMessage(adminSnapshot.error!),
              );
            }
            return adminSnapshot.data == true
                ? const BerandaAdminPage()
                : const MainNavigation();
          },
        );
      },
    );
  }
}

class _AuthLoading extends StatelessWidget {
  const _AuthLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Color(0xFF7052C8))),
    );
  }
}

class _AuthError extends StatelessWidget {
  const _AuthError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                size: 40,
                color: Color(0xFF7052C8),
              ),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: CreArtAuthService.instance.signOut,
                child: const Text('Keluar dari akun'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
