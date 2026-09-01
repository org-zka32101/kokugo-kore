import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/badge_model.dart';
import '../providers/badge_provider.dart';
import '../providers/badge_acquisition_history_provider.dart';

/// バッジシステム用デバッグユーティリティ
class BadgeDebugUtils {
  /// すべてのバッジを獲得状態にセット（デバッグ用）
  static Future<void> acquireAllBadges(WidgetRef ref) async {
    if (!kDebugMode) {
      throw Exception('Debug mode only');
    }

    final badgeNotifier = ref.read(badgeProvider.notifier);
    await badgeNotifier.acquireAllBadges();

    debugPrint('✅ All badges acquired');
  }

  /// 特定のバッジを獲得状態にセット
  static Future<void> acquireBadge(
    WidgetRef ref,
    String badgeId,
    String badgeTitle,
    String emoji,
  ) async {
    if (!kDebugMode) {
      throw Exception('Debug mode only');
    }

    final badgeNotifier = ref.read(badgeProvider.notifier);
    await badgeNotifier.acquireBadge(badgeId, badgeTitle, emoji);

    // 履歴にも記録
    final historyNotifier = ref.read(badgeAcquisitionHistoryProvider.notifier);
    await historyNotifier.recordBadgeAcquisition(badgeId, badgeTitle, emoji);

    debugPrint('✅ Badge acquired: $badgeTitle ($emoji)');
  }

  /// すべてのバッジを未獲得状態にリセット
  static Future<void> resetAllBadges(WidgetRef ref) async {
    if (!kDebugMode) {
      throw Exception('Debug mode only');
    }

    // SharedPreferences からデータを削除
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('earned_badges');
    await prefs.remove('completed_set_bonuses');

    // 獲得履歴をクリア（先に実行）
    final historyNotifier = ref.read(badgeAcquisitionHistoryProvider.notifier);
    await historyNotifier.clearHistory();

    // バッジプロバイダーの状態をリセット
    final badgeNotifier = ref.read(badgeProvider.notifier);
    badgeNotifier.state = const BadgeState(
      earnedBadges: [],
      newlyCompletedSetBonuses: [],
    );

    debugPrint('✅ All badges reset');
  }

  /// 獲得履歴をクリア
  static Future<void> clearBadgeHistory(WidgetRef ref) async {
    if (!kDebugMode) {
      throw Exception('Debug mode only');
    }

    final historyNotifier = ref.read(badgeAcquisitionHistoryProvider.notifier);
    await historyNotifier.clearHistory();

    debugPrint('✅ Badge history cleared');
  }

  /// セットボーナスを完成状態にセット
  static Future<void> completeSetBonus(
    WidgetRef ref,
    String setId,
  ) async {
    if (!kDebugMode) {
      throw Exception('Debug mode only');
    }

    final prefs = await SharedPreferences.getInstance();
    final key = 'completed_set_bonus_$setId';
    await prefs.setBool(key, true);

    debugPrint('✅ Set Bonus completed: $setId');
  }

  /// デバッグ情報を表示
  static void printDebugInfo(WidgetRef ref) {
    if (!kDebugMode) {
      throw Exception('Debug mode only');
    }

    final badgeState = ref.read(badgeProvider);
    final historyState = ref.read(badgeAcquisitionHistoryProvider);

    debugPrint('''
╔════════════════════════════════════════╗
║     Badge System Debug Info            ║
╚════════════════════════════════════════╝

📊 Earned Badges: ${badgeState.earnedBadges.length}
📚 Badge Records: ${historyState.badgeRecords.length}
🏆 Set Bonus Records: ${historyState.setBonusRecords.length}
🔄 Newly Completed Sets: ${badgeState.newlyCompletedSetBonuses.length}

Earned Badge IDs:
${badgeState.earnedBadges.map((b) => '  - ${b.badge.id}: ${b.badge.title}').join('\n')}

Recent Badge Records:
${historyState.badgeRecords.take(5).map((r) => '  - ${r.badgeTitle} (${r.acquiredAt})').join('\n')}
''');
  }

  /// 獲得バッジのエクスポート（JSON形式）
  static String exportBadgesAsJson(WidgetRef ref) {
    if (!kDebugMode) {
      throw Exception('Debug mode only');
    }

    final badgeState = ref.read(badgeProvider);
    final badges = badgeState.earnedBadges.map((b) => {
      'id': b.badge.id,
      'title': b.badge.title,
      'emoji': b.badge.emoji,
      'earnedAt': b.earnedAt.toIso8601String(),
    }).toList();

    return '''
{
  "badges": $badges,
  "count": ${badges.length},
  "exported_at": "${DateTime.now().toIso8601String()}"
}
''';
  }
}
