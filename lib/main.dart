import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/app_routes.dart';
import 'package:muslim_dialy_guide/constants.dart';
import 'package:muslim_dialy_guide/provides/morning_night_provider.dart';
import 'package:muslim_dialy_guide/provides/theme_provider.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /*-----------------------------------------------------------------------------------------------*/
        /*---------------------------------------  Theme Provider  --------------------------------------*/
        /*-----------------------------------------------------------------------------------------------*/
        ChangeNotifierProvider<MorningOrNightProvider>(
          create: (context) => MorningOrNightProvider(),
        ),
        /*-----------------------------------------------------------------------------------------------*/
        /*---------------------------------------  Theme Provider  --------------------------------------*/
        /*-----------------------------------------------------------------------------------------------*/
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
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
