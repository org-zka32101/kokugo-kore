import 'package:flutter/material.dart';
import 'package:shared_core/models/badge_model.dart';
import '../theme/app_theme.dart';

/// バッジ獲得の通知ウィジェット（アニメーション付き）
class BadgeAchievementNotification extends StatefulWidget {
  final List<BadgeModel> badges;
  final Duration displayDuration;
  final VoidCallback? onDismiss;

  const BadgeAchievementNotification({
    super.key,
    required this.badges,
    this.displayDuration = const Duration(seconds: 4),
    this.onDismiss,
  });

  @override
  State<BadgeAchievementNotification> createState() =>
      _BadgeAchievementNotificationState();
}

class _BadgeAchievementNotificationState
    extends State<BadgeAchievementNotification>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideController.forward();
    _scaleController.forward();

    // 指定時間後に自動的に閉じる
    Future.delayed(widget.displayDuration, () {
      if (mounted) {
        _slideController.reverse();
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            widget.onDismiss?.call();
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildAchievementCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard() {
    if (widget.badges.isEmpty) return const SizedBox.shrink();

    // 複数バッジの場合
    if (widget.badges.length > 1) {
      return _buildMultipleBadgesCard();
    }

    // 単一バッジの場合
    final badge = widget.badges.first;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor.withAlpha(240),
            kPrimaryColor.withAlpha(200),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withAlpha(100),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // タイトル
            const Text(
              '🎉 バッジを獲得しました！',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // バッジアイコンと名前
            Column(
              children: [
                _buildBadgeIcon(badge.emoji),
                const SizedBox(height: 12),
                Text(
                  badge.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  badge.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 閉じるボタン
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onDismiss?.call();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'すごい！',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleBadgesCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade600.withAlpha(240),
            Colors.orange.shade600.withAlpha(200),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withAlpha(100),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // タイトル
            const Text(
              '🎉🎉 複数のバッジを獲得！',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // バッジリスト
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: widget.badges
                  .map((badge) => _buildBadgeChip(badge))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // 閉じるボタン
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onDismiss?.call();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '完璧です！',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeChip(BadgeModel badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(badge.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                badge.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                badge.description,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeIcon(String emoji) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 48),
        ),
      ),
    );
  }
}

/// バッジ獲得通知を表示するヘルパー関数
Future<void> showBadgeAchievementDialog(
  BuildContext context,
  List<BadgeModel> badges, {
  Duration displayDuration = const Duration(seconds: 4),
  VoidCallback? onDismiss,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withAlpha(100),
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: BadgeAchievementNotification(
        badges: badges,
        displayDuration: displayDuration,
        onDismiss: onDismiss,
      ),
    ),
  );
}
