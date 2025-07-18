import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String baseUrl = "";
  static String broker = "";
  static String username = "";
  static String key = "";
  static String mqttTopicBase = "";

  static Future<void> load() async {
    try {
      final configString = await rootBundle.loadString('configs/private.json');
      final config = jsonDecode(configString);
      baseUrl = config['BASEURL'];
      broker = config['broker'];
      username = config['username'];
      key = config['key'];
      mqttTopicBase = config['MQTT_TOPIC_BASE'];
    } catch (e) {
      // Fallback to environment variables if private.json is not found (e.g., in CI/CD)
      await dotenv.load();
      baseUrl = dotenv.env['BASEURL'] ?? '';
      broker = dotenv.env['BROKER'] ?? '';
      username = dotenv.env['USERNAME'] ?? '';
      key = dotenv.env['KEY'] ?? '';
      mqttTopicBase = dotenv.env['MQTT_TOPIC_BASE'] ?? '';
    }
  }
}
