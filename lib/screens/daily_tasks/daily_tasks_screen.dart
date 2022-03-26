import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_dialy_guide/providers/daily_tasks_provider.dart';
import 'package:muslim_dialy_guide/widgets/app_bar.dart';
import 'package:provider/provider.dart';

import '../../common/shared.dart';
import '../../constants.dart';
import '../../providers/theme_provider.dart';

class DailyTasksScreen extends StatefulWidget {
  static const String routeName = '/dailyTasks';
  const DailyTasksScreen({Key key}) : super(key: key);

  @override
  _DailyTasksScreenState createState() => _DailyTasksScreenState();
}

class _DailyTasksScreenState extends State<DailyTasksScreen> {
  bool isLoading = false;
  bool hasCrashed = false;

  BannerAd myBanner;
  InterstitialAd _interstitialAd;
  AdWidget adWidget;

  @override
  void initState() {
    super.initState();
    getTasks();
    Future.delayed(
      Duration.zero,
      () async {
        initAds();
      },
    );
  }

  Future<void> getTasks() async {
    try {
      setState(() {
        isLoading = true;
        hasCrashed = false;
      });
      final tasksData = Provider.of<DailyTasksProvider>(context, listen: false);
      await tasksData.getDailyTasks();
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

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose();
    if (_interstitialAd != null) {
      _interstitialAd.dispose();
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
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    final tasksData = Provider.of<DailyTasksProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return await Shared.onPopEventHandler(_interstitialAd);
      },
      child: Scaffold(
        appBar: GlobalAppBar(
          title: 'المهام اليومية',
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
                            onPressed: getTasks,
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
                  : tasksData.dailyTasks.isEmpty
                      ? Center(
                          child: Text('لا يوجد مهام متاحة اليوم'),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                itemCount: tasksData.dailyTasks.length,
                                itemBuilder: (context, i) {
                                  final zekr = tasksData.dailyTasks[i];
                                  return ListTile(
                                    title: Text(zekr.title),
                                    subtitle: Text(zekr.description),
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
                              )
                          ],
                        ),
        ),
      ),
    );
  }
}
