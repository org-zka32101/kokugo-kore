// lib/widgets/banner_ad_widget.dart
// バナー広告ウィジェット（無料ユーザー向け）

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../providers/premium_provider.dart';
import '../services/ad_service.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    final premium = ref.read(premiumProvider);
    if (!premium.isPremium) {
      _loadBanner();
    }
  }

  void _loadBanner() {
    final banner = AdService.createBanner(
      onLoaded: () {
        if (mounted) setState(() => _isLoaded = true);
      },
      onFailed: () {
        if (mounted) setState(() => _isLoaded = false);
      },
    );
    banner.load();
    _bannerAd = banner;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final premium = ref.watch(premiumProvider);
    if (premium.isPremium || !_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }
    return Container(
      height: _bannerAd!.size.height.toDouble(),
      color: Colors.white,
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
