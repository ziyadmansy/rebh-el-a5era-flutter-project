import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:http/http.dart';
import 'package:muslim_dialy_guide/common/shared.dart';
import 'package:muslim_dialy_guide/constants.dart';
import 'package:muslim_dialy_guide/models/prayer_time.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import '../utils/api_routes.dart';

class PrayersProvider with ChangeNotifier {
  // the key is the month number
  // the value is a list of the days of the month types
  // List<Map<String, List<PrayerTime>>> prayerTimes = [];
  List<PrayerTime> prayerTimes = [];
  Future<void> getPrayerTimes(double lng, double lat) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      print(prefs.getInt(currentMonthKey));
      if (prefs.getInt(currentMonthKey) == null ||
          prefs.getInt(currentMonthKey) != now.month) {
        print(ApiRoutes.prayerTimes(
          lng: lng,
          lat: lat,
          month: now.month,
          year: now.year,
        ));
        Response response = await get(
          Uri.parse(ApiRoutes.prayerTimes(
            lng: lng,
            lat: lat,
            month: now.month,
            year: now.year,
          )),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json; charset=UTF-8',
          },
        );
        final Map<String, dynamic> decodedResponseBody =
            json.decode(response.body);

        print(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          prayerTimes = (decodedResponseBody['data'] as List<dynamic>)
              .map<PrayerTime>((dayTime) => PrayerTime.fromJson(dayTime))
              .toList();
          // (decodedResponseBody['data'] as Map<String, dynamic>).forEach(
          //   (key, value) {
          //     prayerTimes.add(
          //       {
          //         key: (value as List<dynamic>)
          //             .map<PrayerTime>(
          //                 (prayerDay) => PrayerTime.fromJson(prayerDay))
          //             .toList(),
          //       },
          //     );
          //   },
          // );
          await sendPrayersNotifications();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendPrayersNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tz.initializeTimeZones();

    final now = DateTime.now();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final String currentTimeZone =
        await FlutterTimezone.getLocalTimezone();
    print('Current Time Zone: $currentTimeZone');

    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    // Test Prayer
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   1,
    //   'Test Zoned Schedule +2',
    //   'Test Local Notifications Plugin',
    //   tz.TZDateTime(
    //     tz.local,
    //     now.year,
    //     now.month,
    //     now.day,
    //     now.hour,
    //     now.minute + 2,
    //     0,
    //   ),
    //   platformChannelSpecifics,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    //   androidAllowWhileIdle: true,
    // );

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   2,
    //   'Test Zoned Schedule +4',
    //   'Test Local Notifications Plugin',
    //   tz.TZDateTime(
    //     tz.local,
    //     now.year,
    //     now.month,
    //     now.day,
    //     now.hour,
    //     now.minute + 4,
    //     0,
    //   ),
    //   platformChannelSpecifics,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    //   androidAllowWhileIdle: true,
    // );

    for (var prayerTime in prayerTimes) {
      final fajrPrayerDateTime = DateTime(
        prayerTime.date.year,
        prayerTime.date.month,
        prayerTime.date.day,
        prayerTime.fajrHour,
        prayerTime.fajrMinute,
      );
      final dhohrPrayerDateTime = DateTime(
        prayerTime.date.year,
        prayerTime.date.month,
        prayerTime.date.day,
        prayerTime.dhuhrHour,
        prayerTime.dhuhrMinute,
      );
      final asrPrayerDateTime = DateTime(
        prayerTime.date.year,
        prayerTime.date.month,
        prayerTime.date.day,
        prayerTime.asrHour,
        prayerTime.asrMinute,
      );
      final maghribPrayerDateTime = DateTime(
        prayerTime.date.year,
        prayerTime.date.month,
        prayerTime.date.day,
        prayerTime.maghribHour,
        prayerTime.maghribMinute,
      );
      final ishaPrayerDateTime = DateTime(
        prayerTime.date.year,
        prayerTime.date.month,
        prayerTime.date.day,
        prayerTime.ishaHour,
        prayerTime.ishaMinute,
      );
      // The scheduled date mustn't be in the past
      print('Day Prayer ID: ${prayerTime.date.timestamp}');

      // Fajr Prayer
      if (fajrPrayerDateTime.isAfter(now)) {
        print(
            'Scheduled Fajr Date: ${prayerTime.date.day}/${prayerTime.date.month}/${prayerTime.date.year}');
        await flutterLocalNotificationsPlugin.zonedSchedule(
          prayerTime.date.timestamp + 0, // to make it a different ID
          'أذان الفجر',
          'حان الآن موعد أذان الفجر',
          tz.TZDateTime(
            tz.local,
            prayerTime.date.year,
            prayerTime.date.month,
            prayerTime.date.day,
            prayerTime.fajrHour,
            prayerTime.fajrMinute,
          ),
          platformChannelSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
        );
      }

      // Dhohr Prayer
      if (dhohrPrayerDateTime.isAfter(now)) {
        print(
            'Scheduled Dhohr Date: ${prayerTime.date.day}/${prayerTime.date.month}/${prayerTime.date.year}');
        await flutterLocalNotificationsPlugin.zonedSchedule(
          prayerTime.date.timestamp + 1, // to make it a different ID
          'أذان الظهر',
          'حان الآن موعد أذان الظهر',
          tz.TZDateTime(
            tz.local,
            prayerTime.date.year,
            prayerTime.date.month,
            prayerTime.date.day,
            prayerTime.dhuhrHour,
            prayerTime.dhuhrMinute,
          ),
          platformChannelSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
        );
      }

      // Asr Prayer
      if (asrPrayerDateTime.isAfter(now)) {
        print(
            'Scheduled Asr Date: ${prayerTime.date.day}/${prayerTime.date.month}/${prayerTime.date.year}');
        await flutterLocalNotificationsPlugin.zonedSchedule(
          prayerTime.date.timestamp + 2, // to make it a different ID
          'أذان العصر',
          'حان الآن موعد أذان العصر',
          tz.TZDateTime(
            tz.local,
            prayerTime.date.year,
            prayerTime.date.month,
            prayerTime.date.day,
            prayerTime.asrHour,
            prayerTime.asrMinute,
          ),
          platformChannelSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
        );
      }

      // Maghrib Prayer
      if (maghribPrayerDateTime.isAfter(now)) {
        print(
            'Scheduled Maghrib Date: ${prayerTime.date.day}/${prayerTime.date.month}/${prayerTime.date.year}');
        await flutterLocalNotificationsPlugin.zonedSchedule(
          prayerTime.date.timestamp + 3, // to make it a different ID
          'أذان المغرب',
          'حان الآن موعد أذان المغرب',
          tz.TZDateTime(
            tz.local,
            prayerTime.date.year,
            prayerTime.date.month,
            prayerTime.date.day,
            prayerTime.maghribHour,
            prayerTime.maghribMinute,
          ),
          platformChannelSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
        );
      }

      // Isha Prayer
      if (ishaPrayerDateTime.isAfter(now)) {
        print(
            'Scheduled Isha Date: ${prayerTime.date.day}/${prayerTime.date.month}/${prayerTime.date.year}');
        await flutterLocalNotificationsPlugin.zonedSchedule(
          prayerTime.date.timestamp + 4, // to make it a different ID
          'أذان العشاء',
          'حان الآن موعد أذان العشاء',
          tz.TZDateTime(
            tz.local,
            prayerTime.date.year,
            prayerTime.date.month,
            prayerTime.date.day,
            prayerTime.ishaHour,
            prayerTime.ishaMinute,
          ),
          platformChannelSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
        );
      }
    }
    print('Prayer Times Notifications set successfully');
    await prefs.setInt(currentMonthKey, now.month);
    Shared.showToast('تم تفعيل إشعارات الصلاة');
  }
}
