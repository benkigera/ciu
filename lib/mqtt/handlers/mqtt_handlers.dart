import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawane_ciu/db/meter_db_service.dart';
import 'package:pawane_ciu/models/meter_reading_payload.dart';
import 'package:pawane_ciu/providers/ciu_screen_notifier.dart';

class MqttHandlers {
  static Function(String topic, String message)? onMessageReceivedCallback;
  static ProviderContainer? _container;

  static void setProviderContainer(ProviderContainer container) {
    _container = container;
  }

  static void messagePubHandler(String topic, String message) {
    print('[${DateTime.now()}] Received message from topic: $topic');
    print('[${DateTime.now()}] Received JSON payload: $message');

    try {
      final List<dynamic> decodedPayload = jsonDecode(message);
      final List<MeterReadingPayload> payload =
          decodedPayload
              .map(
                (item) =>
                    MeterReadingPayload.fromJson(item as Map<String, dynamic>),
              )
              .toList();

      double? availableCredit;

      for (var item in payload) {
        if (item.name == 'AvailableCredit') {
          availableCredit = (item.value as num).toDouble();
          break;
        }
      }

      if (availableCredit != null && _container != null) {
        final meterDbService = MeterDbService();
        final currentMeter =
            _container!.read(ciuScreenNotifierProvider.notifier).currentMeter;

        if (currentMeter.serialNumber != 'NO METER SELECTED') {
          final updatedMeter = currentMeter.copyWith(
            availableCredit: availableCredit,
            lastUpdate: DateTime.now(),
          );
          meterDbService.updateMeter(updatedMeter);
          _container!.read(ciuScreenNotifierProvider.notifier).updateMeterStateFromMqtt(updatedMeter);
        }
      }
    } catch (e) {
      print('Error parsing MQTT message or updating meter: $e');
    }
  }

  static void onConnected() {
    print('[${DateTime.now()}] Connected to MQTT broker');
  }

  static void onDisconnected() {
    print('[${DateTime.now()}] Disconnected from MQTT broker');
  }

  static void onSubscribed(String topic) {
    print('[${DateTime.now()}] Subscribed topic: $topic');
  }

  static void pong() {
    print('[${DateTime.now()}] Ping response client callback');
  }
}
