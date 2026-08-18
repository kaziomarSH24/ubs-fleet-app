import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../widgets/admin_sidebar.dart';

class AdminMainScreen extends StatelessWidget {
  final Widget child;

  const AdminMainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    
    if (location.startsWith('/admin/fleet')) currentIndex = 1;
    if (location.startsWith('/admin/drivers')) currentIndex = 2;
    if (location.startsWith('/admin/billing')) currentIndex = 3;

    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: const AdminSidebar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            // Desktop/Web layout with NavigationRail
            return Row(
              children: [
                NavigationRail(
                  backgroundColor: AppColors.surface,
                  selectedIndex: currentIndex,
                  onDestinationSelected: (index) => _onNavigate(context, index),
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(color: AppColors.primary),
                  unselectedIconTheme: IconThemeData(color: AppColors.textSecondary),
                  selectedLabelTextStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  unselectedLabelTextStyle: TextStyle(color: AppColors.textSecondary),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(LucideIcons.layoutDashboard),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(LucideIcons.car),
                      label: Text('Fleet'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(LucideIcons.users),
                      label: Text('Drivers'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(LucideIcons.receipt),
                      label: Text('Billing'),
                    ),
                  ],
                ),
                VerticalDivider(thickness: 1, width: 1, color: Colors.white24),
                Expanded(child: child),
              ],
            );
          } else {
            // Mobile layout with BottomNavigationBar
            return child;
          }
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 800) {
            return _buildBottomNav(context, currentIndex);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _onNavigate(BuildContext context, int index) {
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
  }

  Widget _buildBottomNav(BuildContext context, int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: Colors.white24, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onNavigate(context, index),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
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
