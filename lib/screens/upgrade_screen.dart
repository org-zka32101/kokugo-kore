import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/premium_provider.dart';
import '../theme/app_theme.dart';

class UpgradeScreen extends ConsumerStatefulWidget {
  const UpgradeScreen({super.key});

  @override
  ConsumerState<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends ConsumerState<UpgradeScreen> {
  bool _purchasing = false;

  @override
  Widget build(BuildContext context) {
    final premium = ref.watch(premiumProvider);
    final products = ref.watch(premiumProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('プレミアムプラン'),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _HeroSection(trialDaysLeft: premium.trialDaysLeft, isTrialActive: premium.isTrialActive),
            const SizedBox(height: 28),
            _FeatureList(),
            const SizedBox(height: 28),
            _PlanCards(
              purchasing: _purchasing,
              monthlyPrice: products.valueOrNull?[kProductIdMonthly]?.price,
              yearlyPrice: products.valueOrNull?[kProductIdYearly]?.price,
              onMonthly: () => _buy(() => ref.read(premiumProvider.notifier).purchaseMonthly()),
              onYearly: () => _buy(() => ref.read(premiumProvider.notifier).purchaseYearly()),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _purchasing ? null : () async {
                setState(() => _purchasing = true);
                await ref.read(premiumProvider.notifier).restorePurchases();
                if (mounted) setState(() => _purchasing = false);
              },
              child: const Text('購入を復元する', style: TextStyle(color: kTextMuted)),
            ),
            const SizedBox(height: 8),
            const Text(
              '※ プレミアムプランは自動更新されます。\nいつでも設定からキャンセルできます。',
              style: TextStyle(color: kTextMuted, fontSize: 11),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _buy(Future<bool> Function() fn) async {
    setState(() => _purchasing = true);
    final ok = await fn();
    if (mounted) {
      setState(() => _purchasing = false);
      if (ok) Navigator.of(context).pop();
    }
  }
}

class _HeroSection extends StatelessWidget {
  final int trialDaysLeft;
  final bool isTrialActive;
  const _HeroSection({required this.trialDaysLeft, required this.isTrialActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryColor, kPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('⭐', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text(
            '国語コレ！プレミアム',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          if (isTrialActive) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '無料トライアル あと$trialDaysLeft日',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ] else ...[
            const Text(
              'すべての学年・ステージが学び放題',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const features = [
      ('📖', '全ステージ（4・5）無制限アクセス'),
      ('🏅', 'プレミアムバッジコレクション'),
      ('📊', '詳細な学習レポート（coming soon）'),
      ('🤖', 'AI作文採点（coming soon）'),
      ('👨‍👩‍👧', '保護者ダッシュボード（coming soon）'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('プレミアム機能', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        ...features.map((f) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Text(f.$1, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(f.$2, style: const TextStyle(fontSize: 15)),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

class _PlanCards extends StatelessWidget {
  final bool purchasing;
  final String? monthlyPrice;
  final String? yearlyPrice;
  final VoidCallback onMonthly;
  final VoidCallback onYearly;

  const _PlanCards({
    required this.purchasing,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.onMonthly,
    required this.onYearly,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PlanCard(
          title: '月額プラン',
          // ストアから価格を取得できるまでの目安表示。実際の請求額は
          // Google Playが返す price を必ず優先する。
          price: monthlyPrice ?? '¥300 / 月（目安）',
          onTap: purchasing ? null : onMonthly,
        ),
        const SizedBox(height: 12),
        _PlanCard(
          title: '年額プラン',
          price: yearlyPrice ?? '¥2,400 / 年（目安）',
          badge: 'おトク',
          onTap: purchasing ? null : onYearly,
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String? badge;
  final VoidCallback? onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          if (badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: kAccentGreen.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                badge!,
                                style: const TextStyle(
                                    color: kAccentGreen, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(price, style: const TextStyle(color: kTextMuted, fontSize: 13)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: kTextMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
