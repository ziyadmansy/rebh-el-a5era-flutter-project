import 'package:flutter/cupertino.dart';
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
}
