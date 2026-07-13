import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/crop_repository.dart';
import 'home_screen.dart';
import 'weather_screen.dart';
import 'profile_screen.dart';
import 'add_crop_screen.dart';
import 'login_screen.dart';

/// Bottom-nav shell. Creates ONE CropRepository (Firestore stream) for the
/// logged-in farmer and shares it with every tab/screen underneath, so all
/// screens stay in sync in real time without extra Firestore reads.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  CropRepository? _cropRepo;

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    if (user != null) {
      _cropRepo = CropRepository(user.uid);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      });
    }
  }

  @override
  void dispose() {
    _cropRepo?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cropRepo == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final pages = [
      HomeScreen(cropRepo: _cropRepo!),
      const WeatherScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Fasal Add Karein"),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AddCropScreen(cropRepo: _cropRepo!)),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_outlined), activeIcon: Icon(Icons.cloud), label: "Mausam"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
