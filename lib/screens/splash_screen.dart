import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/constants.dart';

import 'home_app/home.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splashScreen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 1),
      () {
        Navigator.of(context).pushReplacementNamed(MuslimGuideHomePage.routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Image.asset(
              'assets/treasure.png',
              height: width / 2,
              width: width / 2,
            ),
            Spacer(),
            Text(
              appName,
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
