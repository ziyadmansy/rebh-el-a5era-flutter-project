import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_dialy_guide/models/surah.dart';
import 'package:muslim_dialy_guide/screens/quraan_arabic/surah_view_builder.dart';

import '../../common/shared.dart';
import '../../constants.dart';

class SurahListBuilder extends StatefulWidget {
  final List<Surah> surah;

  SurahListBuilder({Key key, this.surah}) : super(key: key);

  @override
  _SurahListBuilderState createState() => _SurahListBuilderState();
}

class _SurahListBuilderState extends State<SurahListBuilder> {
  TextEditingController editingController = TextEditingController();

  BannerAd myBanner;
  InterstitialAd _interstitialAd;
  AdWidget adWidget;

  List<Surah> surah = [];

  void initSurahListView() {
    if (surah.isNotEmpty) {
      surah.clear();
    }
    surah.addAll(widget.surah);
  }

  void filterSearchResults(String query) {
    /*-----------------------------------------------------------------------------------------------*/
    /*----------------------------- Fill surah list if empty -----------------------*/
    /*-----------------------------------------------------------------------------------------------*/
    initSurahListView();

    /// SearchList contains every surah
    // ignore: deprecated_member_use
    List<Surah> searchList = List<Surah>();
    searchList.addAll(surah);

    /// Contains matching surah(s)
    // ignore: deprecated_member_use
    List<Surah> listData = List<Surah>();
    if (query.isNotEmpty) {
      /// Loop all surah(s)
      searchList.forEach((item) {
        /*-----------------------------------------------------------------------------------------------*/
        /*----------------------------- Filter by (titleAr:exact,title:partial,pageIndex) -----------------------*/
        /*-----------------------------------------------------------------------------------------------*/
        if (item.titleAr.contains(query) ||
            item.title.toLowerCase().contains(query.toLowerCase()) ||
            item.pageIndex.toString().contains(query)) {
          listData.add(item);
        }
      });

      /*-----------------------------------------------------------------------------------------------*/
      /*----------------------------- Fill surah List with searched surah(s)-----------------------*/
      /*-----------------------------------------------------------------------------------------------*/
      setState(() {
        surah.clear();
        surah.addAll(listData);
      });
      return;
    }
    /*-----------------------------------------------------------------------------------------------*/
    /*------------------------------Show all surah list-------------------------*/
    /*-----------------------------------------------------------------------------------------------*/
    else {
      setState(() {
        surah.clear();
        surah.addAll(widget.surah);
      });
    }
  }

  @override
  void initState() {
    /*-----------------------------------------------------------------------------------------------*/
    /*------------------------------Init listView with all surah(s)-------------------------*/
    /*-----------------------------------------------------------------------------------------------*/
    initSurahListView();
    Future.delayed(
      Duration.zero,
      () async {
        initAds();
      },
    );
    super.initState();
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
    return Container(
      child: Column(
        children: <Widget>[
          /*-----------------------------------------------------------------------------------------------*/
          /*---------------------------------- Search field--------------------------------*/
          /*-----------------------------------------------------------------------------------------------*/
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Colors.green,
              onChanged: (value) {
                filterSearchResults(value);
                print(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "إبحث عن سورة",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
          ),

          /*-----------------------------------------------------------------------------------------------*/
          /*---------------------- ListView represent all/searched surah(s)--------------------------------*/
          /*-----------------------------------------------------------------------------------------------*/
          Expanded(
            child: ListView.builder(
              itemCount: surah.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                  title: Text(surah[index].titleAr),
                  subtitle: Text(surah[index].title),
                  leading: Image(
                    image: AssetImage(
                        "assets/arabic_quran/${surah[index].place}.png"),
                    width: 30,
                    height: 30,
                  ),
                  trailing: Text("${surah[index].pageIndex}"),
                  onTap: () {
                    /// Push to Quran view ([int pages] represent surah page(reversed index))
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahViewBuilder(
                          readingMode: true,
                          surah: surah[index],
                        ),
                      ),
                    );
                  }),
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
    );
  }
}
