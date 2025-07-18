import 'package:hive/hive.dart';
import 'package:meter_link/models/meter.dart';

class MeterDbService {
  static const String _boxName = 'meters';

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MeterAdapter());
    }
    await Hive.openBox<Meter>(_boxName);
  }

  Box<Meter> _meterBox() {
    return Hive.box<Meter>(_boxName);
  }

  List<Meter> getMeters() {
    return _meterBox().values.toList();
  }

  Future<void> addMeter(Meter meter) async {
    await _meterBox().put(meter.serialNumber, meter);
  }

  Future<void> updateMeter(Meter meter) async {
    await _meterBox().put(meter.serialNumber, meter);
  }

  Future<void> deleteMeter(String serialNumber) async {
    await _meterBox().delete(serialNumber);
  }

  Future<void> clearAllMeters() async {
    await _meterBox().clear();
  }
}
