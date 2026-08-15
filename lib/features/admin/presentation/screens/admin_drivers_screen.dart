import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../providers/admin_providers.dart';
import '../../../../core/theme/app_colors.dart';
import 'admin_driver_detail_screen.dart';
import '../widgets/add_driver_dialog.dart';

class AdminDriversScreen extends ConsumerWidget {
  const AdminDriversScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driversAsync = ref.watch(driversProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.4),
                  radius: 1.2,
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF020617),
                  ],
                ),
              ),
            ),
          ),
          // Background Dot Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _DotGridPainter(),
            ),
          ),
          // Top Left Teal Glow
          Positioned(
            top: -50,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF19556A).withValues(alpha: 0.35),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF19556A).withValues(alpha: 0.35), blurRadius: 120, spreadRadius: 60)
                ]
              ),
            ),
          ),
          // Bottom Right Purple Glow
          Positioned(
            bottom: -100,
            right: -50,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF5E2C96).withValues(alpha: 0.35),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF5E2C96).withValues(alpha: 0.35), blurRadius: 120, spreadRadius: 60)
                ]
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Drivers',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.invalidate(driversProvider);
                        },
                        icon: const Icon(LucideIcons.refreshCw, color: Colors.white70),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: driversAsync.when(
                    data: (drivers) {
                      if (drivers.isEmpty) {
                        return const Center(child: Text('No drivers found.', style: TextStyle(color: Colors.white70)));
                      }
                      return RefreshIndicator(
                        onRefresh: () async => ref.invalidate(driversProvider),
                        backgroundColor: const Color(0xFF171A24),
                        color: Colors.cyanAccent,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          itemCount: drivers.length,
                          itemBuilder: (context, index) {
                            final driver = drivers[index];
                            return _buildDriverCard(context, driver);
                          },
                        ),
                      );
                    },
                    loading: () => ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 1500.ms, color: Colors.white24)
                        .fade(duration: 500.ms);
                      },
                    ),
                    error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AddDriverDialog(),
            );
          },
          child: const Icon(LucideIcons.plus, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildDriverCard(BuildContext context, Map<String, dynamic> driver) {
    final isActive = driver['is_active'] == true;
    final clientName = driver['clients'] != null ? driver['clients']['name'] : 'No Company Assigned';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminDriverDetailScreen(driver: driver),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: 0.03),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    child: const Icon(LucideIcons.user, color: Colors.white54),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver['full_name'] ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${driver['employee_id']} • $clientName',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.cyan.withValues(alpha: 0.2) : Colors.redAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? Colors.cyan.withValues(alpha: 0.5) : Colors.redAccent.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: isActive ? Colors.cyanAccent : Colors.redAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    const double spacing = 20.0;
    const double radius = 1.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
