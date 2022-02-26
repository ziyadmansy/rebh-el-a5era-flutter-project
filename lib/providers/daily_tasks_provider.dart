import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:muslim_dialy_guide/models/daily_task.dart';
import 'package:muslim_dialy_guide/models/zekr_cat.dart';
import 'package:muslim_dialy_guide/utils/api_routes.dart';

import '../constants.dart';
import '../models/zekr_item.dart';

class DailyTasksProvider with ChangeNotifier {
  List<DailyTask> dailyTasks = [];

  Future<void> getDailyTasks() async {
    try {
      final String url = ApiRoutes.dailyTasks;
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
      if (response.statusCode >= 400) {
        throw Exception('Status Code >= 400 getDailyTasks');
      }

      dailyTasks = decodedResponseBody
          .map((task) => DailyTask.fromJson(task))
          .toList();
      notifyListeners();
    } catch (error) {
      print('getDailyTasks catch error: ' + error.toString());
      throw (error.toString());
    }
  }
}
