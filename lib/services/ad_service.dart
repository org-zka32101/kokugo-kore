// lib/services/ad_service.dart
// AdMob 広告管理サービス（テスト用ID使用）

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// テスト用広告ユニットID（本番時は実際のIDに差し替え）
class AdIds {
  static const String bannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';

  static String get banner => bannerAndroid;
  static String get interstitial => interstitialAndroid;
}

class AdService {
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialLoading = false;

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadInterstitial();
  }

  static void _loadInterstitial() {
    if (_isInterstitialLoading) return;
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, _) {
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoading = false;
        },
      ),
    );
  }

  static void showInterstitial() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      _loadInterstitial();
    }
  }

  static BannerAd createBanner({
    AdSize size = AdSize.banner,
    VoidCallback? onLoaded,
    VoidCallback? onFailed,
  }) {
    return BannerAd(
      adUnitId: AdIds.banner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded?.call(),
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          onFailed?.call();
        },
      ),
    );
  }
}
