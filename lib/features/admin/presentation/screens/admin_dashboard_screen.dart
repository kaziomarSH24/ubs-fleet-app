import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui';
import '../../../../core/widgets/app_aurora_background.dart';
import '../providers/admin_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/data/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final logsAsync = ref.watch(recentLogsProvider);

    return AppAuroraBackground(
      child: RefreshIndicator(
        color: Colors.cyanAccent,
        backgroundColor: const Color(0xFF171A24),
        onRefresh: () async {
          ref.invalidate(dashboardStatsProvider);
          ref.invalidate(recentLogsProvider);
          ref.invalidate(pendingExpensesProvider);
          ref.invalidate(clientsProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, ref),
                      const SizedBox(height: 24),
                      
                      // Responsive Grid for Top Cards
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth >= 600) {
                            return Row(
                              children: [
                                Expanded(child: _buildActiveCarsCard(statsAsync)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildTotalKMCard()),
                              ],
                            );
                          }
                          return Row(
                            children: [
                              Expanded(child: _buildActiveCarsCard(statsAsync)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildTotalKMCard()),
                            ],
                          );
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      _buildLeaderboard(logsAsync),
                      
                      const SizedBox(height: 24),
                      _buildExpensesChart(),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientsProvider);
    final selectedClient = ref.watch(selectedClientProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fleet Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              // Client Filter Dropdown (Styled simply like "Oct 2023 v" in the design)
              clientsAsync.when(
                data: (clients) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: selectedClient,
                      dropdownColor: const Color(0xFF171A24),
                      icon: const Icon(LucideIcons.chevronDown, color: Colors.white54, size: 16),
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                      hint: const Text('All Clients', style: TextStyle(color: Colors.white70)),
                      isDense: true,
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All Clients'),
                        ),
                        ...clients.map((client) {
                          return DropdownMenuItem<String?>(
                            value: client['id'] as String,
                            child: Text(client['name'] as String),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        ref.read(selectedClientProvider.notifier).state = value;
                      },
                    ),
                  );
                },
                loading: () => const SizedBox(
                  width: 100,
                  height: 20,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                error: (err, stack) => const Text('Error', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(LucideIcons.bell, color: Colors.white70, size: 22),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'), // Dummy profile pic matching design
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveCarsCard(AsyncValue<Map<String, dynamic>> statsAsync) {
    return _NeonCard(
      padding: const EdgeInsets.all(16),
      child: statsAsync.when(
        data: (stats) {
          final total = (stats['total_cars'] as int?) ?? 1845; // Using design number for visual testing
          final active = (stats['active_drivers'] as int?) ?? 1720;
          final percent = total > 0 ? (active / total) : 0.0;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Active Cars', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                  Icon(LucideIcons.car, color: Colors.white54, size: 16),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1,845', // Mocking actual design number
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'total',
                        style: TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00F2FE).withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircularPercentIndicator(
                      radius: 32.0,
                      lineWidth: 6.0,
                      animation: true,
                      percent: 0.93, // Mocking design
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '1,720',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0, color: Colors.white),
                          ),
                          const Text('active', style: TextStyle(fontSize: 9, color: Colors.white70)),
                        ],
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      progressColor: const Color(0xFF00F2FE),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '+12% vs last month',
                style: TextStyle(color: Color(0xFF00F2FE), fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          );
        },
        loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
        error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent))),
      ),
    );
  }

  Widget _buildTotalKMCard() {
    return _NeonCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total KM', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
              Icon(LucideIcons.lineChart, color: Colors.white54, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('245,670', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('KM', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '+8.5%',
            style: TextStyle(color: Color(0xFF00E676), fontSize: 11, fontWeight: FontWeight.w500), // Bright green
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 2), FlSpot(1, 3.5), FlSpot(2, 2.5), 
                      FlSpot(3, 4.5), FlSpot(4, 3), FlSpot(5, 5), FlSpot(6, 4.5),
                    ],
                    isCurved: true,
                    gradient: const LinearGradient(colors: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)]),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF8A2387).withValues(alpha: 0.3),
                          const Color(0xFFF27121).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '32.5k avg/month',
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(AsyncValue<List<Map<String, dynamic>>> logsAsync) {
    return _NeonCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Driver Leaderboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(LucideIcons.chevronRight, color: Colors.white54, size: 18),
            ],
          ),
          const SizedBox(height: 16),
          _buildLeaderboardRow(1, 'Emily R.', '4.9', '12.4k KM', '450+', const Color(0xFFFFC107), 'https://i.pravatar.cc/150?img=5'),
          _buildLeaderboardRow(2, 'David S.', '4.8', '11.8k KM', '450+', const Color(0xFFB0BEC5), 'https://i.pravatar.cc/150?img=8'),
          _buildLeaderboardRow(3, 'Sarah K.', '4.8', '11.2k KM', '450+', const Color(0xFFD84315), 'https://i.pravatar.cc/150?img=9', isLast: true),
        ],
      ),
    );
  }

  Widget _buildLeaderboardRow(int rank, String name, String rating, String km, String trips, Color rankColor, String avatarUrl, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        children: [
          // Ribbon/Badge icon for Rank
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(LucideIcons.medal, color: rankColor, size: 28),
              Positioned(
                top: 4,
                child: Text(
                  '$rank',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Avatar
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                Text('Rating: $rating', style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
          Text(km, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(trips, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              const Text('trips', style: TextStyle(color: Colors.white54, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesChart() {
    return _NeonCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Expenses',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Monthly', style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                    const SizedBox(width: 4),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('Weekly', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Oct Expenses: ', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const Text('\$34,250', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text('-3.5%', style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.w600, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Fuel', const Color(0xFF00F2FE)),
              const SizedBox(width: 12),
              _buildLegendItem('Maintenance', const Color(0xFF8A2387)),
              const SizedBox(width: 12),
              _buildLegendItem('Other costs', const Color(0xFFE94057)),
            ],
          ),
          const SizedBox(height: 24),
          // Chart
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 40,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(color: Colors.white54, fontSize: 11);
                        Widget text;
                        switch (value.toInt()) {
                          case 0: text = const Text('Jun', style: style); break;
                          case 1: text = const Text('Aug', style: style); break;
                          case 2: text = const Text('Sep', style: style); break;
                          case 3: text = const Text('Oct', style: style); break;
                          default: text = const Text('', style: style); break;
                        }
                        return Padding(padding: const EdgeInsets.only(top: 8), child: text);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const Text('\$0', style: TextStyle(color: Colors.white54, fontSize: 10));
                        return Text('\$${value.toInt()}k', style: const TextStyle(color: Colors.white54, fontSize: 10));
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        String txt = '';
                        switch (value.toInt()) {
                          case 0: txt = '\$12k'; break;
                          case 1: txt = '\$10k'; break;
                          case 2: txt = '\$12.25k'; break;
                          case 3: txt = '\$12.25k'; break;
                        }
                        return Text(txt, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold));
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withValues(alpha: 0.05), strokeWidth: 1),
                  getDrawingVerticalLine: (value) => FlLine(color: Colors.white.withValues(alpha: 0.03), strokeWidth: 20), // Wide faint vertical background for columns
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildBarGroup(0, 26, const Color(0xFF00F2FE)),
                  _buildBarGroup(1, 20, const Color(0xFF8A2387)),
                  _buildBarGroup(2, 26, const Color(0xFFE94057)),
                  _buildBarGroup(3, 28, const Color(0xFFE94057)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8, 
          height: 8, 
          decoration: BoxDecoration(
            color: color, 
            shape: BoxShape.rectangle, 
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4, spreadRadius: 1),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.transparent, // Outline style
          width: 24,
          borderSide: BorderSide(color: color, width: 2),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: y,
            color: color.withValues(alpha: 0.1), // Subtle inner glow
          ),
        ),
      ],
    );
  }
}

class _NeonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _NeonCard({required this.child, this.padding = const EdgeInsets.all(20)});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Slightly rounder for iOS feel
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0), // Stronger blur for liquid glass
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.16), // Brighter top left specular highlight
                Colors.white.withValues(alpha: 0.05), // Fades out
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.2), // Crisper glass edge
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
