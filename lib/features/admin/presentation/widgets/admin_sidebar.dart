import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/data/services/auth_service.dart';
import '../screens/driver_payments_screen.dart';
import '../../../../core/widgets/app_snackbar.dart';

class AdminSidebar extends ConsumerWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: const Color(0xFF171A24),
      child: Column(
        children: [
          _buildHeader(context),
          const Divider(color: Colors.white24, height: 1),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: LucideIcons.user,
                  title: 'Profile Settings',
                  onTap: () {
                    // Navigate to Profile Settings or show dialog
                    AppSnackbar.showSuccess(context, 'Coming soon!');
                  },
                ),
                _buildMenuItem(
                  icon: LucideIcons.banknote,
                  title: 'Driver Advances',
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverPaymentsScreen()));
                  },
                ),
                _buildMenuItem(
                  icon: LucideIcons.settings,
                  title: 'System Settings',
                  onTap: () {
                    AppSnackbar.showSuccess(context, 'Coming soon!');
                  },
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          ListTile(
            leading: const Icon(LucideIcons.logOut, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: () async {
              try {
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) context.go('/');
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to logout: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white12,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=admin'),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Super Administrator',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
