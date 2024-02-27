import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_dialy_guide/models/surah.dart';
import 'package:muslim_dialy_guide/screens/quraan_arabic/surah_list_builder.dart';
import 'package:muslim_dialy_guide/globals/globals.dart' as globals;
import 'package:muslim_dialy_guide/screens/quraan_arabic/surah_view_builder.dart';
import 'package:muslim_dialy_guide/widgets/app_bar.dart';
import 'package:muslim_dialy_guide/widgets/arabic_quraan/custom_bottom_navigation_bar.dart';
import 'package:muslim_dialy_guide/widgets/arabic_quraan/nav_bar.dart';
import 'package:muslim_dialy_guide/widgets/arabic_quraan/slider_alert.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/shared.dart';
import '../../constants.dart';
import '../../providers/theme_provider.dart';

class QuranArabic extends StatefulWidget {
  static const String routeName = 'quranArabicApp';

  @override
  _QuranArabicState createState() => _QuranArabicState();
}

class _QuranArabicState extends State<QuranArabic> {
  BannerAd? myBanner;
  InterstitialAd? _interstitialAd;
  AdWidget? adWidget;

  /*-----------------------------------------------------------------------------------------------*/
  /*------------------------------ List of sur parse from json  -----------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  List<Surah> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Surah>((json) => new Surah.fromJson(json)).toList();
  }

  /*-----------------------------------------------------------------------------------------------*/
  /*-------------------------------- Getting Screen Brightness  -----------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  // void getScreenBrightness() async {
  //   globals.brightnessLevel = await Screen.brightness;
  // }

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        initAds();
      },
    );
    // getScreenBrightness();
    if (globals.bookmarkedPage == null) {
      globals.bookmarkedPage = globals.DEFAULT_BOOKMARKED_PAGE;
    }
    /*-----------------------------------------------------------------------------------------------*/
    /*---------------------- Prevent screen from going into sleep mode ------------------------------*/
    /*-----------------------------------------------------------------------------------------------*/
    // Screen.keepOn(true);

    /*-----------------------------------------------------------------------------------------------*/
    /*----------------------    set saved Brightness level  ------------------------------*/
    /*-----------------------------------------------------------------------------------------------*/
    // Screen.setBrightness(globals.brightnessLevel);
    // Screen.keepOn(true);

    super.initState();
  }

  Future<void> initAds() async {
    myBanner =
        await Shared.getBannerAd(MediaQuery.of(context).size.width.toInt());
    await myBanner?.load();
    adWidget = AdWidget(ad: myBanner!);
    setState(() {});

    await InterstitialAd.load(
      adUnitId: interstitialAdId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          this._interstitialAd = ad;
          print('Interstitial Ad Loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
    // _interstitialAd.show();
  }

  @override
  void dispose() {
    super.dispose();
    myBanner?.dispose();
    if (_interstitialAd != null) {
      _interstitialAd?.dispose();
    }
  }

  /*-----------------------------------------------------------------------------------------------*/
  /*-------------------------------- Setting Screen Brightness  -----------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  _setBrightness() {
    if (globals.brightnessLevel == null) {
      // getScreenBrightness();
    }
    showDialog(context: this.context, builder: (context) => SliderAlert());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return await Shared.onPopEventHandler(
          _interstitialAd,
          canShowAd: false,
        );
      },
      child: Scaffold(
        appBar: buildAppBar(
          title: 'القرآن الكريم',
          context: context,
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
          child: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/json/surah.json'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Surah> surahList = parseJson(snapshot.data.toString());
                return surahList.isNotEmpty
                    ? SurahListBuilder(surah: surahList)
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        /*-----------------------------------------------------------------------------------------------*/
        /*-------------------------------- btn nav bar  -----------------------------------*/
        /*-----------------------------------------------------------------------------------------------*/
        // bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}
