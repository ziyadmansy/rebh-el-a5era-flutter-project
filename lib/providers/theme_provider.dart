import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkTheme = true;

  bool get theme => isDarkTheme;

/*---------------------------------------------------------------------------------------------*/
/*-------------------------------------- getting theme  --------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  _loadPrefs() async {
    final preferences = await SharedPreferences.getInstance();
    isDarkTheme = preferences.getBool('theme') ?? false;
    notifyListeners();
  }

  ThemeProvider() {
    _loadPrefs();
  }

/*---------------------------------------------------------------------------------------------*/
/*-------------------------------------- Switching theme  --------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  switchTheme() {
    isDarkTheme = !isDarkTheme;
    _savePrefs();
    notifyListeners();
  }

/*---------------------------------------------------------------------------------------------*/
/*--------------------------------- save theme after switching  ---------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  _savePrefs() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool('theme', isDarkTheme);
  }
}
