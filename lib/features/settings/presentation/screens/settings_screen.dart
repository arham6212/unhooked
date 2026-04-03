import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 12),

          // 🔹 Profile
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () {
              // future navigation
            },
          ),

          // 🔹 Notifications
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text('Notifications'),
            onTap: () {},
          ),

          // 🔹 Privacy
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Privacy'),
            onTap: () {},
          ),

          const Divider(),

          // 🔹 About
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {},
          ),

          // 🔹 Help
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {},
          ),

          const Divider(),

          // 🔥 Logout (IMPORTANT)
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              ref.read(authProvider.notifier).logout();

              // 🔥 go_router navigation
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}