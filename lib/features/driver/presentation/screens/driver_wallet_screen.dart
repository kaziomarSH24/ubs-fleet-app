import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/data/services/auth_service.dart';
import '../../data/repositories/driver_repository.dart';
import '../../admin/domain/services/pdf_billing_slip_service.dart';

final myPaymentsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, driverId) async {
  final repo = ref.read(driverRepositoryProvider);
  return repo.getDriverPayments(driverId);
});

class DriverWalletScreen extends ConsumerStatefulWidget {
  const DriverWalletScreen({super.key});

  @override
  ConsumerState<DriverWalletScreen> createState() => _DriverWalletScreenState();
}

class _DriverWalletScreenState extends ConsumerState<DriverWalletScreen> {
  DateTime _selectedDate = DateTime.now();

  void _pickMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
              surface: Color(0xFF070D14),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authService = ref.read(authServiceProvider);
    final profile = authService.getLocalProfile();
    final driverId = profile?.id;

    if (driverId == null) {
      return const Scaffold(backgroundColor: Color(0xFF070D14), body: Center(child: CircularProgressIndicator()));
    }

    final paymentsAsync = ref.watch(myPaymentsProvider(driverId));

    return Scaffold(
      backgroundColor: const Color(0xFF070D14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance_wallet, color: Colors.greenAccent, size: 20),
            ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 2000.ms),
            12.widthBox,
            (l10n?.navWallet ?? "MY WALLET").text.white.letterSpacing(1).bold.make(),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.cyanAccent),
            onPressed: _pickMonth,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dark_map_optimized.jpg'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: paymentsAsync.when(
          data: (payments) {
            // Filter payments for selected month
            final currentMonthPayments = payments.where((p) {
              final date = DateTime.parse(p['payment_date']);
              return date.year == _selectedDate.year && date.month == _selectedDate.month;
            }).toList();

            final totalAdvance = currentMonthPayments.fold<double>(0, (sum, p) => sum + (p['amount'] as num).toDouble());

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20).copyWith(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Current Balance Card
                        _buildBalanceCard(l10n, totalAdvance, currentMonthPayments.length),
                        
                        20.heightBox,
                        
                        // Monthly Settlement Card
                        _buildMonthlySettlement(l10n, driverId, totalAdvance),
                        
                        30.heightBox,
                        
                        // Request Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Request Advance logic
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 10,
                              shadowColor: Colors.greenAccent.withValues(alpha: 0.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_circle_outline),
                                8.widthBox,
                                (l10n?.requestAdvance ?? "REQUEST ADVANCE").text.bold.letterSpacing(1).make(),
                              ],
                            ),
                          ),
                        ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scaleXY(end: 1.02, duration: 1500.ms),
                        
                        40.heightBox,
                        
                        // Recent Advances Title
                        (l10n?.recentAdvances ?? "Recent Advances").text.white.bold.lg.make(),
                        16.heightBox,
                        
                        // List
                        if (currentMonthPayments.isEmpty)
                          "No advances taken this month.".text.color(Colors.white54).make()
                        else
                          ...currentMonthPayments.map((adv) {
                            final index = currentMonthPayments.indexOf(adv);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildAdvanceItem(adv),
                            ).animate().fade(delay: (index * 100).ms).slideX(begin: 0.2, end: 0);
                          }),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.greenAccent)),
          error: (err, stack) => Center(child: Text("Error: $err", style: const TextStyle(color: Colors.red))),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(AppLocalizations? l10n, double totalAmount, int count) {
    final formatter = NumberFormat('#,##0');
    final monthName = DateFormat('MMMM yyyy').format(_selectedDate);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.greenAccent.withValues(alpha: 0.2),
                Colors.blueAccent.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ]
          ),
          child: Column(
            children: [
              "Total Advance ($monthName)".text.color(Colors.white70).letterSpacing(1).make(),
              16.heightBox,
              "৳ ${formatter.format(totalAmount)}".text.white.bold.size(42).make().animate().scale(delay: 200.ms, duration: 400.ms),
              24.heightBox,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.cyanAccent, size: 16),
                    8.widthBox,
                    "$count Advances taken this month".text.color(Colors.cyanAccent).size(12).make(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 500.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildAdvanceItem(Map<String, dynamic> data) {
    final formatter = NumberFormat('#,##0');
    final date = DateFormat('dd MMM yyyy').format(DateTime.parse(data['payment_date']));
    final amount = formatter.format(data['amount']);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.account_balance_wallet, color: Colors.greenAccent, size: 20),
              ),
              16.widthBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Advance".text.white.bold.lg.make(),
                  4.heightBox,
                  date.text.color(Colors.white54).size(12).make(),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              "৳ $amount".text.color(Colors.greenAccent).bold.xl.make(),
              4.heightBox,
              (data['notes'] ?? "Approved").toString().text.color(Colors.greenAccent).size(10).make(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySettlement(AppLocalizations? l10n, String driverId, double totalAdvance) {
    final monthStr = DateFormat('yyyy-MM').format(_selectedDate);
    final monthDisplay = DateFormat('MMMM yyyy').format(_selectedDate);
    
    return FutureBuilder<Map<String, dynamic>?>(
      future: Supabase.instance.client
          .from('monthly_bills')
          .select('*')
          .eq('driver_id', driverId)
          .eq('month_year', monthStr)
          .maybeSingle(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
        }

        final formatter = NumberFormat('#,##0');
        
        if (!snapshot.hasData || snapshot.data == null) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10, width: 1),
            ),
            child: Center(
              child: "No settlement generated for $monthDisplay yet.".text.color(Colors.white54).make(),
            ),
          );
        }

        final bill = snapshot.data!;
        
        final totalEarnings = (bill['total_bill_amount'] as num?)?.toDouble() ?? 0;
        final netPayable = totalEarnings - totalAdvance;
        final isVerified = bill['status'] == 'Verified';
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isVerified ? Colors.greenAccent.withValues(alpha: 0.4) : Colors.cyanAccent.withValues(alpha: 0.2), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(isVerified ? Icons.verified : Icons.history, color: isVerified ? Colors.greenAccent : Colors.cyanAccent, size: 20),
                      8.widthBox,
                      "$monthDisplay Settlement".text.color(isVerified ? Colors.greenAccent : Colors.cyanAccent).bold.letterSpacing(1).make(),
                    ],
                  ),
                  if (isVerified)
                    "Verified".text.color(Colors.greenAccent).size(10).make(),
                ],
              ),
              16.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "Total Advances Taken:".text.color(Colors.white54).make(),
                  "৳ ${formatter.format(totalAdvance)}".text.white.bold.make(),
                ],
              ),
              8.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "Total Salary/Earnings:".text.color(Colors.white54).make(),
                  "৳ ${formatter.format(totalEarnings)}".text.white.bold.make(),
                ],
              ),
              const Divider(color: Colors.white10, height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "Net Payable (You will get):".text.color(Colors.greenAccent).make(),
                  "৳ ${formatter.format(netPayable > 0 ? netPayable : 0)}".text.color(Colors.greenAccent).bold.xl.make(),
                ],
              ),
              if (isVerified) ...[
                const Divider(color: Colors.white10, height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        // Fetch driver details on the fly for PDF
                        final driverData = await Supabase.instance.client
                            .from('profiles')
                            .select('*, vehicles(plate_number)')
                            .eq('id', driverId)
                            .maybeSingle();
                            
                        if (driverData != null) {
                           await PdfBillingSlipService.generateAndPrintSlip(
                             driverData: driverData,
                             billData: bill,
                           );
                        } else {
                           if (context.mounted) {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not fetch driver data')));
                           }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
                        }
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.greenAccent, size: 18),
                    label: "Download Bill PDF".text.color(Colors.greenAccent).make(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.greenAccent.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ).animate().fade(delay: 600.ms).slideY(begin: 0.1, end: 0);
      },
    );
  }
}
