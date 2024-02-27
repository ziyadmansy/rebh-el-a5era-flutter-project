import 'dart:async';
import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/globals/globals.dart' as globals;
import 'package:muslim_dialy_guide/screens/quraan_arabic/quraan_arabic.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ArabicQuranSplashScreen extends StatefulWidget {
  static const String routeName = 'quranArabicSplashScreen';

  @override
  createState() => _ArabicQuranSplashScreenState();
}

class _ArabicQuranSplashScreenState extends State<ArabicQuranSplashScreen> {
  /*-----------------------------------------------------------------------------------------------*/
  /*---------------------------- get bookmarkPage from sharedPreferences ------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  Future<void> getLastViewedPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(globals.LAST_VIEWED_PAGE)) {
      var _lastViewedPage = prefs.getInt(globals.LAST_VIEWED_PAGE);
      setState(() {
        globals.lastViewedPage = _lastViewedPage!;
      });
    }
  }

  /*-----------------------------------------------------------------------------------------------*/
  /*------------ Get saved Brightness or the default value if Brightness level is not defined  ----*/
  /*-----------------------------------------------------------------------------------------------*/
  Future<void> getBrightnessLevel() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(globals.BRIGHTNESS_LEVEL)) {
      var _brightnessLevel = prefs.getDouble(globals.BRIGHTNESS_LEVEL);
      setState(() {
        globals.brightnessLevel = _brightnessLevel;
      });
    } else {
      globals.brightnessLevel = globals.DEFAULT_BRIGHTNESS_LEVEL;
    }
  }

  /*-----------------------------------------------------------------------------------------------*/
  /*---------------------------- get bookmarkPage from sharedPreferences ------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  Future<void> getBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(globals.BOOKMARKED_PAGE)) {
      var bookmarkedPage = prefs.getInt(globals.BOOKMARKED_PAGE);
      setState(() {
        globals.bookmarkedPage = bookmarkedPage;
      });

      /// if not found return default value
    } else {
      globals.bookmarkedPage = globals.DEFAULT_BOOKMARKED_PAGE;
    }
  }

  @override
  void initState() {
    /*-----------------------------------------------------------------------------------------------*/
    /*----------------------- get Saved preferences from sharedPreferences ------------------------------*/
    /*-----------------------------------------------------------------------------------------------*/
    getSavedPreferences();
    super.initState();
  }

  Future<void> getSavedPreferences() async {
    await getBookmark();
    await getBrightnessLevel();
    await getLastViewedPage();
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        Navigator.pushReplacementNamed(context, QuranArabic.routeName);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              width: 144,
              height: 144,
              child: Image.asset("assets/treasure.png"),
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "بِسْم اللَّـهِ الرَّحْمَـٰنِ الرَّحِيمِ",
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                CircularProgressIndicator.adaptive(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
