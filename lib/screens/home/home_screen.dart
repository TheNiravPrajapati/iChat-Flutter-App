import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'iChatApp',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.white),
            onPressed: () {},
          ),

          // 🔽 Three-dot dropdown menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.white),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              } else if (value == 'logout') {
                _logout(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),

      // 🗂 Chat List (Dummy for now)
      body: ListView.separated(
        itemCount: 10,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              'User ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'Last message preview...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Text(
              '12:30 PM',
              style: TextStyle(fontSize: 12),
            ),
            onTap: () {
              // Open chat screen later
            },
          );
        },
      ),

      // 💬 New Chat Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  // 🔐 Logout Logic
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }
}
