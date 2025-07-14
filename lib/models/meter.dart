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
  final double availableCredit;

  Meter({
    required this.serialNumber,
    required this.location,
    required this.isActive,
    this.lastUpdate,
    required this.availableCredit,
  });

  Meter copyWith({
    String? serialNumber,
    String? location,
    bool? isActive,
    DateTime? lastUpdate,
    double? availableCredit,
  }) {
    return Meter(
      serialNumber: serialNumber ?? this.serialNumber,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      availableCredit: availableCredit ?? this.availableCredit,
    );
  }
}
