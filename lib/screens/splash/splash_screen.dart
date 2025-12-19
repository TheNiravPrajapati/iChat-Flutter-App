import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with its own background
            Image.asset(
              'assets/logo.png',
              width: 120,
            ),

            const SizedBox(height: 16),

            // App Name (logo-matching color)
            const Text(
              'iChat App',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.primary, // 🔥 matches logo
              ),
            ),
          ],
        ),
      ),
    );
  }
}
