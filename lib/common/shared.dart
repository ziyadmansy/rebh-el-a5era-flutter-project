import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constants.dart';

class Shared {
  static Future<BannerAd> getBannerAd(int width) async {
    AnchoredAdaptiveBannerAdSize size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    return BannerAd(
      adUnitId: bannerAdId,
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
  }

  static Future<bool> onPopEventHandler(InterstitialAd ad) async {
    // if (ad != null) {
    //   ad.show();
    // }
    return true;
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );
  }
}
