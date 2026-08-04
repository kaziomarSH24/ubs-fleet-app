import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep space blue/black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.jpg',
              width: 180,
              height: 180,
            )
                .animate()
                .fade(duration: 800.ms)
                .scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack)
                .shimmer(delay: 1000.ms, duration: 1500.ms, color: Colors.cyan),
            30.heightBox,
            "UBS"
                .text
                .xl4
                .bold
                .color(Colors.cyan)
                .letterSpacing(5)
                .make()
                .animate()
                .fade(delay: 800.ms, duration: 600.ms)
                .slideY(begin: 0.5, end: 0),
            5.heightBox,
            "FLEET MANAGEMENT"
                .text
                .sm
                .color(Colors.white70)
                .letterSpacing(2)
                .make()
                .animate()
                .fade(delay: 1200.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
