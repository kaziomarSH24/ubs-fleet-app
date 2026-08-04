import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/driver/presentation/screens/driver_home_screen.dart';
import '../../features/driver/presentation/screens/expense_entry_screen.dart';
import '../../features/driver/presentation/screens/daily_log_screen.dart';

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
    GoRoute(
      path: '/driver-home',
      builder: (context, state) => const DriverHomeScreen(),
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
          dutyStartTime: extra?['startTime'] as DateTime?,
          startKm: extra?['startKm'] as int?,
        );
      },
    ),
  ],
);
