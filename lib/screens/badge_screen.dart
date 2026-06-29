import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/models/badge_model.dart';
import '../providers/badge_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/badge_widget.dart';

class BadgeScreen extends ConsumerWidget {
  const BadgeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgeState = ref.watch(badgeProvider);
    final earnedIds = badgeState.earnedBadges.map((e) => e.badge.id).toSet();
    final earnedCount = badgeState.earnedBadges.length;
    final totalCount = allBadges.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('バッジコレクション'),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          _BadgeHeader(earned: earnedCount, total: totalCount),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: allBadges.length,
              itemBuilder: (context, i) {
                final badge = allBadges[i];
                if (earnedIds.contains(badge.id)) {
                  final earned = badgeState.earnedBadges.firstWhere((e) => e.badge.id == badge.id);
                  return GestureDetector(
                    onTap: () => _showBadgeDetail(context, earned),
                    child: BadgeWidget(earnedBadge: earned),
                  );
                }
                return GestureDetector(
                  onTap: () => _showLockedDetail(context, badge),
                  child: LockedBadgeWidget(badge: badge),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showBadgeDetail(BuildContext context, EarnedBadge earned) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(earned.badge.emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(earned.badge.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(earned.badge.description,
                style: const TextStyle(color: kTextMuted, fontSize: 14),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              '獲得日: ${earned.earnedAt.year}/${earned.earnedAt.month}/${earned.earnedAt.day}',
              style: const TextStyle(color: kTextMuted, fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showLockedDetail(BuildContext context, BadgeModel badge) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0, 0, 0, 0.4, 0,
              ]),
              child: Text(badge.emoji, style: const TextStyle(fontSize: 56)),
            ),
            const SizedBox(height: 12),
            Text(badge.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(badge.description,
                style: const TextStyle(color: kTextMuted, fontSize: 14),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: kBgLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock, size: 16, color: kTextMuted),
                  SizedBox(width: 6),
                  Text('まだ獲得していません', style: TextStyle(color: kTextMuted, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _BadgeHeader extends StatelessWidget {
  final int earned;
  final int total;
  const _BadgeHeader({required this.earned, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = earned / total;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🏅', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text('$earned / $total バッジ',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Text('${(pct * 100).round()}%',
                  style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
