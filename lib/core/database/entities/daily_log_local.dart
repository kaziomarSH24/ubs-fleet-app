import 'package:hive/hive.dart';

part 'daily_log_local.g.dart';

@HiveType(typeId: 2)
class DailyLogLocal extends HiveObject {
  @HiveField(0)
  final String id; // Use UUID for local generation before syncing

  @HiveField(1)
  final String driverId;

  @HiveField(2)
  final String vehicleId;

  @HiveField(3)
  final DateTime startTime;

  @HiveField(4)
  final DateTime? endTime;

  @HiveField(5)
  final int startKm;

  @HiveField(6)
  final int? endKm;

  @HiveField(7)
  final int? totalKm;

  @HiveField(8)
  final String status; // e.g. "ongoing", "completed"

  @HiveField(9)
  final bool nightStay;
  
  @HiveField(10, defaultValue: false)
  final bool isSynced; // true if synced with supabase, false if pending

  @HiveField(11, defaultValue: false)
  final bool isStartTimeEdited; // true if driver edited the start time when ending duty

  DailyLogLocal({
    required this.id,
    required this.driverId,
    required this.vehicleId,
    required this.startTime,
    this.endTime,
    required this.startKm,
    this.endKm,
    this.totalKm,
    required this.status,
    required this.nightStay,
    this.isSynced = false,
    this.isStartTimeEdited = false,
  });
}
