import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_dialy_guide/providers/azkar_provider.dart';
import 'package:muslim_dialy_guide/screens/azkar_app/azkar_items_screen.dart';
import 'package:muslim_dialy_guide/screens/azkar_app/salah_azkar.dart';
import 'package:muslim_dialy_guide/screens/azkar_app/sleep_azkar.dart';
import 'package:muslim_dialy_guide/screens/sbha/sbha.dart';
import 'package:muslim_dialy_guide/widgets/animated_text_header.dart';
import 'package:muslim_dialy_guide/widgets/app_bar.dart';
import 'package:muslim_dialy_guide/widgets/azkar/sbha.dart';
import 'package:muslim_dialy_guide/widgets/or_widget.dart';
import 'package:provider/provider.dart';

import '../../common/shared.dart';
import '../../constants.dart';
import '../../providers/theme_provider.dart';
import 'morning_night/home.dart';

class AzkarElmoslemMainPage extends StatefulWidget {
  static const String routeName = 'Azkarpage';

  const AzkarElmoslemMainPage({Key key}) : super(key: key);

  @override
  _AzkarElmoslemMainPageState createState() => _AzkarElmoslemMainPageState();
}

class _AzkarElmoslemMainPageState extends State<AzkarElmoslemMainPage> {
  BannerAd myBanner;
  InterstitialAd _interstitialAd;
  AdWidget adWidget;

  bool isLoading = false;
  bool hasCrashed = false;

  @override
  void initState() {
    super.initState();
    getAzkarData();
    Future.delayed(
      Duration.zero,
      () async {
        initAds();
      },
    );
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

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose();
    if (_interstitialAd != null) {
      _interstitialAd.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    final azkarData = Provider.of<AzkarProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        return await Shared.onPopEventHandler(_interstitialAd);
      },
      child: Scaffold(
        appBar: GlobalAppBar(
          title: "أذكار المسلم",
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
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : hasCrashed
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_outlined,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            errorMsg,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextButton(
                            onPressed: getAzkarData,
                            child: Text(
                              'إعادة المحاولة',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : azkarData.azkar.isEmpty
                      ? Center(
                          child: Text('لا يوجد أذكار متاحة'),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                itemCount: azkarData.azkar.length,
                                itemBuilder: (context, i) {
                                  final zekr = azkarData.azkar[i];
                                  return ListTile(
                                    title: Text(zekr.title),
                                    subtitle: Text(zekr.description),
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        AzkarItemsScreen.routeName,
                                        arguments: zekr,
                                      );
                                    },
                                  );
                                },
                                separatorBuilder: (context, i) {
                                  return Divider();
                                },
                              ),
                            ),
                            if (adWidget != null)
                              Container(
                                alignment: Alignment.center,
                                child: adWidget,
                                width: myBanner.size.width.toDouble(),
                                height: myBanner.size.height.toDouble(),
                              ),
                          ],
                        ),
        ),
      ),
    );
  }
}
