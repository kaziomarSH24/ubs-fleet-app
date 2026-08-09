import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../l10n/app_localizations.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../auth/data/services/auth_service.dart';
import '../../data/repositories/driver_repository.dart';
import '../../../../core/database/entities/daily_log_local.dart';

class DriverLogsScreen extends ConsumerStatefulWidget {
  const DriverLogsScreen({super.key});

  @override
  ConsumerState<DriverLogsScreen> createState() => _DriverLogsScreenState();
}

class _DriverLogsScreenState extends ConsumerState<DriverLogsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF070D14), // Darker background to match image 3
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.cyanAccent,
              radius: 16,
              child: Icon(Icons.person, color: Colors.black, size: 20),
            ),
            12.widthBox,
            (l10n?.tripHistory ?? "TRIP HISTORY").text.white.letterSpacing(1).bold.make(),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.cyanAccent),
            onPressed: () => _selectDateRange(context),
          ),
          8.widthBox,
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dark_map_optimized.jpg'),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: Column(
          children: [
            // Month Selector (One month at a time)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_startDate != null && _endDate != null) ...[
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent, size: 20),
                      onPressed: () {
                        setState(() {
                          _startDate = null;
                          _endDate = null;
                        });
                      },
                    ),
                    "${DateFormat('MMM d, yyyy').format(_startDate!)} - ${DateFormat('MMM d, yyyy').format(_endDate!)}"
                        .text.white.bold.make(),
                    const SizedBox(width: 48), // Balance row
                  ] else ...[
                    const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent, size: 16),
                    DateFormat('MMMM yyyy').format(DateTime.now()).text.white.bold.lg.make(),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
                  ]
                ],
              ),
            ),
            
            // Logs List
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: ref.read(driverRepositoryProvider).getLogsListenable(),
                builder: (context, box, _) {
                  final authService = ref.read(authServiceProvider);
                  final profile = authService.getLocalProfile();
                  
                  if (profile == null) {
                    return const Center(child: Text("No driver logged in", style: TextStyle(color: Colors.white)));
                  }
                  
                  final logs = ref.read(driverRepositoryProvider).getLogs(
                    profile.id,
                    start: _startDate,
                    end: _endDate,
                  );
                  
                  if (logs.isEmpty) {
                    return Center(child: "No logs found".text.white.make());
                  }

                  // Group logs by Date
                  final Map<String, List<DailyLogLocal>> groupedLogs = {};
                  for (var log in logs) {
                    final dateKey = DateFormat('yyyy-MM-dd').format(log.startTime);
                    groupedLogs.putIfAbsent(dateKey, () => []).add(log);
                  }
                  
                  final sortedDates = groupedLogs.keys.toList()..sort((a, b) => b.compareTo(a));

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).copyWith(bottom: 100),
                    itemCount: sortedDates.length,
                    itemBuilder: (context, index) {
                      final dateKey = sortedDates[index];
                      final dayLogs = groupedLogs[dateKey]!;
                      
                      // Calculate Daily Totals
                      int dailyKm = 0;
                      Duration dailyDuration = Duration.zero;
                      double dailyExpense = 0.0;
                      bool hasOngoing = false;
                      
                      for (var log in dayLogs) {
                        dailyKm += (log.totalKm ?? 0);
                        if (log.endTime != null) {
                          dailyDuration += log.endTime!.difference(log.startTime);
                        } else {
                          hasOngoing = true;
                        }
                        
                        final expenses = ref.read(driverRepositoryProvider).getExpensesForLog(log.id);
                        dailyExpense += expenses.fold<double>(0, (sum, exp) => sum + exp.amount);
                      }
                      
                      final formattedDate = DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(dateKey)).toUpperCase();
                      
                      String durationStr = "";
                      if (dailyDuration.inHours > 0) {
                        durationStr = "${dailyDuration.inHours} HR ${dailyDuration.inMinutes.remainder(60)} MIN";
                      } else {
                        durationStr = "${dailyDuration.inMinutes} MIN";
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Daily Summary Header
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            margin: EdgeInsets.only(bottom: 16, top: index == 0 ? 0 : 16),
                            decoration: BoxDecoration(
                              color: Colors.cyan.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    formattedDate.text.color(Colors.cyanAccent).bold.make(),
                                    6.heightBox,
                                    (hasOngoing ? "Includes Ongoing Duty" : "Daily Total").text.white.size(12).make(),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    "${hasOngoing && dailyKm == 0 ? '--' : dailyKm} KM | ${hasOngoing && dailyDuration.inMinutes == 0 ? '--' : durationStr}".text.white.bold.make(),
                                    6.heightBox,
                                    "৳ ${dailyExpense.toInt()}".text.color(Colors.greenAccent).bold.make(),
                                  ],
                                ),
                              ],
                            ),
                          ).animate().fade(delay: (50 * index).ms).slideX(begin: -0.1, end: 0),
                          
                          // Individual Logs for this Date
                          ...dayLogs.map((log) {
                            final isLatest = index == 0 && _startDate == null && log == dayLogs.first;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildLogCard(log, isLatest),
                            ).animate().fade(delay: (50 * index).ms).slideY(begin: 0.1, end: 0);
                          }),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
              surface: Color(0xFF0F1A2C),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF0B1320)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Widget _buildLogCard(DailyLogLocal log, bool isLatest) {
    final expenses = ref.read(driverRepositoryProvider).getExpensesForLog(log.id);
    final totalExpense = expenses.fold<double>(0, (sum, exp) => sum + exp.amount);
    
    final dateStr = DateFormat('EEE, MMM d').format(log.startTime).toUpperCase();
    final runKm = log.totalKm != null ? "${log.totalKm} KM" : "ONGOING";
    
    String durationStr = "ONGOING";
    if (log.endTime != null) {
      final diff = log.endTime!.difference(log.startTime);
      if (diff.inHours > 0) {
        durationStr = "${diff.inHours} HR ${diff.inMinutes.remainder(60)} MIN";
      } else {
        durationStr = "${diff.inMinutes} MIN";
      }
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLatest ? Colors.cyanAccent : Colors.white10,
          width: isLatest ? 1.5 : 1.0,
        ),
        boxShadow: isLatest ? [
          BoxShadow(
            color: Colors.cyanAccent.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 2,
          )
        ] : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dateStr.text.color(Colors.cyanAccent).size(12).bold.make(),
              8.heightBox,
              (log.status == 'ongoing' ? 'ACTIVE LOG' : 'DAILY LOG').text.white.xl2.bold.make(),
              12.heightBox,
              Row(
                children: [
                  const Icon(Icons.speed, color: Colors.greenAccent, size: 16),
                  6.widthBox,
                  runKm.text.color(Colors.greenAccent).bold.make(),
                ],
              ),
            ],
          ),
          
          // Right Side
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.speed, color: Colors.cyanAccent.withValues(alpha: 0.7), size: 16),
                  8.widthBox,
                  Icon(Icons.access_time, color: Colors.white54, size: 16),
                  8.widthBox,
                  Icon(Icons.receipt_long, color: Colors.greenAccent.withValues(alpha: 0.7), size: 16),
                ],
              ),
              16.heightBox,
              durationStr.text.color(Colors.white70).size(12).make(),
              8.heightBox,
              "EXPENSES: ৳ ${totalExpense.toInt()}".text.color(Colors.greenAccent).size(12).make(),
            ],
          ),
        ],
      ),
    );
  }
}
