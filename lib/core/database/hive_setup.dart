import 'package:hive_flutter/hive_flutter.dart';

import 'entities/profile_local.dart';
import 'entities/vehicle_local.dart';
import 'entities/daily_log_local.dart';
import 'entities/expense_local.dart';
import 'entities/sync_action.dart';

class HiveSetup {
  static const String profilesBox = 'profilesBox';
  static const String vehiclesBox = 'vehiclesBox';
  static const String dailyLogsBox = 'dailyLogsBox';
  static const String expensesBox = 'expensesBox';
  static const String syncQueueBox = 'syncQueueBox';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(ProfileLocalAdapter());
    Hive.registerAdapter(VehicleLocalAdapter());
    Hive.registerAdapter(DailyLogLocalAdapter());
    Hive.registerAdapter(ExpenseLocalAdapter());
    Hive.registerAdapter(SyncActionAdapter());

    // Open Boxes
    await Hive.openBox<ProfileLocal>(profilesBox);
    await Hive.openBox<VehicleLocal>(vehiclesBox);
    await Hive.openBox<DailyLogLocal>(dailyLogsBox);
    await Hive.openBox<ExpenseLocal>(expensesBox);
    await Hive.openBox<SyncAction>(syncQueueBox);
  }
}
