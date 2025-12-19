import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';
import '../profile/edit_profile_screen.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false; // later connect with ThemeProvider

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Settings',
          style: TextStyle(color: AppColors.white),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // 👤 Edit Profile
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            subtitle: const Text('Update your name and details'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditProfileScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // 🌗 Theme Toggle
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            value: context.watch<ThemeProvider>().isDarkMode,
            onChanged: (value) {
              context.read<ThemeProvider>().toggleTheme(value);
            },
          ),

          const Divider(),

          // 🔐 Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
