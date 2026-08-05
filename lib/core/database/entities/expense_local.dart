import 'package:hive/hive.dart';

part 'expense_local.g.dart';

@HiveType(typeId: 3)
class ExpenseLocal extends HiveObject {
  @HiveField(0)
  final String id; // UUID

  @HiveField(1)
  final String logId; // UUID linking to daily_logs

  @HiveField(2)
  final String driverId;

  @HiveField(3)
  final String expenseType;

  @HiveField(4)
  final double amount;
  
  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final bool isSynced; // true if synced with supabase, false if pending

  ExpenseLocal({
    required this.id,
    required this.logId,
    required this.driverId,
    required this.expenseType,
    required this.amount,
    required this.createdAt,
    this.isSynced = false,
  });
}
