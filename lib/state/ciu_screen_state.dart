import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meter_link/enums/status.dart';
import 'package:meter_link/models/meter.dart';

part 'ciu_screen_state.freezed.dart';

@freezed
class CiuScreenState with _$CiuScreenState {
  const factory CiuScreenState({
    required String token,
    required Status status,
    required bool isPowerOn,
    required int selectedMeterIndex,
    required List<Meter> meters,
    required bool isTypingToken,
    @Default(false) bool showAddMeterPrompt,
    @Default(false) bool showMeterSelectionSheet,
    @Default(false) bool isMqttConnected,
    @Default([]) List<String> subscribedTopics,
  }) = _CiuScreenState;
}
