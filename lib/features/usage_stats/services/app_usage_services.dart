import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/models/app_usage.dart';
import '../domain/models/usage_event.dart';

class AppUsageService {
  static const platform = MethodChannel('wellbeing_channel');

  /// ดึงข้อมูลสรุปการใช้งานแอปย้อนหลัง 1 วัน
  Future<List<AppUsage>> getTodayUsage() async {
    try {
      final String result = await platform.invokeMethod('getTodayUsage');
      final List<dynamic> data = jsonDecode(result);
      return data.map((e) => AppUsage.fromJson(e)).toList();
    } on PlatformException catch (e) {
      throw Exception("Failed to get today usage: ${e.message}");
    }
  }

  /// ดึง events (foreground/background) ย้อนหลัง 1 วัน
  Future<List<UsageEvent>> getUsageEvents() async {
    try {
      final String result = await platform.invokeMethod('getUsageEvents');
      final List<dynamic> data = jsonDecode(result);
      final List<dynamic> data2 = data;
      final Set<dynamic> event_unique = data2
          .map((e) => e["eventType"])
          .toSet();
      print(event_unique);
      return data2.map((e) => UsageEvent.fromJson(e)).toList();
    } on PlatformException catch (e) {
      throw Exception("Failed to get usage events: ${e.message}");
    }
  }
}
