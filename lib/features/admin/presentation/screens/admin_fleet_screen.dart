import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../providers/admin_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/add_vehicle_dialog.dart';
import 'admin_vehicle_detail_screen.dart';

class AdminFleetScreen extends ConsumerWidget {
  const AdminFleetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient & Glow
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
          Positioned(
            top: -50,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF19556A).withValues(alpha: 0.3),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF19556A).withValues(alpha: 0.3), blurRadius: 120, spreadRadius: 60)
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
                        'Fleet Vehicles',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.invalidate(vehiclesProvider);
                        },
                        icon: const Icon(LucideIcons.refreshCw, color: Colors.white70),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: vehiclesAsync.when(
                    data: (vehicles) {
                      if (vehicles.isEmpty) {
                        return const Center(child: Text('No vehicles found.', style: TextStyle(color: Colors.white70)));
                      }
                      return RefreshIndicator(
                        onRefresh: () async => ref.invalidate(vehiclesProvider),
                        backgroundColor: const Color(0xFF171A24),
                        color: Colors.cyanAccent,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          itemCount: vehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = vehicles[index];
                            return _buildVehicleCard(context, vehicle);
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
                          height: 120,
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
              builder: (context) => const AddVehicleDialog(),
            );
          },
          child: const Icon(LucideIcons.plus, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, Map<String, dynamic> vehicle) {
    final status = vehicle['status'] as String? ?? 'active';
    final driverData = vehicle['profiles'];
    final driverName = driverData != null ? driverData['full_name'] : 'No driver assigned';
    final isWorkshop = status == 'workshop';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminVehicleDetailScreen(vehicle: vehicle),
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
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isWorkshop ? Colors.red.withValues(alpha: 0.1) : Colors.cyan.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isWorkshop ? LucideIcons.wrench : LucideIcons.car,
                      color: isWorkshop ? Colors.redAccent : Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle['model'] ?? 'Unknown Model',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vehicle['plate_number'] ?? '',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(LucideIcons.user, size: 12, color: Colors.white54),
                            const SizedBox(width: 4),
                            Text(driverName, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Icon(LucideIcons.chevronRight, color: Colors.white30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
