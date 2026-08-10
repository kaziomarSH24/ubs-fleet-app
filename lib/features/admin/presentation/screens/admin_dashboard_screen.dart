import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/admin_providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final logsAsync = ref.watch(recentLogsProvider);
    // final expensesAsync = ref.watch(pendingExpensesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Darker slate background
      body: RefreshIndicator(
        color: Colors.cyanAccent,
        backgroundColor: const Color(0xFF1E293B),
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
                          return Column(
                            children: [
                              _buildActiveCarsCard(statsAsync),
                              const SizedBox(height: 16),
                              _buildTotalKMCard(),
                            ],
                          );
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      _buildSectionTitle('Driver Leaderboard'),
                      const SizedBox(height: 16),
                      _buildLeaderboard(logsAsync), // Using logs as mock leaderboard for now
                      
                      const SizedBox(height: 24),
                      _buildSectionTitle('Monthly Expenses'),
                      const SizedBox(height: 16),
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              // Client Filter Dropdown
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white10),
                ),
                child: clientsAsync.when(
                  data: (clients) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        value: selectedClient,
                        dropdownColor: const Color(0xFF1E293B),
                        icon: const Icon(LucideIcons.chevronDown, color: Colors.white54, size: 16),
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                        hint: const Text('All Clients', style: TextStyle(color: Colors.white70)),
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
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  error: (_, __) => const Text('Error loading clients', style: TextStyle(color: Colors.redAccent)),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(LucideIcons.bell, color: Colors.white70),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF334155),
              child: Icon(LucideIcons.user, color: Colors.white54),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(LucideIcons.chevronRight, color: Colors.white54, size: 20),
      ],
    );
  }

  Widget _buildActiveCarsCard(AsyncValue<Map<String, dynamic>> statsAsync) {
    return _NeonCard(
      child: statsAsync.when(
        data: (stats) {
          final total = (stats['total_cars'] as int?) ?? 0;
          final active = (stats['active_drivers'] as int?) ?? 0;
          final percent = total > 0 ? (active / total) : 0.0;
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Active Cars', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(width: 8),
                      Icon(LucideIcons.car, color: Colors.white54, size: 16),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$active',
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'out of $total total',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '+12% vs last month',
                    style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              CircularPercentIndicator(
                radius: 45.0,
                lineWidth: 8.0,
                animation: true,
                percent: percent,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$active',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
                    ),
                    const Text('active', style: TextStyle(fontSize: 10, color: Colors.white70)),
                  ],
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: const Color(0xFF1E293B),
                progressColor: Colors.cyanAccent,
                // Add a subtle glow
                widgetIndicator: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.5), blurRadius: 10, spreadRadius: 2),
                    ],
                  ),
                ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total KM', style: TextStyle(color: Colors.white70, fontSize: 16)),
              Icon(LucideIcons.trendingUp, color: Colors.white54, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('245,670', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(width: 4),
              Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text('KM', style: TextStyle(color: Colors.white54, fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '+8.5%',
            style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
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
                      FlSpot(0, 3), FlSpot(1, 2), FlSpot(2, 4), 
                      FlSpot(3, 3.5), FlSpot(4, 5), FlSpot(5, 4), FlSpot(6, 6),
                    ],
                    isCurved: true,
                    color: Colors.purpleAccent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.purpleAccent.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '32.5k avg/month',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(AsyncValue<List<Map<String, dynamic>>> logsAsync) {
    return _NeonCard(
      child: logsAsync.when(
        data: (logs) {
          // For mockup purposes, we show some fake driver stats since we don't have real trips calculated yet.
          // In a real scenario, this would aggregate logs per driver.
          return Column(
            children: [
              _buildLeaderboardRow('1', 'Emily R.', '4.9', '12.4k KM', '450+', Colors.amber),
              const Divider(color: Colors.white10, height: 24),
              _buildLeaderboardRow('2', 'David S.', '4.8', '11.8k KM', '430+', Colors.grey.shade400),
              const Divider(color: Colors.white10, height: 24),
              _buildLeaderboardRow('3', 'Sarah K.', '4.8', '11.2k KM', '410+', Colors.brown.shade400),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Text('Error: $e', style: const TextStyle(color: Colors.redAccent)),
      ),
    );
  }

  Widget _buildLeaderboardRow(String rank, String name, String rating, String km, String trips, Color rankColor) {
    return Row(
      children: [
        // Rank Badge
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: rankColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: rankColor, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            rank,
            style: TextStyle(color: rankColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(width: 12),
        // Avatar
        const CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFF334155),
          child: Icon(LucideIcons.user, size: 16, color: Colors.white70),
        ),
        const SizedBox(width: 12),
        // Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Rating: $rating', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
        Text(km, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(trips, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Text('trips', style: TextStyle(color: Colors.white54, fontSize: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildExpensesChart() {
    return _NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Oct Expenses', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const Text('\$34,250', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text('-3.5%', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Fuel', Colors.cyanAccent),
              const SizedBox(width: 16),
              _buildLegendItem('Maintenance', Colors.purpleAccent),
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
                        const style = TextStyle(color: Colors.white54, fontSize: 12);
                        Widget text;
                        switch (value.toInt()) {
                          case 0: text = const Text('Jun', style: style); break;
                          case 1: text = const Text('Jul', style: style); break;
                          case 2: text = const Text('Aug', style: style); break;
                          case 3: text = const Text('Sep', style: style); break;
                          case 4: text = const Text('Oct', style: style); break;
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
                        if (value == 0) return const SizedBox();
                        return Text('\$${value.toInt()}k', style: const TextStyle(color: Colors.white54, fontSize: 10));
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.white10, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildBarGroup(0, 25, Colors.cyanAccent),
                  _buildBarGroup(1, 20, Colors.purpleAccent),
                  _buildBarGroup(2, 22, Colors.purpleAccent),
                  _buildBarGroup(3, 28, Colors.purpleAccent),
                  _buildBarGroup(4, 34, Colors.cyanAccent),
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
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.transparent,
          width: 20,
          borderSide: BorderSide(color: color, width: 2),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }
}

class _NeonCard extends StatelessWidget {
  final Widget child;

  const _NeonCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
