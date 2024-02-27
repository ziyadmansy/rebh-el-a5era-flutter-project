import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:muslim_dialy_guide/common/shared.dart';
import 'package:muslim_dialy_guide/constants.dart';
import 'package:muslim_dialy_guide/utils/api_routes.dart';

class Notifications with ChangeNotifier {
  // List<String> devicesTokens = [];

  // Future<void> getFcmTokens() async {
  //   try {
  //     Response response = await get(
  //       Uri.parse(ApiRoutes.deviceInfo),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'accept': 'application/json',
  //         'Authorization': apiKey,
  //       },
  //     );

  //     final List<dynamic> decodedResponseBody = json.decode(response.body);

  //     print(response.statusCode);
  //     print(decodedResponseBody);

  //     devicesTokens = decodedResponseBody
  //         .map<String>((device) => device['registration_id'])
  //         .toList();
  //     print(devicesTokens);
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //     Shared.showToast('حدث خطأ برجاء المحاولة مرة أخرى');
  //   }
  // }

  Future<void> sendNotification({
    required String title,
    required String body,
  }) async {
    try {
      print(title);
      print(body);
      Response response = await post(
        Uri.parse(ApiRoutes.fcmSendNotifications),
        body: json.encode({
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'sound': 'true',
          },
          'priority': 'high',
          'to': '/topics/$publicTopic',
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': firebaseServerKey,
        },
      );

      print(response.statusCode);
      print(response.body);
      Shared.showToast('تم إرسال الإشعار بنجاح');
    } catch (e) {
      print(e);
      Shared.showToast('حدث خطأ برجاء المحاولة مرة أخرى');
    }
  }
}
