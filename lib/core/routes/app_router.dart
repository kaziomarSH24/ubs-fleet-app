import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/driver/presentation/screens/driver_home_screen.dart';
import '../../features/driver/presentation/screens/expense_entry_screen.dart';
import '../../features/driver/presentation/screens/daily_log_screen.dart';
import '../../features/driver/presentation/screens/driver_logs_screen.dart';
import '../../features/driver/presentation/screens/driver_main_screen.dart';
import '../../features/driver/presentation/screens/driver_profile_screen.dart';
import '../../features/driver/presentation/screens/driver_wallet_screen.dart';

import '../../features/admin/presentation/screens/admin_main_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_fleet_screen.dart';
import '../../features/admin/presentation/screens/admin_drivers_screen.dart';
import '../../features/admin/presentation/screens/admin_billing_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return DriverMainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/driver-home',
          builder: (context, state) => const DriverHomeScreen(),
        ),
        GoRoute(
          path: '/driver/logs',
          builder: (context, state) => const DriverLogsScreen(),
        ),
        GoRoute(
          path: '/driver/account',
          builder: (context, state) => const DriverProfileScreen(),
        ),
        GoRoute(
          path: '/driver/wallet',
          builder: (context, state) => const DriverWalletScreen(),
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AdminMainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/admin-dashboard',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/admin/fleet',
          builder: (context, state) => const AdminFleetScreen(),
        ),
        GoRoute(
          path: '/admin/drivers',
          builder: (context, state) => const AdminDriversScreen(),
        ),
        GoRoute(
          path: '/admin/billing',
          builder: (context, state) => const AdminBillingScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/driver/expense',
      builder: (context, state) => const ExpenseEntryScreen(),
    ),
    GoRoute(
      path: '/driver/daily-log',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return DailyLogScreen(
          startTime: (extra?['startTime'] as DateTime?) ?? DateTime.now(),
          startKm: (extra?['startKm'] as int?) ?? 0,
        );
      },
    ),
  ],
);
