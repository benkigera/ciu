import 'package:mqtt_client/mqtt_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:meter_link/enums/status.dart';
import 'package:meter_link/models/meter.dart';
import 'package:meter_link/state/ciu_screen_state.dart';
import 'package:meter_link/db/meter_db_service.dart';
import 'package:meter_link/mqtt/client/mqtt_client.dart';
import 'package:meter_link/mqtt/handlers/mqtt_handlers.dart';
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
      isPowerOn:
          true, // Start with power off : TODO: Change this to true when testing for web...
      selectedMeterIndex: 0,
      meters: initialMeters,
      isTypingToken: false,
    );
  }

  void setStatus(Status newStatus) {
    state = state.copyWith(status: newStatus);
  }

  void setToken(String newToken) {
    state = state.copyWith(token: newToken);
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
      String cleanedText = clipboardData.text!.replaceAll(
        RegExp(r'[- ]'),
        '',
      ); // Remove dashes and spaces
      print('Cleaned text: $cleanedText');
      if (cleanedText.length > 20) {
        cleanedText = cleanedText.substring(0, 20);
        print('Truncated text: $cleanedText');
      }
      // Always update the token with the cleaned text, regardless of content
      state = state.copyWith(
        token: cleanedText,
        isTypingToken: true,
        status: Status.idle,
      );
    } else {
      print('Clipboard is empty or contains non-text data.');
      state = state.copyWith(status: Status.error, token: 'NOTHING TO PASTE');
    }

    // Reset error status after a delay (only if there was an error from empty clipboard)
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
    // The actual token injection is now handled in main.dart when ENTER is pressed.
    // This method can be removed or repurposed if needed.
    // For now, we'll just ensure the typing state is reset.
    state = state.copyWith(isTypingToken: false);
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

    int newSelectedMeterIndex = state.selectedMeterIndex;
    if (updatedMeters.isEmpty) {
      _mqttClientWrapper.disconnect();
      newSelectedMeterIndex = 0; // Reset index if no meters left
      state = state.copyWith(
        meters: updatedMeters,
        selectedMeterIndex: newSelectedMeterIndex,
        showMeterSelectionSheet: true, // Prompt user to add new meter
        isPowerOn: false, // Turn off power if no meters
        status: Status.offline, // Set status to offline
      );
    } else {
      // If the deleted meter was the currently selected one,
      // or if the selected index is now out of bounds,
      // adjust the selected index.
      if (serialNumber == state.meters[state.selectedMeterIndex].serialNumber ||
          state.selectedMeterIndex >= updatedMeters.length) {
        newSelectedMeterIndex = 0; // Select the first meter
      }
      state = state.copyWith(
        meters: updatedMeters,
        selectedMeterIndex: newSelectedMeterIndex,
      );
    }
  }

  void updateMeterStateFromMqtt(Meter updatedMeter) {
    _meterDbService.updateMeter(updatedMeter);
    state = state.copyWith(meters: _meterDbService.getMeters());
  }

  void setMqttConnected() {
    state = state.copyWith(
      isMqttConnected: true,
      isPowerOn: true,
      status: Status.idle,
    );
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
      subscribedTopics:
          state.subscribedTopics.where((t) => t != topic).toList(),
    );
  }

  Future<void> reconnectMqttClient() async {
    _mqttClientWrapper.disconnect();
    await _mqttClientWrapper.initialize();
    final status = await _mqttClientWrapper.connect();
    if (status?.state == MqttConnectionState.connected) {
      for (var meter in state.meters) {
        final topic =
            '${_mqttClientWrapper.mqttTopicBase}${meter.serialNumber}';
        _mqttClientWrapper.subscribe(topic);
      }
    }
  }
}
