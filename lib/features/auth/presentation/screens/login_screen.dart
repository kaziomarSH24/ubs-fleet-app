import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/services/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _idOrPhoneController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final input = _idOrPhoneController.text.trim();
    final pin = _pinController.text.trim();

    if (input.isEmpty || pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অনুগ্রহ করে আইডি/ফোন এবং পিন দিন।')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithIdOrPhone(input: input, pin: pin);
      
      if (mounted) {
        context.go('/driver'); // Navigate to driver home on success
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('লগিন ব্যর্থ হয়েছে: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('একটি সমস্যা হয়েছে: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _idOrPhoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Image / Gradient
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.jpg', // Assuming this is the bg used in the app
              fit: BoxFit.cover,
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 40,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.jpg',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                    
                    40.heightBox,
                    
                    "স্বাগতম"
                        .text
                        .xl4
                        .bold
                        .white
                        .center
                        .make()
                        .animate()
                        .fade(delay: 200.ms)
                        .slideY(begin: 0.3, end: 0),
                    
                    8.heightBox,
                    
                    "আপনার অ্যাকাউন্টে লগিন করুন"
                        .text
                        .lg
                        .color(Colors.white70)
                        .center
                        .make()
                        .animate()
                        .fade(delay: 300.ms)
                        .slideY(begin: 0.3, end: 0),
                    
                    48.heightBox,

                    // ID or Phone Field
                    CustomTextField(
                      controller: _idOrPhoneController,
                      hint: "Employee ID বা Phone Number",
                      icon: Icons.person_outline,
                    ).animate().fade(delay: 400.ms).slideY(begin: 0.3, end: 0),
                    
                    24.heightBox,

                    // PIN Field
                    CustomTextField(
                      controller: _pinController,
                      hint: "PIN (পিন)",
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ).animate().fade(delay: 500.ms).slideY(begin: 0.3, end: 0),
                    
                    32.heightBox,

                    // Login Button
                    PrimaryButton(
                      text: "লগিন করুন",
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                    ).animate().fade(delay: 700.ms).scale(curve: Curves.easeOutBack),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
