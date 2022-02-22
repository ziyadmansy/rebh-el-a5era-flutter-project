import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:muslim_dialy_guide/models/zekr_cat.dart';
import 'package:muslim_dialy_guide/utils/api_routes.dart';

class AzkarProvider with ChangeNotifier {
  List<ZekrCategory> azkar = [];

  Future<void> getAzkar() async {
    try {
      final String url = ApiRoutes.azkar;
      print(url);
      Response response = await get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json; charset=UTF-8',
        },
      );

      final List<dynamic> decodedResponseBody =
          json.decode(utf8.decode(response.bodyBytes));
      print(response.statusCode);
      print(decodedResponseBody);
      if (response.statusCode >= 400) {
        throw Exception('Status Code >= 400 getAzkar');
      }

      azkar = decodedResponseBody
          .map((zekr) => ZekrCategory.fromJson(zekr))
          .toList();
      notifyListeners();
    } catch (error) {
      print('getAzkar catch error: ' + error.toString());
      throw (error.toString());
    }
  }
}
