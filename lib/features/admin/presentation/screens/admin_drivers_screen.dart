import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AdminDriversScreen extends StatelessWidget {
  const AdminDriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Drivers', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: const Center(
        child: Text('Drivers Screen', style: TextStyle(color: AppColors.textPrimary)),
      ),
    );
  }
}
