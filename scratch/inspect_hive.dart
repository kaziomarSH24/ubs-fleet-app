import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'lib/core/database/entities/daily_log_local.dart';
import 'lib/core/database/entities/expense_local.dart';
import 'lib/core/database/entities/sync_action.dart';

void main() async {
  await Hive.initFlutter('ubs_fleet_app');
  Hive.registerAdapter(DailyLogLocalAdapter());
  Hive.registerAdapter(ExpenseLocalAdapter());
  Hive.registerAdapter(SyncActionAdapter());

  final logBox = await Hive.openBox<DailyLogLocal>('dailyLogs');
  final syncBox = await Hive.openBox<SyncAction>('syncQueue');

  print('--- LOCAL LOGS ---');
  for (var log in logBox.values) {
    print('ID: ${log.id}, Start: ${log.startTime}, isSynced: ${log.isSynced}');
  }

  print('\n--- SYNC QUEUE ---');
  for (var action in syncBox.values) {
    print('Action: ${action.actionType}, Payload: ${action.payload}');
  }
}
