import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/screens/azkar_app/azkar_main_page.dart';
import 'package:muslim_dialy_guide/screens/comming%20soon/coming_home_spinner.dart';
import 'package:muslim_dialy_guide/screens/home_app/hint_circle.dart';
import 'package:muslim_dialy_guide/screens/praying_time/praying_time.dart';
import 'package:muslim_dialy_guide/screens/qiblat/qibla.dart';
import 'package:muslim_dialy_guide/screens/sbha/sbha.dart';
import 'package:muslim_dialy_guide/screens/splash_screens/arabic_quran_splash_screen.dart';
import 'package:muslim_dialy_guide/widgets/custom_background.dart';
import 'package:muslim_dialy_guide/widgets/home_container.dart';
import 'package:muslim_dialy_guide/constants.dart';
import 'package:provider/provider.dart';

import '../../provides/theme_provider.dart';
import '../../widgets/app_bar.dart';
import 'delayed_animation.dart';

class MuslimGuideHomePage extends StatefulWidget {
  static const String routeName = 'homeApp';

  @override
  _MuslimGuideHomePageState createState() => _MuslimGuideHomePageState();
}

class _MuslimGuideHomePageState extends State<MuslimGuideHomePage> {
  final int delayedAmount = 500;

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: GlobalAppBar(
        title: 'الصفحة الرئيسية',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                DelayedAnimation(
                  child: Text(
                    appName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                    ),
                  ),
                  delay: delayedAmount + 500,
                ),
                SizedBox(
                  height: 15.0,
                ),
                DelayedAnimation(
                  child: Text(
                    "دليلك لدخول الجنة",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  delay: delayedAmount + 1000,
                ),
                SizedBox(
                  height: 15.0,
                ),
                DelayedAnimation(
                  delay: delayedAmount + 1500,
                  child: GridView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    children: [
                      /*-----------------------------------------------------------------------------------------------*/
                      /*--------------------------------  Arabic Quraan Container  -----------------------------------*/
                      /*-----------------------------------------------------------------------------------------------*/
                      GestureDetector(
                        child: HomeContainer(
                          image: "assets/quran.png",
                          color: primaryColor,
                          title: "القرآن الكريم",
                        ),
                        onTap: () => Navigator.pushNamed(
                            context, ArabicQuranSplashScreen.routeName),
                      ),
                      /*-----------------------------------------------------------------------------------------------*/
                      /*--------------------------------  Translated Quraan Container  -----------------------------------*/
                      /*-----------------------------------------------------------------------------------------------*/
                      // GestureDetector(
                      //   child: HomeContainer(
                      //       image: "assets/quran_ar.png",
                      //       color: color2,
                      //       title: "Translated Quraan",),
                      //   onTap: () => Navigator.pushNamed(
                      //       context, ComingSoonSpinner.routeName),
                      // ),
                      /*-----------------------------------------------------------------------------------------------*/
                      /*--------------------------------  Azkar Elmoslem Container  -----------------------------------*/
                      /*-----------------------------------------------------------------------------------------------*/
                      GestureDetector(
                        child: HomeContainer(
                          image: "assets/tasbeh.png",
                          color: primaryColor,
                          title: "الأذكار",
                        ),
                        onTap: () => Navigator.pushNamed(
                            context, AzkarElmoslemMainPage.routeName),
                      ),
                      /*-----------------------------------------------------------------------------------------------*/
                      /*-------------------------------- Sebha App Container  -----------------------------------*/
                      /*-----------------------------------------------------------------------------------------------*/
                      GestureDetector(
                        child: HomeContainer(
                          image: "assets/azkar.png",
                          color: primaryColor,
                          title: "السبحة",
                        ),
                        onTap: () =>
                            Navigator.pushNamed(context, SbhaScreen.routeName),
                      ),
                      /*-----------------------------------------------------------------------------------------------*/
                      /*-------------------------------- Praying time App Container  -----------------------------------*/
                      /*-----------------------------------------------------------------------------------------------*/
                      GestureDetector(
                        child: HomeContainer(
                          image: "assets/praying.png",
                          color: primaryColor,
                          title: "مواقيت الصلاة",
                        ),
                        onTap: () =>
                            Navigator.pushNamed(context, PrayingTime.routeName),
                      ),
                      /*-----------------------------------------------------------------------------------------------*/
                      /*-------------------------------- ElQibla App Container  -----------------------------------*/
                      /*-----------------------------------------------------------------------------------------------*/
                      // GestureDetector(
                      //   child: HomeContainer(
                      //       image: "assets/mecca.png",
                      //       color: color2,
                      //       title: "El-Qibla"),
                      //   onTap: () =>
                      //       Navigator.pushNamed(context, QiblaPage.routeName),
                      // ),
                    ],
                  ),
                ),
                /*-----------------------------------------------------------------------------------------------*/
                /*-------------------------------- Hint Circle  -----------------------------------*/
                /*-----------------------------------------------------------------------------------------------*/
                // DelayedAnimation(
                //   delay: delayedAmount + 5000,
                //   child: HintCircle(),
                // ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
