import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_core/models/badge_model.dart';

const _earnedPrefix = 'badge_earned_';

class BadgeState {
  final List<EarnedBadge> earnedBadges;
  final List<BadgeModel> newlyEarned; // 直近で獲得したバッジ（表示後クリア）

  const BadgeState({required this.earnedBadges, required this.newlyEarned});
  static const empty = BadgeState(earnedBadges: [], newlyEarned: []);

  BadgeState copyWith({
    List<EarnedBadge>? earnedBadges,
    List<BadgeModel>? newlyEarned,
  }) =>
      BadgeState(
        earnedBadges: earnedBadges ?? this.earnedBadges,
        newlyEarned: newlyEarned ?? this.newlyEarned,
      );
}

class BadgeNotifier extends Notifier<BadgeState> {
  @override
  BadgeState build() => BadgeState.empty;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final earned = <EarnedBadge>[];
    for (final badge in allBadges) {
      final dateStr = prefs.getString('$_earnedPrefix${badge.id}');
      if (dateStr != null) {
        final date = DateTime.tryParse(dateStr);
        if (date != null) {
          earned.add(EarnedBadge(badge: badge, earnedAt: date));
        }
      }
    }
    state = BadgeState(earnedBadges: earned, newlyEarned: []);
  }

  Future<List<BadgeModel>> checkAndAward({
    required int streakDays,
    required int totalKanjiCorrect,
    required int totalReadingCorrect,
    required int maxStageCleared,
    required int perfectStageCount,
    required bool justPerfect,
    int totalCorrect = 0,
    int clearedStageCount = 0,
    int currentPerfectStreak = 0,
    int unlockedCharacterCount = 0,
    bool hasMaxLevelCharacter = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyEarned = state.earnedBadges.map((e) => e.badge.id).toSet();
    final newBadges = <BadgeModel>[];

    for (final badge in allBadges) {
      if (alreadyEarned.contains(badge.id)) continue;
      bool earned = false;

      switch (badge.id) {
        case 'streak_3': earned = streakDays >= 3; break;
        case 'streak_7': earned = streakDays >= 7; break;
        case 'streak_14': earned = streakDays >= 14; break;
        case 'streak_30': earned = streakDays >= 30; break;
        case 'streak_60': earned = streakDays >= 60; break;
        case 'streak_100': earned = streakDays >= 100; break;
        case 'score_first': earned = clearedStageCount >= 1; break;
        case 'perfect_score': earned = justPerfect; break;
        case 'quiz_total_100': earned = totalCorrect >= 100; break;
        case 'quiz_total_500': earned = totalCorrect >= 500; break;
        case 'perfect_3': earned = currentPerfectStreak >= 3; break;
        case 'kanji_first': earned = totalKanjiCorrect >= 1; break;
        case 'kanji_10': earned = totalKanjiCorrect >= 10; break;
        case 'reading_first': earned = totalReadingCorrect >= 1; break;
        // reading_10: 「読解クイズで10問達成」。専用トラッキングがまだ無いため
        // totalReadingCorrectで代用（読解力強化機能側の保存実装と合わせて要見直し）。
        case 'reading_10': earned = totalReadingCorrect >= 10; break;
        case 'character_3': earned = unlockedCharacterCount >= 3; break;
        case 'character_lv_max': earned = hasMaxLevelCharacter; break;
        case 'stage_20': earned = clearedStageCount >= 20; break;
        case 'stage_30': earned = clearedStageCount >= 30; break;
        // badge_collectorはこのループ内では判定せず、下で別途チェックする
        // （「10個獲得」は他バッジの獲得数に依存するため）。
        // writing_*/grammar_*/vocab_* は「かく」「文法」「ことば」機能側の
        // 実績トラッキングが未実装のため、現時点では判定できない（既知の未対応）。
      }

      if (earned) {
        final now = DateTime.now();
        await prefs.setString('$_earnedPrefix${badge.id}', now.toIso8601String());
        newBadges.add(badge);
      }
    }

    // badge_collector: 上のループで新規獲得したものも含めた合計が10個以上か
    if (!alreadyEarned.contains('badge_collector') &&
        alreadyEarned.length + newBadges.length >= 10) {
      final collector = allBadges.firstWhere((b) => b.id == 'badge_collector');
      await prefs.setString(
        '$_earnedPrefix${collector.id}', DateTime.now().toIso8601String());
      newBadges.add(collector);
    }

    if (newBadges.isNotEmpty) {
      final nowEarned = [
        ...state.earnedBadges,
        ...newBadges.map((b) => EarnedBadge(badge: b, earnedAt: DateTime.now())),
      ];
      state = state.copyWith(earnedBadges: nowEarned, newlyEarned: newBadges);
    }
    return newBadges;
  }

  void clearNewlyEarned() {
    state = state.copyWith(newlyEarned: []);
  }
}

final badgeProvider = NotifierProvider<BadgeNotifier, BadgeState>(BadgeNotifier.new);
