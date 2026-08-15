import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../providers/admin_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_aurora_background.dart';
import 'admin_driver_detail_screen.dart';
import '../widgets/add_driver_dialog.dart';

class AdminDriversScreen extends ConsumerWidget {
  const AdminDriversScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driversAsync = ref.watch(driversProvider);

    return AppAuroraBackground(
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
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF00F2FE).withValues(alpha: 0.2),
                          const Color(0xFF4FACFE).withValues(alpha: 0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3), width: 1),
                    ),
                    child: driver['avatar_url'] != null && driver['avatar_url'].toString().isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              driver['avatar_url'],
                              fit: BoxFit.cover,
                              width: 54,
                              height: 54,
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Icon(LucideIcons.user, color: Colors.cyanAccent, size: 24),
                              ),
                            ),
                          )
                        : const Center(
                            child: Icon(LucideIcons.user, color: Colors.cyanAccent, size: 24),
                          ),
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
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(LucideIcons.briefcase, color: Colors.white54, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${driver['employee_id']} • $clientName',
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.cyan.withValues(alpha: 0.15) : Colors.redAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive ? Colors.cyanAccent.withValues(alpha: 0.5) : Colors.redAccent.withValues(alpha: 0.5),
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
                      ),
                      const SizedBox(height: 8),
                      const Icon(LucideIcons.chevronRight, color: Colors.white30, size: 18),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
