import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _premiumKey = 'is_premium';
const _trialStartKey = 'trial_start_date';
const _trialDays = 14;

/// Google Play 商品ID（コンソールで設定する）
const kProductIdMonthly = 'kokugo_kore_monthly_300';
const kProductIdYearly = 'kokugo_kore_yearly_2400';

/// 無料で遊べる最大ステージ番号
const kFreeStageLimit = 3;

/// 購入試行の結果。`launched: true` は購入リクエストが起動できたことを意味するだけで、
/// 実際の課金完了（PurchaseStatus.purchased）はまだ確定していない点に注意。
/// 完了通知は premiumProvider の状態（isPremium）を通じて別途届く。
class PurchaseAttemptResult {
  final bool launched;
  final String? errorMessage;

  const PurchaseAttemptResult._(this.launched, this.errorMessage);

  factory PurchaseAttemptResult.launched() =>
      const PurchaseAttemptResult._(true, null);

  factory PurchaseAttemptResult.failure(String message) =>
      PurchaseAttemptResult._(false, message);
}

class PremiumState {
  final bool isPremium;
  final bool isTrialActive;
  final int trialDaysLeft;
  final bool isLoading;

  const PremiumState({
    this.isPremium = false,
    this.isTrialActive = false,
    this.trialDaysLeft = 0,
    this.isLoading = true,
  });

  bool canAccessStage(int stageNumber) =>
      isPremium || isTrialActive || stageNumber <= kFreeStageLimit;

  PremiumState copyWith({
    bool? isPremium,
    bool? isTrialActive,
    int? trialDaysLeft,
    bool? isLoading,
  }) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      isTrialActive: isTrialActive ?? this.isTrialActive,
      trialDaysLeft: trialDaysLeft ?? this.trialDaysLeft,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PremiumNotifier extends Notifier<PremiumState> {
  StreamSubscription<List<PurchaseDetails>>? _sub;

  @override
  PremiumState build() => const PremiumState();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final isPremium = prefs.getBool(_premiumKey) ?? false;

    // トライアル判定
    final trialStartStr = prefs.getString(_trialStartKey);
    bool isTrialActive = false;
    int daysLeft = 0;

    if (trialStartStr == null) {
      // 初回起動 → トライアル開始
      final today = DateTime.now().toIso8601String();
      await prefs.setString(_trialStartKey, today);
      isTrialActive = true;
      daysLeft = _trialDays;
    } else {
      final trialStart = DateTime.tryParse(trialStartStr);
      if (trialStart != null) {
        final elapsed = DateTime.now().difference(trialStart).inDays;
        daysLeft = _trialDays - elapsed;
        isTrialActive = daysLeft > 0;
      }
    }

    state = PremiumState(
      isPremium: isPremium,
      isTrialActive: isTrialActive && !isPremium,
      trialDaysLeft: daysLeft > 0 ? daysLeft : 0,
      isLoading: false,
    );

    // Google Play 購入状態をリッスン
    _listenPurchases();
  }

  void _listenPurchases() {
    _sub?.cancel();
    _sub = InAppPurchase.instance.purchaseStream.listen(
      (purchases) {
        for (final p in purchases) {
          if (p.status == PurchaseStatus.purchased ||
              p.status == PurchaseStatus.restored) {
            if (p.productID == kProductIdMonthly ||
                p.productID == kProductIdYearly) {
              _setPremium(true);
              InAppPurchase.instance.completePurchase(p);
            }
          }
        }
      },
      onError: (_) {},
    );
  }

  Future<void> _setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, value);
    state = state.copyWith(isPremium: value, isTrialActive: false, isLoading: false);
  }

  /// 月額プランを購入
  Future<PurchaseAttemptResult> purchaseMonthly() => _purchase(kProductIdMonthly);

  /// 年額プランを購入
  Future<PurchaseAttemptResult> purchaseYearly() => _purchase(kProductIdYearly);

  Future<PurchaseAttemptResult> _purchase(String productId) async {
    try {
      final available = await InAppPurchase.instance.isAvailable();
      if (!available) {
        return PurchaseAttemptResult.failure(
          '購入機能が利用できません。Google Playストアアプリにログインしているか確認してください。',
        );
      }

      final response =
          await InAppPurchase.instance.queryProductDetails({productId});
      if (response.productDetails.isEmpty) {
        return PurchaseAttemptResult.failure(
          '商品情報を取得できませんでした（$productId）。Play Console側の商品設定・審査状況、'
          'またはこのビルドの署名がストア掲載と一致しているかを確認してください。',
        );
      }

      final param = PurchaseParam(
        productDetails: response.productDetails.first,
      );
      final launched =
          await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
      if (!launched) {
        return PurchaseAttemptResult.failure('購入処理を開始できませんでした。もう一度お試しください。');
      }
      return PurchaseAttemptResult.launched();
    } catch (e) {
      return PurchaseAttemptResult.failure('購入処理でエラーが発生しました: $e');
    }
  }

  /// 購入の復元
  Future<void> restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }

  void cancelSubscription() {
    _sub?.cancel();
  }
}

final premiumProvider =
    NotifierProvider<PremiumNotifier, PremiumState>(PremiumNotifier.new);

/// Google Playから取得した実際の商品情報（価格は端末の地域・税設定に応じて
/// ストア側でローカライズされた文字列）。取得失敗時はnullを返し、呼び出し側で
/// フォールバック表示にする。
final premiumProductsProvider =
    FutureProvider<Map<String, ProductDetails>>((ref) async {
  final available = await InAppPurchase.instance.isAvailable();
  if (!available) return {};

  final response = await InAppPurchase.instance
      .queryProductDetails({kProductIdMonthly, kProductIdYearly});
  return {for (final p in response.productDetails) p.id: p};
});
