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
        case 'streak_30': earned = streakDays >= 30; break;
        case 'kanji_first': earned = totalKanjiCorrect >= 1; break;
        case 'kanji_10': earned = totalKanjiCorrect >= 10; break;
        case 'reading_first': earned = totalReadingCorrect >= 1; break;
        case 'perfect_score': earned = justPerfect; break;
        case 'stage_5': earned = maxStageCleared >= 5; break;
        case 'stage_10': earned = maxStageCleared >= 10; break;
      }

      if (earned) {
        final now = DateTime.now();
        await prefs.setString('$_earnedPrefix${badge.id}', now.toIso8601String());
        newBadges.add(badge);
      }
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
