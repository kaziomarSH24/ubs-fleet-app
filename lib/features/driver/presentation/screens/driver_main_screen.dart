import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

class DriverMainScreen extends StatelessWidget {
  final Widget child;
  
  const DriverMainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // Determine selected index based on route
    int currentIndex = 0;
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/driver/logs')) {
      currentIndex = 2;
    } else if (location.startsWith('/driver/account')) {
      currentIndex = 3;
    } else if (location.startsWith('/driver/vehicles')) {
      currentIndex = 1;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF0B1320),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.cyanAccent,
          unselectedItemColor: Colors.white54,
          currentIndex: currentIndex,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: const Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.speed)),
              label: l10n?.navDashboard ?? 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: const Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.directions_car)),
              label: l10n?.navVehicles ?? 'Vehicles',
            ),
            BottomNavigationBarItem(
              icon: const Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.receipt_long)),
              label: l10n?.navLogs ?? 'Logs',
            ),
            BottomNavigationBarItem(
              icon: const Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.person_outline)),
              label: l10n?.navAccount ?? 'Account',
            ),
          ],
          onTap: (index) {
            if (index == 0) context.go('/driver-home');
            if (index == 1) {} // context.go('/driver/vehicles');
            if (index == 2) context.go('/driver/logs');
            if (index == 3) {} // context.go('/driver/account');
          },
        ),
      ),
    );
  }
}
