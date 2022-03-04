import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_dialy_guide/widgets/app_bar.dart';
import 'package:provider/provider.dart';

import '../../common/shared.dart';
import '../../constants.dart';
import '../../models/zekr_cat.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/azkar/azkar_box.dart';

class AzkarItemsScreen extends StatefulWidget {
  static const String routeName = '/azkarItems';
  const AzkarItemsScreen({Key key}) : super(key: key);

  @override
  _AzkarItemsScreenState createState() => _AzkarItemsScreenState();
}

class _AzkarItemsScreenState extends State<AzkarItemsScreen> {
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
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    ZekrCategory zekr = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: theme.isDarkTheme ? null : Colors.white,
      appBar: GlobalAppBar(
        title: zekr.title,
      ),
      body: Theme(
        data: theme.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
        child: zekr.ad3ya.isEmpty
            ? Center(
                child: Text('لا يوجد أذكار متاحة'),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: zekr.ad3ya.length,
                      itemBuilder: (context, i) {
                        final doaa = zekr.ad3ya[i];
                        return AzkarPostDescription(
                          title: doaa.title,
                          description: doaa.description,
                          number: doaa.count,
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
    );
  }
}
