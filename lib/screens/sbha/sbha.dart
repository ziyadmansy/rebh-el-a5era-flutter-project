import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_dialy_guide/providers/sbha_provider.dart';
import 'package:muslim_dialy_guide/widgets/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/shared.dart';
import '../../constants.dart';
import '../../providers/theme_provider.dart';

class SbhaScreen extends StatefulWidget {
  static const String routeName = 'sbhaScreen';

  @override
  _SbhaScreenState createState() => _SbhaScreenState();
}

class _SbhaScreenState extends State<SbhaScreen> {
  BannerAd myBanner;
  InterstitialAd _interstitialAd;
  AdWidget adWidget;

  bool isClick = true;
  _dismissDialog() {
    Navigator.pop(context);
  }

  void _showResetConfirmationDialog() {
    final sbhaData = Provider.of<SbhaProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'تصفير العدد',
            ),
            content: Text(
              'هل أنت متأكد من تصفير العدد؟',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _dismissDialog();
                },
                child: Text('لا'),
              ),
              TextButton(
                onPressed: () {
                  sbhaData.resetAllSebhaCounts();
                  _dismissDialog();
                },
                child: Text('نعم'),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    final sbhaProvider = Provider.of<SbhaProvider>(context, listen: false);
    sbhaProvider.getCounter();
    Future.delayed(
      Duration.zero,
      () async {
        initAds();
      },
    );
  }

  /*-----------------------------------------------------------------------------------------------*/
  /*---------------------------- get counter from shared preferences ------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/

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
    myBanner.dispose();
    if (_interstitialAd != null) {
      _interstitialAd.dispose();
    }
  }

  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    var sbhbaData = Provider.of<SbhaProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return await Shared.onPopEventHandler(_interstitialAd);
      },
      child: Scaffold(
        appBar: GlobalAppBar(title: "السبحة"),
        body: Theme(
          data: theme.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
          child: Container(
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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: sbhbaData.sbhaItems.length + 1,
                      itemBuilder: (context, i) {
                        if (i == sbhbaData.sbhaItems.length) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    'المجموع الكلى',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          sbhbaData.totalCount.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _showResetConfirmationDialog();
                                        },
                                        icon: Icon(
                                          Icons.restore,
                                          size: 35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        final sbhaItem = sbhbaData.sbhaItems[i];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '${sbhaItem.count}',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: gradColors,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              kBorderRadius),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            sbhbaData.incSebhaCount(i);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              sbhaItem.title,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            onSurface: Colors.transparent,
                                            padding: const EdgeInsets.all(0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                kBorderRadius,
                                              ),
                                            ),
                                            elevation: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        sbhbaData.resetSebhaCount(i);
                                      },
                                      icon: Icon(
                                        Icons.restore,
                                        size: 35,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
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
        ),
      ),
    );
  }
}
