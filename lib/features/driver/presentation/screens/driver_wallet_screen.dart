import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../l10n/app_localizations.dart';


class DriverWalletScreen extends StatelessWidget {
  const DriverWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // Mock Data for UI
    final mockAdvances = [
      {'date': '02 Aug 2026', 'amount': '৳ 2,000', 'status': 'Approved', 'icon': Icons.account_balance_wallet},
      {'date': '26 Jul 2026', 'amount': '৳ 1,500', 'status': 'Approved', 'icon': Icons.account_balance_wallet},
      {'date': '19 Jul 2026', 'amount': '৳ 3,000', 'status': 'Approved', 'icon': Icons.account_balance_wallet},
    ];

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
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dark_map_optimized.jpg'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Balance Card
                    _buildBalanceCard(l10n),
                    
                    20.heightBox,
                    
                    // Previous Month Settlement Card
                    _buildPreviousMonthSettlement(l10n),
                    
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
                    ...mockAdvances.map((adv) {
                      final index = mockAdvances.indexOf(adv);
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
        ),
      ),
    );
  }

  Widget _buildBalanceCard(AppLocalizations? l10n) {
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
              (l10n?.totalAdvanceThisMonth ?? "Total Advance (August)").text.color(Colors.white70).letterSpacing(1).make(),
              16.heightBox,
              "৳ 6,500".text.white.bold.size(42).make().animate().scale(delay: 200.ms, duration: 400.ms),
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
                    "3 Advances taken this month".text.color(Colors.cyanAccent).size(12).make(),
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
                child: Icon(data['icon'] as IconData, color: Colors.greenAccent, size: 20),
              ),
              16.widthBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Advance".text.white.bold.lg.make(),
                  4.heightBox,
                  (data['date'] as String).text.color(Colors.white54).size(12).make(),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              (data['amount'] as String).text.color(Colors.greenAccent).bold.xl.make(),
              4.heightBox,
              (data['status'] as String).text.color(Colors.greenAccent).size(10).make(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousMonthSettlement(AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: Colors.cyanAccent, size: 20),
              8.widthBox,
              "July 2026 Settlement".text.color(Colors.cyanAccent).bold.letterSpacing(1).make(),
            ],
          ),
          16.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Total Advances Taken:".text.color(Colors.white54).make(),
              "৳ 8,000".text.white.bold.make(),
            ],
          ),
          8.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Total Salary/Earnings:".text.color(Colors.white54).make(),
              "৳ 25,000".text.white.bold.make(),
            ],
          ),
          const Divider(color: Colors.white10, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Net Payable (You will get):".text.color(Colors.greenAccent).make(),
              "৳ 17,000".text.color(Colors.greenAccent).bold.xl.make(),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: 600.ms).slideY(begin: 0.1, end: 0);
  }
}
