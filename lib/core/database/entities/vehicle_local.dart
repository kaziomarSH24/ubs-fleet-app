import 'package:hive/hive.dart';

part 'vehicle_local.g.dart';

@HiveType(typeId: 1)
class VehicleLocal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String model;

  @HiveField(2)
  final String plateNumber;

  @HiveField(3)
  final String fuelType;

  @HiveField(4)
  final String? currentDriverId;

  VehicleLocal({
    required this.id,
    required this.model,
    required this.plateNumber,
    required this.fuelType,
    this.currentDriverId,
  });
}
