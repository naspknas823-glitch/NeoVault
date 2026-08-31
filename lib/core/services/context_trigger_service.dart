import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/system_repositories.dart';
import '../api/weather_api.dart';

final contextTriggerProvider = Provider<ContextTriggerService>((ref) {
  return ContextTriggerService(ref);
});

class ContextTriggerService {
  ContextTriggerService(this._ref);
  final Ref _ref;

  /// (11) Post-salary reminders.
  /// User configures a payday (1..31). We check if today is payday or +1 day.
  Future<void> checkSalaryTrigger() async {
    final settings = _ref.read(settingsRepositoryProvider);
    final paydayStr = await settings.get('salary_day');
    if (paydayStr == null) return;
    
    final payday = int.tryParse(paydayStr);
    if (payday == null) return;

    final today = DateTime.now();
    if (today.day == payday || today.day == payday + 1) {
      // Check if we already notified this month
      final lastNotified = await settings.get('last_salary_notif_month');
      if (lastNotified != '${today.year}-${today.month}') {
        await _ref.read(notificationsRepositoryProvider).pushInApp(
          type: NotifType.system,
          titleKey: 'salary_trigger_title',
          bodyKey: 'salary_trigger_body',
        );
        await settings.set('last_salary_notif_month', '${today.year}-${today.month}');
      }
    }
  }

  /// (20) Seasonality of expenses.
  /// Checks current season and triggers a seasonal tip.
  Future<void> checkSeasonalityTrigger() async {
    final settings = _ref.read(settingsRepositoryProvider);
    final today = DateTime.now();
    
    String season;
    if (today.month == 12 || today.month <= 2) {
      season = 'winter';
    } else if (today.month <= 5) {
      season = 'spring';
    } else if (today.month <= 8) {
      season = 'summer';
    } else {
      season = 'autumn';
    }

    final lastSeasonNotif = await settings.get('last_season_notif');
    if (lastSeasonNotif != '${today.year}-$season') {
      await _ref.read(notificationsRepositoryProvider).pushInApp(
        type: NotifType.system,
        titleKey: 'season_trigger_title_$season',
        bodyKey: 'season_trigger_body_$season',
      );
      await settings.set('last_season_notif', '${today.year}-$season');
    }
  }

  /// (10) Weather trigger.
  /// Checks current weather. If it's raining, suggests saving on coffee/taxi.
  Future<void> checkWeatherTrigger() async {
    final settings = _ref.read(settingsRepositoryProvider);
    
    // Throttle weather checks to once per day
    final todayStr = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
    final lastWeatherCheck = await settings.get('last_weather_check');
    if (lastWeatherCheck == todayStr) return;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(timeLimit: Duration(seconds: 5)),
      );

      final isRaining = await WeatherApi.isRaining(position.latitude, position.longitude);
      if (isRaining) {
        await _ref.read(notificationsRepositoryProvider).pushInApp(
          type: NotifType.system,
          titleKey: 'weather_rain_title',
          bodyKey: 'weather_rain_body',
        );
      }
      await settings.set('last_weather_check', todayStr);
    } catch (e) {
      debugPrint('NV Weather trigger failed: $e');
    }
  }

  /// (9) Contextual hints.
  /// E.g. Evening analysis if user hasn't deposited today.
  Future<void> checkContextualHints() async {
    final now = DateTime.now();
    // Only trigger in the evening (e.g., 20:00 - 23:59)
    if (now.hour >= 20) {
      final settings = _ref.read(settingsRepositoryProvider);
      final todayStr = '${now.year}-${now.month}-${now.day}';
      final lastEveningNotif = await settings.get('last_evening_notif');
      if (lastEveningNotif != todayStr) {
        await _ref.read(notificationsRepositoryProvider).pushInApp(
          type: NotifType.system,
          titleKey: 'evening_hint_title',
          bodyKey: 'evening_hint_body',
        );
        await settings.set('last_evening_notif', todayStr);
      }
    }
  }

  /// (8) Geo-reminders.
  /// Very simple check distance to a target (e.g. Comfy/Foxtrot).
  /// Hardcoded mock electronics store coordinates for demonstration.
  Future<void> checkGeoReminders() async {
    final settings = _ref.read(settingsRepositoryProvider);
    final todayStr = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
    final lastGeoNotif = await settings.get('last_geo_notif');
    if (lastGeoNotif == todayStr) return;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(timeLimit: Duration(seconds: 5)),
      );

      // Mock coordinates (e.g. Gulliver mall in Kyiv)
      const targetLat = 50.4389;
      const targetLng = 30.5233;
      
      final distance = Geolocator.distanceBetween(
        position.latitude, position.longitude,
        targetLat, targetLng,
      );

      // If within 500 meters of the electronics store
      if (distance < 500) {
        await _ref.read(notificationsRepositoryProvider).pushInApp(
          type: NotifType.system,
          titleKey: 'geo_store_title',
          bodyKey: 'geo_store_body',
        );
        await settings.set('last_geo_notif', todayStr);
      }
    } catch (e) {
      debugPrint('NV Geo trigger failed: $e');
    }
  }

  /// Run all triggers. Should be called on app startup or periodically.
  Future<void> runAllTriggers() async {
    await checkSalaryTrigger();
    await checkSeasonalityTrigger();
    await checkContextualHints();
    await checkWeatherTrigger();
    await checkGeoReminders();
  }
}
