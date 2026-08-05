// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_action.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncActionAdapter extends TypeAdapter<SyncAction> {
  @override
  final int typeId = 4;

  @override
  SyncAction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncAction(
      id: fields[0] as String,
      actionType: fields[1] as String,
      payload: fields[2] as String,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SyncAction obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.actionType)
      ..writeByte(2)
      ..write(obj.payload)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
