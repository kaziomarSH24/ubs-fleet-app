import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminMainScreen extends StatelessWidget {
  final Widget child;

  const AdminMainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    
    if (location.startsWith('/admin/fleet')) currentIndex = 1;
    if (location.startsWith('/admin/drivers')) currentIndex = 2;
    if (location.startsWith('/admin/billing')) currentIndex = 3;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.primary.withOpacity(0.2), width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/admin-dashboard');
              break;
            case 1:
              context.go('/admin/fleet');
              break;
            case 2:
              context.go('/admin/drivers');
              break;
            case 3:
              context.go('/admin/billing');
              break;
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.layoutDashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.car),
            label: 'Fleet',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.users),
            label: 'Drivers',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.receipt),
            label: 'Billing',
          ),
        ],
      ),
    );
  }
}
