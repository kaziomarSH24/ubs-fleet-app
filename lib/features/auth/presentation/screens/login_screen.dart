import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    // TODO: Implement Supabase Auth login
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
    // TODO: Navigate based on Role (Admin vs Driver)
    if (mounted) context.go('/driver-home'); // Temp navigation for preview
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient accents
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), blurRadius: 100, spreadRadius: 50)
                ]
              ),
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
                    
                    "Welcome Back"
                        .text
                        .xl4
                        .bold
                        .color(AppColors.textPrimary)
                        .center
                        .make()
                        .animate()
                        .fade(delay: 200.ms)
                        .slideY(begin: 0.3, end: 0),
                    
                    8.heightBox,
                    
                    "Sign in to manage your fleet"
                        .text
                        .lg
                        .color(AppColors.textSecondary)
                        .center
                        .make()
                        .animate()
                        .fade(delay: 300.ms)
                        .slideY(begin: 0.3, end: 0),
                    
                    48.heightBox,

                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      hint: "Email Address",
                      icon: Icons.email_outlined,
                    ).animate().fade(delay: 400.ms).slideY(begin: 0.3, end: 0),
                    
                    24.heightBox,

                    // Password Field
                    CustomTextField(
                      controller: _passwordController,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ).animate().fade(delay: 500.ms).slideY(begin: 0.3, end: 0),
                    
                    16.heightBox,

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: "Forgot Password?".text.color(AppColors.primary).make(),
                      ),
                    ).animate().fade(delay: 600.ms),

                    32.heightBox,

                    // Login Button
                    PrimaryButton(
                      text: "Login",
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
