import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pawane_ciu/enums/status.dart';
import 'package:pawane_ciu/models/meter.dart';
import 'package:pawane_ciu/state/ciu_screen_state.dart';
import 'package:pawane_ciu/db/meter_db_service.dart';

part 'ciu_screen_notifier.g.dart';

@Riverpod(keepAlive: true)
class CiuScreenNotifier extends _$CiuScreenNotifier {
  final MeterDbService _meterDbService = MeterDbService();

  @override
  CiuScreenState build() {
    _meterDbService.init(); // Ensure Hive is initialized for this service
    final initialMeters = _meterDbService.getMeters();
    return CiuScreenState(
      token: '',
      status: Status.idle,
      isPowerOn: true,
      selectedMeterIndex: 0,
      meters: initialMeters,
    );
  }

  void handleKeyPress(String value) {
    if (!state.isPowerOn) return;

    state = state.copyWith(status: Status.idle);

    if (value == 'ENTER') {
      _processToken();
    } else if (value == 'BACK') {
      if (state.token.isNotEmpty) {
        state = state.copyWith(token: state.token.substring(0, state.token.length - 1));
      }
    } else if (value == 'POWER') {
      togglePower();
    } else if (int.tryParse(value) != null) {
      if (state.token.length < 20) {
        state = state.copyWith(token: state.token + value);
      }
    }
  }

  void togglePower() {
    state = state.copyWith(isPowerOn: !state.isPowerOn);
    if (!state.isPowerOn) {
      state = state.copyWith(status: Status.offline, token: '');
    } else {
      state = state.copyWith(status: Status.idle);
    }
  }

  void _processToken() {
    state = state.copyWith(status: Status.processing);

    // Simulate scan animation and processing
    Future.delayed(const Duration(milliseconds: 800), () {
      if (state.token.length == 20 && state.token.startsWith('1234')) {
        state = state.copyWith(status: Status.success, token: 'TOKEN ACCEPTED');
      } else {
        state = state.copyWith(status: Status.error, token: 'INVALID TOKEN');
      }

      Future.delayed(const Duration(seconds: 3), () {
        state = state.copyWith(token: '', status: Status.idle);
      });
    });
  }

  void selectMeter(int index) {
    state = state.copyWith(selectedMeterIndex: index);
  }

  Meter get currentMeter {
    if (state.meters.isEmpty) {
      return Meter(
        serialNumber: 'NO METER SELECTED',
        location: 'N/A',
        isActive: false,
        lastUpdate: DateTime.now(),
      );
    }
    return state.meters[state.selectedMeterIndex];
  }

  Future<void> addMeter(Meter meter) async {
    await _meterDbService.addMeter(meter);
    state = state.copyWith(meters: _meterDbService.getMeters());
  }

  Future<void> updateMeter(Meter meter) async {
    await _meterDbService.updateMeter(meter);
    state = state.copyWith(meters: _meterDbService.getMeters());
  }

  Future<void> deleteMeter(String serialNumber) async {
    await _meterDbService.deleteMeter(serialNumber);
    state = state.copyWith(meters: _meterDbService.getMeters());
  }
}
