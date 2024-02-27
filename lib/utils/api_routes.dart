import 'package:flutter/foundation.dart';

class ApiRoutes {
  static const String apiUrl = 'https://rebhalakhera.herokuapp.com';

  static const String azkar = '$apiUrl/quran/aqsam/';
  static const String dailyTasks = '$apiUrl/quran/alarms/';
  static const String deviceInfo = '$apiUrl/quran/devices/';
  static const String fcmSendNotifications =
      'https://fcm.googleapis.com/fcm/send';
  static String prayerTimes({
    required double lng,
    required double lat,
    required int year,
    required int month,
  }) =>
      'http://api.aladhan.com/v1/calendar?latitude=$lat&longitude=$lng&month=$month&year=$year';
}
