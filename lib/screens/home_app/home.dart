import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_dialy_guide/providers/device_info_provider.dart';
import 'package:muslim_dialy_guide/providers/notifications.dart';
import 'package:muslim_dialy_guide/providers/prophit_words.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/shared.dart';
import '../../providers/azkar_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/app_bar.dart';
import '../azkar_app/azkar_items_screen.dart';
import 'delayed_animation.dart';

class MuslimGuideHomePage extends StatefulWidget {
  static const String routeName = 'homeApp';

  @override
  _MuslimGuideHomePageState createState() => _MuslimGuideHomePageState();
}

class _MuslimGuideHomePageState extends State<MuslimGuideHomePage> {
  bool isLoading = false;
  bool hasCrashed = false;

  final int delayedAmount = 500;
  BannerAd? myBanner;
  // InterstitialAd _interstitialAd;
  AdWidget? adWidget;

  final notificationFormKey = GlobalKey<FormState>();

  TextEditingController notificationTitle = TextEditingController();
  TextEditingController notificationBody = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAzkarData();
    Future.delayed(
      Duration.zero,
      () async {
        showRandomProphetWordsDialog();
        initAds();
      },
    );

    getDeviceInfo();
  }

  Future<void> getAzkarData() async {
    try {
      setState(() {
        isLoading = true;
        hasCrashed = false;
      });
      final azkarData = Provider.of<AzkarProvider>(context, listen: false);
      await azkarData.getAzkar();
      setState(() {
        isLoading = false;
        hasCrashed = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        hasCrashed = true;
      });
    }
  }

  Future<void> initAds() async {
    myBanner =
        await Shared.getBannerAd(MediaQuery.of(context).size.width.toInt());

    await myBanner?.load();
    adWidget = AdWidget(ad: myBanner!);
    setState(() {});

    // _interstitialAd = await Shared.getInterstitialAd();
    // _interstitialAd.show();
  }

  Future<void> getDeviceInfo() async {
    final deviceInfoData =
        Provider.of<DeviceInfoProvider>(context, listen: false);
    await deviceInfoData.getDeviceInfo();
  }

  Future<void> showRandomProphetWordsDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final hadithData = Provider.of<ProphitWords>(context, listen: false);
    final canShowHadith = prefs.getBool(prophitWordsDialogKey) ?? true;
    if (canShowHadith) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Center(
              child: Text(
                'حديث شريف',
              ),
            ),
            content: Text(
              hadithData.getRandomHadith(),
              textAlign: TextAlign.center,
            ),
            contentTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('إغلاق'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> setHadithDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('خدمة الأحاديث الشريفة'),
          children: [
            SimpleDialogOption(
              child: Text('تفعيل الخدمة'),
              onPressed: () async {
                await prefs.setBool(prophitWordsDialogKey, true);
                Shared.showToast('تم تفعيل الخدمة بنجاح');
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text('إلغاء الخدمة'),
              onPressed: () async {
                await prefs.setBool(prophitWordsDialogKey, false);
                Shared.showToast('تم إلغاء الخدمة بنجاح');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    myBanner?.dispose();
    // if (_interstitialAd != null) {
    //   _interstitialAd.dispose();
    // }
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    )) {
      Shared.showToast('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    final azkarData = Provider.of<AzkarProvider>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(
        title: 'الصفحة الرئيسية',
        context: context,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset(
                'assets/treasure.png',
                height: 150,
              ),
            ),
            Text(
              appName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Text(
                'خدمات',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: setHadithDialog,
              icon: Icon(Icons.message),
              label: Row(
                children: [
                  Text(
                    'رسائل الأحادث الشريفة',
                  ),
                ],
              ),
            ),
            // TextButton.icon(
            //   onPressed: () {},
            //   icon: Icon(Icons.battery_saver),
            //   label: Row(
            //     children: [
            //       Text(
            //         'وضع حفظ الطاقة',
            //       ),
            //     ],
            //   ),
            // ),
            if (isAdminUser)
              TextButton.icon(
                onPressed: () async {
                  final notificationsData =
                      Provider.of<Notifications>(context, listen: false);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('إرسال إشعار'),
                        content: Form(
                          key: notificationFormKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: notificationTitle,
                                  decoration: InputDecoration(
                                    hintText: 'عنوان الإشعار',
                                    labelText: 'عنوان الإشعار',
                                  ),
                                  validator: (text) {
                                    if (text?.isEmpty ?? true) {
                                      return 'برجاء إدخال عنوان';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  controller: notificationBody,
                                  decoration: InputDecoration(
                                    hintText: 'محتوى الإشعار',
                                    labelText: 'محتوى الإشعار',
                                  ),
                                  validator: (text) {
                                    if (text?.isEmpty ?? true) {
                                      return 'برجاء إدخال محتوى';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (notificationFormKey.currentState
                                      ?.validate() ??
                                  false) {
                                Shared.showToast('جارى التحميل');
                                await notificationsData.sendNotification(
                                  title: notificationTitle.text,
                                  body: notificationBody.text,
                                );
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('إرسال'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.notifications),
                label: Row(
                  children: [
                    Text(
                      'إرسال إشعار',
                    ),
                  ],
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Text(
                'أخرى',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                await _launchInBrowser(appPlayStoreUrl);
              },
              icon: Icon(Icons.star),
              label: Row(
                children: [
                  Text(
                    'ضع تقييمك',
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () {
                SystemNavigator.pop();
              },
              icon: Icon(Icons.exit_to_app),
              label: Row(
                children: [
                  Text(
                    'خروج',
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
                        Text(
                          appName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                          ),
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
                        GridView(
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
                              title: "القرآن الكريم",
                              onPress: () {
                                Navigator.pushNamed(
                                    context, ArabicQuranSplashScreen.routeName);
                              },
                            ),
                            /*-----------------------------------------------------------------------------------------------*/
                            /*-------------------------------- Praying time App Container  -----------------------------------*/
                            /*-----------------------------------------------------------------------------------------------*/
                            HomeContainer(
                              title: "مواقيت الصلاة",
                              onPress: () {
                                Navigator.of(context)
                                    .pushNamed(PrayingTime.routeName);
                              },
                            ),
                            /*-----------------------------------------------------------------------------------------------*/
                            /*-------------------------------- Sebha App Container  -----------------------------------*/
                            /*-----------------------------------------------------------------------------------------------*/
                            HomeContainer(
                              title: "السبحة",
                              onPress: () {
                                Navigator.pushNamed(
                                    context, SbhaScreen.routeName);
                              },
                            ),
                            /*-----------------------------------------------------------------------------------------------*/
                            /*-------------------------------- Daily Tasks Container  -----------------------------------*/
                            /*-----------------------------------------------------------------------------------------------*/
                            HomeContainer(
                              title: "المهام اليومية",
                              onPress: () {
                                Navigator.of(context)
                                    .pushNamed(DailyTasksScreen.routeName);
                              },
                            ),
                            /*-----------------------------------------------------------------------------------------------*/
                            /*--------------------------------  Azkar Elmoslem Container  -----------------------------------*/
                            /*-----------------------------------------------------------------------------------------------*/
                            // HomeContainer(
                            //   title: "الأذكار",
                            //   onPress: () {
                            //     Navigator.pushNamed(
                            //         context,
                            //         AzkarElmoslemMainPage
                            //             .routeName);
                            //   },
                            // ),
                            if (!isLoading && !hasCrashed)
                              ...azkarData.azkar
                                  .map<HomeContainer>((zekr) => HomeContainer(
                                        title: zekr.title,
                                        onPress: () {
                                          Navigator.of(context).pushNamed(
                                            AzkarItemsScreen.routeName,
                                            arguments: zekr,
                                          );
                                        },
                                      ))
                                  .toList(),

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
                        /*-----------------------------------------------------------------------------------------------*/
                        /*-------------------------------- Hint Circle  -----------------------------------*/
                        /*-----------------------------------------------------------------------------------------------*/
                        HintCircle(),
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
                  width: myBanner?.size.width.toDouble(),
                  height: myBanner?.size.height.toDouble(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
