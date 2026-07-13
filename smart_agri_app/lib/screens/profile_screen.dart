import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = AppData.instance;
    final user = AuthService.instance.currentUser;
    final uid = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.primary.withOpacity(0.15),
              child: const Icon(Icons.person, size: 44, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(user?.phoneNumber ?? "Kisan", style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(data.farmerVillage, style: const TextStyle(color: AppColors.textMuted)),
          ),
          const SizedBox(height: 28),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.phone, color: AppColors.primary),
                  title: const Text("Mobile"),
                  subtitle: Text(user?.phoneNumber ?? "-"),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.verified_user, color: AppColors.primary),
                  title: const Text("Account ID"),
                  subtitle: Text(uid, style: const TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () async {
              await AuthService.instance.signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout, color: AppColors.danger),
            label: const Text("Logout", style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}
