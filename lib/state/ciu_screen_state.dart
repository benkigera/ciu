import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawane_ciu/enums/status.dart';
import 'package:pawane_ciu/models/meter.dart';

part 'ciu_screen_state.freezed.dart';

@freezed
class CiuScreenState with _$CiuScreenState {
  const factory CiuScreenState({
    required String token,
    required Status status,
    required bool isPowerOn,
    required int selectedMeterIndex,
    required List<Meter> meters,
  }) = _CiuScreenState;
}
