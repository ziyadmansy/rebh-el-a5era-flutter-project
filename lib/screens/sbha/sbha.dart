import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

  int _counter = 0;
  bool isClick = true;
  _dismissDialog() {
    Navigator.pop(context);
  }

  void _showMaterialDialog() {
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
                  _dismissDialog();
                  removeCounter();
                  setState(() {
                    _counter = 0;
                  });
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
    getCounter();
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
  getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt("counter") ?? 0);
    });
  }

  /*-----------------------------------------------------------------------------------------------*/
  /*---------------------------- Set counter to shared preferences ------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  Future<void> setCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("counter", _counter);
  }

  /*-----------------------------------------------------------------------------------------------*/
  /*---------------------------- delete counter from shared preferences ------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  removeCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("counter");
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

  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return await Shared.onPopEventHandler(_interstitialAd);
      },
      child: Scaffold(
        appBar: GlobalAppBar(title: "السبحة"),
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
          child: InkWell(
            onTap: () {
              setState(() {
                _counter++;
              });
              setCounter();
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/azkar/sbha.png',
                            ),
                          ),
                        ),
                        child: Center(
                            child: Text(
                          '$_counter',
                          style: TextStyle(fontSize: 40.0),
                        )),
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            child: Text('تصفير العدد'),
                            style: ElevatedButton.styleFrom(
                              primary: redColor,
                            ),
                            onPressed: () {
                              _showMaterialDialog();
                            },
                          ),
                        ),
                      ),
                    ],
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
