import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/database/hive_setup.dart';
import '../../../../core/database/entities/sync_action.dart';
import '../../../../core/database/entities/daily_log_local.dart';
import '../../../../core/database/entities/expense_local.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(Supabase.instance.client);
});

class SyncService {
  final SupabaseClient _supabase;
  StreamSubscription? _connectionSubscription;
  bool _isSyncing = false;

  SyncService(this._supabase) {
    _initConnectionListener();
  }

  void _initConnectionListener() {
    _connectionSubscription = InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.connected) {
        debugPrint('Internet restored. Triggering sync...');
        syncPendingActions();
      }
    });
  }

  /// Pushes an action to the local queue.
  Future<void> queueAction(String actionType, Map<String, dynamic> payload) async {
    final queueBox = Hive.box<SyncAction>(HiveSetup.syncQueueBox);
    final action = SyncAction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      actionType: actionType,
      payload: jsonEncode(payload),
      createdAt: DateTime.now(),
    );
    await queueBox.put(action.id, action);
    
    // Try to sync immediately just in case we have internet
    syncPendingActions();
  }

  /// Process the queue and push to Supabase
  Future<void> syncPendingActions() async {
    if (_isSyncing) return;
    
    final hasInternet = await InternetConnection().hasInternetAccess;
    if (!hasInternet) return;

    _isSyncing = true;
    final queueBox = Hive.box<SyncAction>(HiveSetup.syncQueueBox);
    final actions = queueBox.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt)); // FIFO

    for (var action in actions) {
      try {
        final payload = jsonDecode(action.payload) as Map<String, dynamic>;
        
        switch (action.actionType) {
          case 'CREATE_LOG':
            await _supabase.from('daily_logs').insert(payload);
            _markLogAsSynced(payload['id']);
            break;
          case 'UPDATE_LOG':
            final logId = payload['id'];
            payload.remove('id');
            await _supabase.from('daily_logs').update(payload).eq('id', logId);
            break;
          case 'CREATE_EXPENSE':
            await _supabase.from('expenses').insert(payload);
            _markExpenseAsSynced(payload['id']);
            break;
          default:
            debugPrint('Unknown sync action type: ${action.actionType}');
        }
        
        // Remove from queue upon success
        await queueBox.delete(action.id);
      } catch (e) {
        debugPrint('Failed to sync action ${action.id}: $e');
        
        // If it's a Supabase error (like invalid data), it will never succeed.
        // We delete it from the queue to prevent permanent blockage.
        if (e is PostgrestException) {
           debugPrint('PostgrestException caught. Deleting action to unblock queue.');
           await queueBox.delete(action.id);
        } else {
           // For network or other transient errors, we break and retry later
           break;
        }
      }
    }
    
    _isSyncing = false;
  }

  void _markLogAsSynced(String logId) {
    final box = Hive.box<DailyLogLocal>(HiveSetup.dailyLogsBox);
    final log = box.get(logId);
    if (log != null) {
      final updatedLog = DailyLogLocal(
        id: log.id,
        driverId: log.driverId,
        vehicleId: log.vehicleId,
        startTime: log.startTime,
        endTime: log.endTime,
        startKm: log.startKm,
        endKm: log.endKm,
        totalKm: log.totalKm,
        status: log.status,
        nightStay: log.nightStay,
        isSynced: true, // Mark as synced
      );
      box.put(logId, updatedLog);
    }
  }

  void _markExpenseAsSynced(String expenseId) {
    final box = Hive.box<ExpenseLocal>(HiveSetup.expensesBox);
    final expense = box.get(expenseId);
    if (expense != null) {
      final updatedExpense = ExpenseLocal(
        id: expense.id,
        logId: expense.logId,
        driverId: expense.driverId,
        expenseType: expense.expenseType,
        amount: expense.amount,
        createdAt: expense.createdAt,
        isSynced: true, // Mark as synced
      );
      box.put(expenseId, updatedExpense);
    }
  }

  void dispose() {
    _connectionSubscription?.cancel();
  }
}
