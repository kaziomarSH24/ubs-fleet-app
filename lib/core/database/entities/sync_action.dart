import 'package:hive/hive.dart';

part 'sync_action.g.dart';

@HiveType(typeId: 4)
class SyncAction extends HiveObject {
  @HiveField(0)
  final String id; // Unique ID for the action

  @HiveField(1)
  final String actionType; // e.g., 'CREATE_LOG', 'UPDATE_LOG', 'CREATE_EXPENSE'

  @HiveField(2)
  final String payload; // JSON string representation of the data to sync

  @HiveField(3)
  final DateTime createdAt;

  SyncAction({
    required this.id,
    required this.actionType,
    required this.payload,
    required this.createdAt,
  });
}
