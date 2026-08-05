// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleLocalAdapter extends TypeAdapter<VehicleLocal> {
  @override
  final int typeId = 1;

  @override
  VehicleLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VehicleLocal(
      id: fields[0] as String,
      model: fields[1] as String,
      plateNumber: fields[2] as String,
      fuelType: fields[3] as String,
      currentDriverId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VehicleLocal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.plateNumber)
      ..writeByte(3)
      ..write(obj.fuelType)
      ..writeByte(4)
      ..write(obj.currentDriverId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
