// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_log_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyLogLocalAdapter extends TypeAdapter<DailyLogLocal> {
  @override
  final int typeId = 2;

  @override
  DailyLogLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyLogLocal(
      id: fields[0] as String,
      driverId: fields[1] as String,
      vehicleId: fields[2] as String,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime?,
      startKm: fields[5] as int,
      endKm: fields[6] as int?,
      totalKm: fields[7] as int?,
      status: fields[8] as String,
      nightStay: fields[9] as bool,
      isSynced: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DailyLogLocal obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.driverId)
      ..writeByte(2)
      ..write(obj.vehicleId)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.startKm)
      ..writeByte(6)
      ..write(obj.endKm)
      ..writeByte(7)
      ..write(obj.totalKm)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.nightStay)
      ..writeByte(10)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyLogLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
