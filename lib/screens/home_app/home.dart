import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_dialy_guide/providers/device_info_provider.dart';
import 'package:muslim_dialy_guide/screens/azkar_app/azkar_main_page.dart';
import 'package:muslim_dialy_guide/screens/daily_tasks/daily_tasks_screen.dart';
import 'package:muslim_dialy_guide/screens/home_app/hint_circle.dart';
import 'package:muslim_dialy_guide/screens/praying_time/praying_time.dart';
import 'package:muslim_dialy_guide/screens/qiblat/qibla.dart';
import 'package:muslim_dialy_guide/screens/sbha/sbha.dart';
import 'package:muslim_dialy_guide/screens/splash_screens/arabic_quran_splash_screen.dart';
import 'package:muslim_dialy_guide/widgets/custom_background.dart';
import 'package:muslim_dialy_guide/widgets/home_container.dart';
import 'package:muslim_dialy_guide/constants.dart';
import 'package:provider/provider.dart';

import '../../common/shared.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/app_bar.dart';
import 'delayed_animation.dart';

class MuslimGuideHomePage extends StatefulWidget {
  static const String routeName = 'homeApp';

  @override
  _MuslimGuideHomePageState createState() => _MuslimGuideHomePageState();
}

class _MuslimGuideHomePageState extends State<MuslimGuideHomePage> {
  final int delayedAmount = 500;
  BannerAd myBanner;
  InterstitialAd _interstitialAd;
  AdWidget adWidget;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
        initAds();
      },
    );

    getDeviceInfo();
  }

  Future<void> initAds() async {
    myBanner =
        await Shared.getBannerAd(MediaQuery.of(context).size.width.toInt());

    await myBanner.load();
    adWidget = AdWidget(ad: myBanner);
    setState(() {});

    await InterstitialAd.load(
      adUnitId: interstitialAdId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          this._interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
    // _interstitialAd.show();
  }

  Future<void> getDeviceInfo() async {
    final deviceInfoData =
        Provider.of<DeviceInfoProvider>(context, listen: false);
    await deviceInfoData.getDeviceInfo();
  }

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose();
    if (_interstitialAd != null) {
      if (_interstitialAd != null) {
        _interstitialAd.dispose();
      }
    }
  }

  // Scaffold background gradient
//     android:endColor="#030357"
//     android:centerColor="#1CB5E0"
//     android:startColor="#C2ECF3"

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: GlobalAppBar(
        title: 'الصفحة الرئيسية',
      ),
      // backgroundColor: Colors.transparent,
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            SizedBox(
              height: 16,
            ),
            Image.asset(
              'assets/quran_ar.png',
              height: 150,
            ),
            Divider(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'إرسال إشعار',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: theme.isDarkTheme
              ? null
              : LinearGradient(
                  colors: gradColors,
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
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
                        // SizedBox(
                        //   height: 15.0,
                        // ),
                        // DelayedAnimation(
                        //   child: Text(
                        //     "دليلك لدخول الجنة",
                        //     style: TextStyle(
                        //       fontSize: 20.0,
                        //     ),
                        //   ),
                        //   delay: delayedAmount + 1000,
                        // ),
                        SizedBox(
                          height: 15.0,
                        ),
                        DelayedAnimation(
                          delay: delayedAmount + 1500,
                          child: GridView(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            children: [
                              /*-----------------------------------------------------------------------------------------------*/
                              /*--------------------------------  Arabic Quraan Container  -----------------------------------*/
                              /*-----------------------------------------------------------------------------------------------*/
                              HomeContainer(
                                color: primaryColor,
                                title: "القرآن الكريم",
                                onPress: () {
                                  Navigator.pushNamed(context,
                                      ArabicQuranSplashScreen.routeName);
                                },
                              ),
                              /*-----------------------------------------------------------------------------------------------*/
                              /*--------------------------------  Azkar Elmoslem Container  -----------------------------------*/
                              /*-----------------------------------------------------------------------------------------------*/
                              HomeContainer(
                                color: primaryColor,
                                title: "الأذكار",
                                onPress: () {
                                  Navigator.pushNamed(
                                      context, AzkarElmoslemMainPage.routeName);
                                },
                              ),
                              /*-----------------------------------------------------------------------------------------------*/
                              /*-------------------------------- Sebha App Container  -----------------------------------*/
                              /*-----------------------------------------------------------------------------------------------*/
                              HomeContainer(
                                color: primaryColor,
                                title: "السبحة",
                                onPress: () {
                                  Navigator.pushNamed(
                                      context, SbhaScreen.routeName);
                                },
                              ),
                              /*-----------------------------------------------------------------------------------------------*/
                              /*-------------------------------- Praying time App Container  -----------------------------------*/
                              /*-----------------------------------------------------------------------------------------------*/
                              HomeContainer(
                                color: primaryColor,
                                title: "مواقيت الصلاة",
                                onPress: () {
                                  Navigator.of(context)
                                      .pushNamed(PrayingTime.routeName);
                                },
                              ),
                              /*-----------------------------------------------------------------------------------------------*/
                              /*-------------------------------- Daily Tasks Container  -----------------------------------*/
                              /*-----------------------------------------------------------------------------------------------*/
                              HomeContainer(
                                color: primaryColor,
                                title: "المهام اليومية",
                                onPress: () {
                                  Navigator.of(context)
                                      .pushNamed(DailyTasksScreen.routeName);
                                },
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
                        DelayedAnimation(
                          delay: delayedAmount + 2000,
                          child: HintCircle(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (adWidget != null)
                Container(
                  alignment: Alignment.center,
                  child: adWidget,
                  width: myBanner.size.width.toDouble(),
                  height: myBanner.size.height.toDouble(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
