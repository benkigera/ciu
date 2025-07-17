import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Env {
  static String baseUrl = "";
  static String broker = "";
  static String username = "";
  static String key = "";
  static String mqttTopicBase = "";

  static Future<void> load() async {
    final configString = await rootBundle.loadString('configs/private.json');
    final config = jsonDecode(configString);
    baseUrl = config['BASEURL'];
    broker = config['broker'];
    username = config['username'];
    key = config['key'];
    mqttTopicBase = config['MQTT_TOPIC_BASE'];
  }
}
