// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileLocalAdapter extends TypeAdapter<ProfileLocal> {
  @override
  final int typeId = 0;

  @override
  ProfileLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileLocal(
      id: fields[0] as String,
      fullName: fields[1] as String,
      employeeId: fields[2] as String,
      phoneNumber: fields[3] as String,
      role: fields[4] as String,
      avatarUrl: fields[5] as String?,
      drivingLicenseNo: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileLocal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.employeeId)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.avatarUrl)
      ..writeByte(6)
      ..write(obj.drivingLicenseNo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
