import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ubs_fleet_app/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ExpenseEntryScreen extends StatefulWidget {
  const ExpenseEntryScreen({super.key});

  @override
  State<ExpenseEntryScreen> createState() => _ExpenseEntryScreenState();
}

class _ExpenseEntryScreenState extends State<ExpenseEntryScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedExpenseType;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final expenseTypes = [
      l10n.typeToll,
      l10n.typeParking,
      l10n.typeMaintenance,
      l10n.typeOther
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: l10n.addExpenseTitle.text.bold.letterSpacing(1.5).white.make(),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyanAccent.withValues(alpha: 0.1),
              ),
            ).box.withShadow([BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.2), blurRadius: 100)]).make(),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        l10n.expenseType.text.color(Colors.white70).make(),
                        8.heightBox,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedExpenseType,
                              hint: l10n.expenseType.text.color(Colors.white38).make(),
                              dropdownColor: AppColors.background,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.cyanAccent),
                              style: const TextStyle(color: Colors.white, fontFamily: 'Outfit'),
                              items: expenseTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: type.text.make(),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedExpenseType = val;
                                });
                              },
                            ),
                          ),
                        ),
                        20.heightBox,
                        
                        CustomTextField(
                          controller: _amountController,
                          hint: l10n.amount,
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                        ),
                        20.heightBox,
                        
                        CustomTextField(
                          controller: _descriptionController,
                          hint: l10n.description,
                          icon: Icons.notes,
                        ),
                      ],
                    ),
                  ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),
                  
                  24.heightBox,
                  
                  // Receipt Upload Section
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_upload_outlined, color: Colors.cyanAccent, size: 48),
                        16.heightBox,
                        l10n.uploadReceiptLabel.text.bold.white.make(),
                        8.heightBox,
                        "JPG, PNG (Max 5MB)".text.color(Colors.white54).size(12).make(),
                      ],
                    ).py20().wFull(context),
                  ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),
                  
                  40.heightBox,
                  
                  // Save Button
                  ElevatedButton(
                    onPressed: () {
                      // Save action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: Colors.cyanAccent.withValues(alpha: 0.5),
                    ),
                    child: l10n.saveExpense.text.xl.bold.letterSpacing(1).make(),
                  ).animate().fade(delay: 400.ms).slideY(begin: 0.1, end: 0),
                  
                  20.heightBox,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
          ),
          child: child,
        ),
      ),
    );
  }
}
