import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/screens/azkar_app/azkar_items_screen.dart';
import 'package:muslim_dialy_guide/screens/azkar_app/azkar_main_page.dart';
import 'package:muslim_dialy_guide/screens/azkar_app/morning_night/home.dart';
import 'package:muslim_dialy_guide/screens/azkar_app/salah_azkar.dart';
import 'package:muslim_dialy_guide/screens/azkar_app/sleep_azkar.dart';
import 'package:muslim_dialy_guide/screens/daily_tasks/daily_tasks_screen.dart';
import 'package:muslim_dialy_guide/screens/home_app/home.dart';
import 'package:muslim_dialy_guide/screens/praying_time/praying_time.dart';
import 'package:muslim_dialy_guide/screens/qiblat/qibla.dart';
import 'package:muslim_dialy_guide/screens/quraan_arabic/quraan_arabic.dart';
import 'package:muslim_dialy_guide/screens/sbha/sbha.dart';
import 'package:muslim_dialy_guide/screens/splash_Screen.dart';
import 'package:muslim_dialy_guide/screens/splash_screens/arabic_quran_splash_screen.dart';

/*---------------------------------------------------------------------------------------------*/
/*-------------------------------------- App Routes  ------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
Map<String, Widget Function(BuildContext)> appRoutes = {
  /*------------------------------ Muslim Guide Home Page  ------------------------------------*/
  MuslimGuideHomePage.routeName: (context) => MuslimGuideHomePage(),
  /*---------------------------- Arabic Quran SplashScreen  ----------------------------------*/
  ArabicQuranSplashScreen.routeName: (context) => ArabicQuranSplashScreen(),
  /*---------------------------- Arabic Quran Screen  ----------------------------------*/
  QuranArabic.routeName: (context) => QuranArabic(),
  /*---------------------------- Praying Time Screen  ----------------------------------*/
  PrayingTime.routeName: (context) => PrayingTime(),
  /*---------------------------- Qibla Page Screen  ----------------------------------*/
  // QiblaPage.routeName: (context) => QiblaPage(),
  /*-------------------------- Azkar Elmoslem Screen  ----------------------------------*/
  AzkarElmoslemMainPage.routeName: (context) => AzkarElmoslemMainPage(),
  /*------------------------ Azkar Elsalah Screen  ----------------------------------*/
  AzkarElsalah.routeName: (context) => AzkarElsalah(),
  /*------------------------ Azkar Elnom Screen  ----------------------------------*/
  AzkarElnom.routeName: (context) => AzkarElnom(),
  /*------------------------ Morning/Night Screen  ----------------------------------*/
  // MorningNightHome.routeName :(context) => MorningNightHome(),
  /*------------------------ Sebha Screen  ----------------------------------*/
  SbhaScreen.routeName: (context) => SbhaScreen(),
  /*------------------------ Azkar Items  ----------------------------------*/
  AzkarItemsScreen.routeName: (context) => AzkarItemsScreen(),
  /*------------------------ Daily Tasks Items  ----------------------------------*/
  DailyTasksScreen.routeName: (context) => DailyTasksScreen(),
  /*------------------------ Daily Tasks Items  ----------------------------------*/
  SplashScreen.routeName: (context) => SplashScreen()
};
