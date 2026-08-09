import 'package:hive/hive.dart';

part 'profile_local.g.dart';

@HiveType(typeId: 0)
class ProfileLocal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String employeeId;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String role;

  @HiveField(5)
  final String? avatarUrl;

  @HiveField(6)
  final String? drivingLicenseNo;

  ProfileLocal({
    required this.id,
    required this.fullName,
    required this.employeeId,
    required this.phoneNumber,
    required this.role,
    this.avatarUrl,
    this.drivingLicenseNo,
  });
}
