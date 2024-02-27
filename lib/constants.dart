import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Constants {
/*---------------------------------------------------------------------------------------------*/
/*-------------------------------------- time zone  ------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  static final double timeZone = 2.0;
}

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------- App Custom Colors ----------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
final Color primaryColor = Color.fromARGB(255, 0, 27, 68);

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------- App Carousel type ----------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
// enum CarouselType { Morning, Night }

const String appName = 'ربح الآخرة';
const String appPlayStoreUrl =
    'https://play.google.com/store/apps/details?id=com.maryamyehya.rebhelakhra';
const String errorMsg =
    'حدث خطأ برجاء التأكد من شبكة الإنترنت و إعادة المحاولة';

const double kBorderRadius = 24.0;

final Color redColor = Colors.red[600]!;
final Color greenColor = Colors.greenAccent[700]!;
const List<Color> gradColors = [
  Color(0xff030357),
  Color(0xff1CB5E0),
  Color(0xffC2ECF3),
];

const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
  prayersChannelId,
  prayersChannelName,
  channelDescription: prayersChannelDescription,
  importance: Importance.max,
  priority: Priority.high,
  enableVibration: true,
  sound: RawResourceAndroidNotificationSound('azan'),
  playSound: true,
);

const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

int? currentMonth;

const String prayersChannelId = 'prayerTimes';
const String prayersChannelName = 'Prayer Times';
const String prayersChannelDescription =
    'Channel to show prayer times notifications';

const String androidText = 'android';
const String iosText = 'ios';
const String webText = 'web';

const String fcmKey = 'FCMToken';
const String prophitWordsDialogKey = 'prophitWordsDialog';
const String totalSebhaCountKey = 'totalSebhaCount';
const String publicTopic = 'publicUsers';
const String currentMonthKey = 'currentMonth';
const String azkarResponseKey = 'azkarResponseKey';
const String dailyTasksResponseKey = 'dailyTasksResponseKey';

const String apiKey = 'Api-Key KGAWYWYU.yidSuXC8xudXlbPo0PO26UritiQVRH8y';
const String firebaseServerKey =
    'key=AAAAL2b5XLc:APA91bHxxRlrEl6ZqyWbzBUdr0oee9DdXxc_A4OSRCtEUDMTk9UB6x_yX_iJ8TdBlUOmbGyVMcxX74rqHRNP7w_zkOcA6vg8wFvd47Lvt-9ZIgfZeQxK0x-OZAQTcxWWWDnB1SHRxnec';

// Admin User can send FCM Notifications to all users
const bool isAdminUser = true;
const bool isTesting = true;

// Google admob ad IDs
const String appID = 'ca-app-pub-4316462914823878~1157582812';
const String bannerAdId = isTesting
    ? 'ca-app-pub-3940256099942544/6300978111'
    : 'ca-app-pub-4316462914823878/1913288955';
const String interstitialAdId = isTesting
    ? 'ca-app-pub-3940256099942544/1033173712'
    : 'ca-app-pub-4316462914823878/3040368483';

// Banner Ad Live ID: ca-app-pub-4316462914823878/1913288955
// Banner Ad Test ID: ca-app-pub-3940256099942544/6300978111

// Interstitial Ad Live ID: ca-app-pub-4316462914823878/3040368483
// Interstitial Ad Test ID: ca-app-pub-3940256099942544/1033173712

