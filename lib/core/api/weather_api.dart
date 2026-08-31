import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class WeatherApi {
  /// Check if it's raining right now based on lat/lng using Open-Meteo API.
  /// This is an online-only API. If offline, it simply throws or returns false.
  static Future<bool> isRaining(double lat, double lng) async {
    try {
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&current_weather=true');
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final weatherCode = data['current_weather']['weathercode'] as int?;
        // Open-Meteo weather codes: 
        // 51, 53, 55 (Drizzle), 61, 63, 65 (Rain), 80, 81, 82 (Rain showers)
        if (weatherCode != null) {
          if ((weatherCode >= 51 && weatherCode <= 65) || (weatherCode >= 80 && weatherCode <= 82)) {
            return true;
          }
        }
      }
    } catch (e) {
      debugPrint('NV WeatherApi check failed: $e');
    }
    return false;
  }
}
