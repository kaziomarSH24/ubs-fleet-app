// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseLocalAdapter extends TypeAdapter<ExpenseLocal> {
  @override
  final int typeId = 3;

  @override
  ExpenseLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseLocal(
      id: fields[0] as String,
      logId: fields[1] as String,
      driverId: fields[2] as String,
      expenseType: fields[3] as String,
      amount: fields[4] as double,
      createdAt: fields[5] as DateTime,
      isSynced: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseLocal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.logId)
      ..writeByte(2)
      ..write(obj.driverId)
      ..writeByte(3)
      ..write(obj.expenseType)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
