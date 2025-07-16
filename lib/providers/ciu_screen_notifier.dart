import 'package:mqtt_client/mqtt_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pawane_ciu/enums/status.dart';
import 'package:pawane_ciu/models/meter.dart';
import 'package:pawane_ciu/state/ciu_screen_state.dart';
import 'package:pawane_ciu/db/meter_db_service.dart';
import 'package:pawane_ciu/mqtt/client/mqtt_client.dart';
import 'package:pawane_ciu/mqtt/handlers/mqtt_handlers.dart';
import 'package:flutter/services.dart'; // Import for Clipboard

part 'ciu_screen_notifier.g.dart';

@Riverpod(keepAlive: true)
class CiuScreenNotifier extends _$CiuScreenNotifier {
  final MeterDbService _meterDbService = MeterDbService();
  late final MqttClientWrapper _mqttClientWrapper;

  @override
  CiuScreenState build() {
    _meterDbService.init(); // Ensure Hive is initialized for this service
    final initialMeters = _meterDbService.getMeters();

    _mqttClientWrapper = MqttClientWrapper();
    MqttHandlers.setProviderContainer(ref.container);
    return CiuScreenState(
      token: '',
      status: Status.idle,
      isPowerOn: false, // Start with power off
      selectedMeterIndex: 0,
      meters: initialMeters,
      isTypingToken: false,
    );
  }

  void handleKeyPress(String value) {
    if (!state.isPowerOn) return;

    state = state.copyWith(status: Status.idle);

    if (value == 'ENTER') {
      _processToken();
      state = state.copyWith(isTypingToken: false);
    } else if (value == 'BACK') {
      if (state.token.isNotEmpty) {
        state = state.copyWith(
          token: state.token.substring(0, state.token.length - 1),
        );
      }
      if (state.token.isEmpty) {
        state = state.copyWith(isTypingToken: false);
      }
    } else if (value == 'PASTE') {
      _handlePaste();
    } else if (value == 'POWER') {
      togglePower();
    } else if (int.tryParse(value) != null) {
      state = state.copyWith(isTypingToken: true);
      if (state.token.length < 20) {
        state = state.copyWith(token: state.token + value);
      }
    }
  }

  Future<void> _handlePaste() async {
    print('Attempting to paste...');
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null) {
      print('Clipboard content: ${clipboardData.text}');
      String cleanedText = clipboardData.text!.replaceAll(RegExp(r'[- ]'), ''); // Remove dashes and spaces
      print('Cleaned text: $cleanedText');
      if (cleanedText.length > 20) {
        cleanedText = cleanedText.substring(0, 20);
        print('Truncated text: $cleanedText');
      }

      if (cleanedText.isEmpty) {
        state = state.copyWith(status: Status.error, token: 'NOTHING TO PASTE');
      } else if (int.tryParse(cleanedText) != null) {
        print('Valid number, updating token.');
        state = state.copyWith(token: cleanedText, isTypingToken: true);
      } else {
        print('Invalid paste content: Not a valid number after cleaning.');
        state = state.copyWith(status: Status.error, token: 'INVALID FORMAT');
      }
    } else {
      print('Clipboard is empty or contains non-text data.');
      state = state.copyWith(status: Status.error, token: 'NOTHING TO PASTE');
    }

    // Reset error status after a delay
    if (state.status == Status.error) {
      Future.delayed(const Duration(seconds: 2), () {
        state = state.copyWith(token: '', status: Status.idle);
      });
    }
  }

  void togglePower() {
    if (state.isPowerOn) {
      _mqttClientWrapper.disconnect();
    } else {
      if (state.meters.isEmpty) {
        state = state.copyWith(showMeterSelectionSheet: true);
        return;
      }
      reconnectMqttClient();
    }
  }

  void dismissMeterSelectionSheet() {
    state = state.copyWith(showMeterSelectionSheet: false);
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
        state = state.copyWith(
          token: '',
          status: Status.idle,
          isTypingToken: false,
        );
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
        lastUpdate: null,
        availableCredit: 0.0,
      );
    }
    return state.meters[state.selectedMeterIndex];
  }

  Future<void> addMeter(Meter meter) async {
    await _meterDbService.addMeter(meter);
    state = state.copyWith(meters: _meterDbService.getMeters());
    // Subscribe to the new meter's topic
    final topic = '${_mqttClientWrapper.mqttTopicBase}${meter.serialNumber}';
    _mqttClientWrapper.subscribe(topic);
  }

  Future<void> updateMeter(Meter meter) async {
    await _meterDbService.updateMeter(meter);
    state = state.copyWith(meters: _meterDbService.getMeters());
  }

  Future<void> deleteMeter(String serialNumber) async {
    // Unsubscribe from the meter's topic before deleting
    final topic = '${_mqttClientWrapper.mqttTopicBase}$serialNumber';
    _mqttClientWrapper.unsubscribe(topic);

    await _meterDbService.deleteMeter(serialNumber);
    final updatedMeters = _meterDbService.getMeters();
    state = state.copyWith(meters: updatedMeters);
    if (updatedMeters.isEmpty) {
      _mqttClientWrapper.disconnect();
    }
  }

  void updateMeterStateFromMqtt(Meter updatedMeter) {
    _meterDbService.updateMeter(updatedMeter);
    state = state.copyWith(meters: _meterDbService.getMeters());
  }

  void setMqttConnected() {
    state = state.copyWith(isMqttConnected: true, isPowerOn: true, status: Status.idle);
  }

  void setMqttDisconnected() {
    state = state.copyWith(
      isMqttConnected: false,
      isPowerOn: false,
      status: Status.offline,
      subscribedTopics: [],
      token: '',
    );
  }

  void addSubscribedTopic(String topic) {
    if (!state.subscribedTopics.contains(topic)) {
      state = state.copyWith(
        subscribedTopics: [...state.subscribedTopics, topic],
      );
    }
  }

  void removeSubscribedTopic(String topic) {
    state = state.copyWith(
      subscribedTopics: state.subscribedTopics.where((t) => t != topic).toList(),
    );
  }

  Future<void> reconnectMqttClient() async {
    _mqttClientWrapper.disconnect();
    await _mqttClientWrapper.initialize();
    final status = await _mqttClientWrapper.connect();
    if (status?.state == MqttConnectionState.connected) {
      for (var meter in state.meters) {
        final topic = '${_mqttClientWrapper.mqttTopicBase}${meter.serialNumber}';
        _mqttClientWrapper.subscribe(topic);
      }
    }
  }
}
