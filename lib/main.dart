import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/app_routes.dart';
import 'package:muslim_dialy_guide/constants.dart';
import 'package:muslim_dialy_guide/providers/azkar_provider.dart';
import 'package:muslim_dialy_guide/providers/daily_tasks_provider.dart';
import 'package:muslim_dialy_guide/providers/device_info_provider.dart';
import 'package:muslim_dialy_guide/providers/locationProvider.dart';
import 'package:muslim_dialy_guide/providers/morning_night_provider.dart';
import 'package:muslim_dialy_guide/providers/theme_provider.dart';
import 'package:muslim_dialy_guide/screens/home_app/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  initFCM();
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.data}");
}

void initFCM() async {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: false,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  // String deviceToken = await FirebaseMessaging.instance.getToken();
  // if (deviceToken != null) {
  //   FixedAssets.FCMToken = deviceToken;
  //   print(deviceToken + " FCM token");
  // }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /*-----------------------------------------------------------------------------------------------*/
        /*---------------------------------------  Theme Provider  --------------------------------------*/
        /*-----------------------------------------------------------------------------------------------*/
        // ChangeNotifierProvider<MorningOrNightProvider>(
        //   create: (context) => MorningOrNightProvider(),
        // ),
        /*-----------------------------------------------------------------------------------------------*/
        /*---------------------------------------  Theme Provider  --------------------------------------*/
        /*-----------------------------------------------------------------------------------------------*/
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        /*-----------------------------------------------------------------------------------------------*/
        /*---------------------------------------  Location Provider  --------------------------------------*/
        /*-----------------------------------------------------------------------------------------------*/
        ChangeNotifierProvider<LocationProvider>(
          create: (context) => LocationProvider(),
        ),
        /*-----------------------------------------------------------------------------------------------*/
        /*---------------------------------------  Azkar Provider  --------------------------------------*/
        /*-----------------------------------------------------------------------------------------------*/
        ChangeNotifierProvider<AzkarProvider>(
          create: (context) => AzkarProvider(),
        ),
        /*-----------------------------------------------------------------------------------------------*/
        /*---------------------------------------  Daily Tasks Provider  --------------------------------------*/
        /*-----------------------------------------------------------------------------------------------*/
        ChangeNotifierProvider<DailyTasksProvider>(
          create: (context) => DailyTasksProvider(),
        ),
        /*-----------------------------------------------------------------------------------------------*/
        /*---------------------------------------  Device Info Provider  --------------------------------------*/
        /*-----------------------------------------------------------------------------------------------*/
        ChangeNotifierProvider<DeviceInfoProvider>(
          create: (context) => DeviceInfoProvider(),
        ),
      ],
      builder: (context, child) {
        /*---------------------------   theme provider  ----------------------------*/
        return Consumer<ThemeProvider>(
          builder: (context, value, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: const Locale('ar'),
              supportedLocales: [
                Locale('ar'),
                Locale('en'),
              ],
              title: appName,
              theme: ThemeData(
                colorSchemeSeed: primaryColor,
                brightness: Brightness.light,
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorSchemeSeed: primaryColor,
                brightness: Brightness.dark,
                useMaterial3: true,
              ),
              themeMode: (value.theme) ? ThemeMode.dark : ThemeMode.light,
              initialRoute: MuslimGuideHomePage.routeName,
              routes: appRoutes,
            );
          },
        );
      },
    );
  }
}
