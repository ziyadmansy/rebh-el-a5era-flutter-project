import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:muslim_dialy_guide/models/daily_task.dart';
import 'package:muslim_dialy_guide/models/zekr_cat.dart';
import 'package:muslim_dialy_guide/utils/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/zekr_item.dart';

class DailyTasksProvider with ChangeNotifier {
  List<DailyTask> dailyTasks = [];

  Future<void> getDailyTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
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
      if (response.statusCode == 200) {
        await prefs.setString(
            dailyTasksResponseKey, json.encode(decodedResponseBody));
        dailyTasks = decodedResponseBody
            .map((task) => DailyTask.fromJson(task))
            .toList();
      }

      notifyListeners();
    } catch (error) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dailyTasks = prefs.getString(dailyTasksResponseKey) == null
          ? []
          : (json.decode(prefs.getString(dailyTasksResponseKey)) as List)
              .map((task) => DailyTask.fromJson(task))
              .toList();
      notifyListeners();
      print('getDailyTasks catch error: ' + error.toString());
      print('getDailyTasks catch error: ' + dailyTasks.toString());
    }
  }
}
