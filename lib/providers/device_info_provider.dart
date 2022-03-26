import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:muslim_dialy_guide/constants.dart';
import 'package:muslim_dialy_guide/utils/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceInfoProvider with ChangeNotifier {
  Future<void> getDeviceInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String savedFcmToken = prefs.getString(fcmKey);
      String fcmToken = await getFCMToken();
      if (savedFcmToken != null) {
        // User has FCM Token Registered
        if (savedFcmToken != fcmToken) {
          // The registered FCM Token has changed
          savedFcmToken = fcmToken;
        } else {
          // The registered FCM Token hasn't changed
          // No need to send the request to admin panel
          return;
        }
      } else {
        // First time user login
        // savedFcmToken = null
        savedFcmToken = fcmToken;
      }
      final deviceInfoPlugin = DeviceInfoPlugin();
      String platformType = androidText;
      String uid;
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfoPlugin.androidInfo;
        var release = androidInfo.version.release;
        var sdkInt = androidInfo.version.sdkInt;
        var manufacturer = androidInfo.manufacturer;
        var model = androidInfo.model;
        uid = androidInfo.androidId;
        print('Android $release (SDK $sdkInt), $manufacturer $model');
        // Android 9 (SDK 28), Xiaomi Redmi Note 7
        platformType = androidText;
      }

      // if (Platform.isIOS) {
      //   var iosInfo = await DeviceInfoPlugin().iosInfo;
      //   var systemName = iosInfo.systemName;
      //   var version = iosInfo.systemVersion;
      //   var name = iosInfo.name;
      //   var model = iosInfo.model;
      //   print('$systemName $version, $name $model');
      //   // iOS 13.1, iPhone 11 Pro Max iPhone
      //   platformType = iosText;
      // }

      await deviceInfoService(
        deviceIdentifier: uid,
        deviceType: platformType,
        fcmToken: savedFcmToken,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<String> getFCMToken() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final token = await messaging.getToken();
      await subscribeToTopic(publicTopic);
      print(token);
      return token;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> subscribeToTopic(String topicTitle) async {
    final messaging = FirebaseMessaging.instance;
    await messaging.subscribeToTopic(topicTitle);
  }

  Future<void> deviceInfoService({
    @required String deviceIdentifier,
    @required String deviceType,
    @required String fcmToken,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(ApiRoutes.deviceInfo);
      Response response = await post(
        Uri.parse(ApiRoutes.deviceInfo),
        body: {
          'registration_id': fcmToken,
          'device_id': deviceIdentifier,
          'type': deviceType
        },
        headers: {
          'Authorization': apiKey,
        },
      );
      final decodedResponseBody = json.decode(response.body);

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 201) {
        await prefs.setString(fcmKey, fcmToken);
      }
    } catch (e) {
      print(e);
    }
  }
}
