import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ubs_fleet_app/core/database/entities/daily_log_local.dart';
import 'package:ubs_fleet_app/core/database/entities/expense_local.dart';
import 'package:ubs_fleet_app/core/database/entities/sync_action.dart';
import 'package:ubs_fleet_app/core/database/hive_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter('ubs_fleet_app');
  
  Hive.registerAdapter(DailyLogLocalAdapter());
  Hive.registerAdapter(ExpenseLocalAdapter());
  Hive.registerAdapter(SyncActionAdapter());

  final logBox = await Hive.openBox<DailyLogLocal>(HiveSetup.dailyLogsBox);
  final syncBox = await Hive.openBox<SyncAction>(HiveSetup.syncQueueBox);
  
  final pendingLogIds = <String>{};
  for (var action in syncBox.values) {
    if (action.actionType == 'CREATE_LOG') {
      try {
        final payload = jsonDecode(action.payload);
        if (payload['id'] != null) {
          pendingLogIds.add(payload['id']);
        }
      } catch (e) {}
    }
  }

  int deletedCount = 0;
  final keysToDelete = [];
  for (var key in logBox.keys) {
    final log = logBox.get(key);
    // If it's not synced AND not in the pending creation queue, it's an orphan!
    if (log != null && !log.isSynced && !pendingLogIds.contains(log.id)) {
      keysToDelete.add(key);
      print('Orphan found! Date: ${log.startTime}, ID: ${log.id}');
    }
    // Also just to be safe, if the date is exactly 6th, delete it
    if (log != null && log.startTime.day == 6) {
      keysToDelete.add(key);
    }
  }

  for (var key in keysToDelete) {
    await logBox.delete(key);
    deletedCount++;
  }

  print('=====================================');
  print('Successfully deleted $deletedCount orphaned/6th logs!');
  print('=====================================');
  
  exit(0);
}
