import 'package:hive/hive.dart';

part 'meter.g.dart';

@HiveType(typeId: 0)
class Meter {
  @HiveField(0)
  final String serialNumber;
  @HiveField(1)
  final String location;
  @HiveField(2)
  final bool isActive;
  @HiveField(3)
  final DateTime? lastUpdate;
  @HiveField(4)
  final double reading;

  Meter({
    required this.serialNumber,
    required this.location,
    required this.isActive,
    this.lastUpdate,
    this.reading = 0.0,
  });
}
