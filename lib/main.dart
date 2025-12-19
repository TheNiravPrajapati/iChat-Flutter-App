import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login/login_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iChatApp',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
      themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: const AuthWrapper(),
    );
  }
}

///
/// 🔐 AuthWrapper
/// Decides which screen to show based on login state
///
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ⏳ While checking auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // ✅ User logged in
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // ❌ User not logged in
        return const LoginScreen();
      },
    );
  }
}
