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
              onMonthly: () => _buy(() => ref.read(premiumProvider.notifier).purchaseMonthly()),
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
  final VoidCallback onMonthly;

  const _PlanCards({
    required this.purchasing,
    required this.onMonthly,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 月額
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: purchasing ? null : onMonthly,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('月額プラン', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text('¥300 / 月', style: TextStyle(color: kTextMuted, fontSize: 13)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: kTextMuted),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
