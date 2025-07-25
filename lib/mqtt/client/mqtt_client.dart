import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:meter_link/mqtt/handlers/mqtt_handlers.dart';
import 'package:meter_link/utils/env.dart';

class MqttClientWrapper {
  MqttServerClient? client;

  MqttClientWrapper();

  Future<void> initialize() async {
    try {
      client = MqttServerClient(Env.broker, '');
      client!.port = 1883; // Standard MQTT port
      client!.logging(on: false);
      client!.keepAlivePeriod = 30;
      client!.onDisconnected = MqttHandlers.onDisconnected;
      client!.onConnected = MqttHandlers.onConnected;
      client!.onSubscribed = (String topic) => MqttHandlers.onSubscribed(topic);
      client!.onUnsubscribed =
          (String? topic) => MqttHandlers.onUnsubscribed(topic!);
      client!.pongCallback = MqttHandlers.pong;

      final connMess = MqttConnectMessage()
          .withClientIdentifier(
            'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
          )
          .withWillTopic('willtopic') // If you want to send a will message
          .withWillMessage('Will message')
          .startClean() // Non persistent session for testing
          .withWillQos(MqttQos.atLeastOnce);
      client!.connectionMessage = connMess;
    } catch (e) {
      print('Error initializing MQTT client: $e');
    }
  }

  Future<MqttClientConnectionStatus?> connect() async {
    if (client == null) {
      await initialize();
    }
    if (client == null) return null;

    while (client!.connectionStatus!.state != MqttConnectionState.connected) {
      try {
        await client!.connect(Env.username, Env.key);
      } on NoConnectionException catch (e) {
        print('Client exception - $e');
        client!.disconnect();
      } on SocketException catch (e) {
        print('Socket exception - $e');
        client!.disconnect();
      }

      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        print('MQTT client connected');
        client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
          final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
          final String pt = MqttPublishPayload.bytesToStringAsString(
            recMess.payload.message,
          );
          MqttHandlers.messagePubHandler(c[0].topic, pt);
        });
      } else {
        print(
          'MQTT client connection failed - retrying in 5 seconds, status is ${client!.connectionStatus}',
        );
        await Future.delayed(const Duration(seconds: 5));
      }
    }
    return client!.connectionStatus;
  }

  void disconnect() {
    client?.disconnect();
    print('MQTT client disconnected');
  }

  void subscribe(String topic) {
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      print('Subscribing to the $topic topic');
      client!.subscribe(topic, MqttQos.atMostOnce);
    } else {
      print('Cannot subscribe, client not connected');
    }
  }

  void unsubscribe(String topic) {
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      print('Unsubscribing from the $topic topic');
      client!.unsubscribe(topic);
    } else {
      print('Cannot unsubscribe, client not connected');
    }
  }

  String get mqttTopicBase => Env.mqttTopicBase;
}
