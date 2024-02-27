import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:muslim_dialy_guide/constants.dart';
import 'package:muslim_dialy_guide/models/zekr_cat.dart';
import 'package:muslim_dialy_guide/utils/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AzkarProvider with ChangeNotifier {
  List<ZekrCategory> azkar = [];

  Future<void> getAzkar() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String url = ApiRoutes.azkar;
      print(url);
      Response response = await get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json; charset=UTF-8',
          'Authorization': apiKey,
        },
      );

      final List<dynamic> decodedResponseBody =
          json.decode(utf8.decode(response.bodyBytes));
      print(response.statusCode);
      print(decodedResponseBody);
      if (response.statusCode == 200) {
        await prefs.setString(
            azkarResponseKey, json.encode(decodedResponseBody));
        azkar = decodedResponseBody
            .map((zekr) => ZekrCategory.fromJson(zekr))
            .toList();
      }

      notifyListeners();
    } catch (error) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      azkar = prefs.getString(azkarResponseKey) == null
          ? []
          : (json.decode(prefs.getString(azkarResponseKey)!) as List)
              .map((zekr) => ZekrCategory.fromJson(zekr))
              .toList();
      notifyListeners();
      print('getAzkar catch error: ' + azkar.toString());
      print('getAzkar catch error: ' + error.toString());
    }
  }
}
