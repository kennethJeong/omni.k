import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:omni_k/admob_helper.dart';

class Admob {
  void adLoadInterstitial() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          ad.show();

          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad showed the full screen content.
            onAdShowedFullScreenContent: (ad) {},
            // Called when an impression occurs on the ad.
            onAdImpression: (ad) {},
            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },
            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },
          );

          print('$ad loaded.');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      )
    );
  }

  BannerAd adLoadBanner(BuildContext context) {
    final AdSize adSize = AdSize(width: MediaQuery.of(context).size.width.toInt(), height: 65);

    return BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (_) {
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
        },
      ),
      size: adSize,
      request: const AdRequest(),
    );
  }

  Widget widgetAdBanner(BuildContext context, double height) {
    BannerAd? adBanner;

    try {
      adBanner = Admob().adLoadBanner(context);
      adBanner.load();
    } catch(_) {
      adBanner = null;
    }

    return SizedBox(
      height: height,
      child: Center(
        child: AdWidget(ad: adBanner!),
      ),
    );
  }
}