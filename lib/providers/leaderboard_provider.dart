import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/leaderboard_model.dart';
import '../services/firebase_realtime_db.dart';

final globalLeaderboardProvider = StreamProvider<List<LeaderboardEntry>>((ref) {
  return FirebaseRealtimeAPI.getLeaderboardStream('global');
});

final gradeLeaderboardProvider = StreamProvider.family<List<LeaderboardEntry>, int>((ref, grade) {
  return FirebaseRealtimeAPI.getLeaderboardStream('grade_$grade');
});

final userRankingProvider = StateProvider<UserRanking?>((ref) => null);

final leaderboardNotifierProvider = StateNotifierProvider<LeaderboardNotifier, Map<String, dynamic>>((ref) {
  return LeaderboardNotifier();
});

class LeaderboardNotifier extends StateNotifier<Map<String, dynamic>> {
  LeaderboardNotifier()
      : super({
          'globalRank': 0,
          'gradeRank': 0,
          'friendGroupRank': 0,
          'totalScore': 0,
          'winRate': 0.0,
          'lastUpdated': DateTime.now().toString(),
        });

  /// Update user ranking
  Future<void> updateUserRanking(
    String userId,
    int globalRank,
    int gradeRank,
    int totalScore,
    double winRate,
  ) async {
    try {
      final ranking = UserRanking(
        userId: userId,
        globalRank: globalRank,
        gradeRank: gradeRank,
        friendGroupRank: 0, // TODO: Calculate friend group rank
        totalScore: totalScore,
        winRate: winRate,
        lastUpdated: DateTime.now(),
      );

      await FirebaseRealtimeAPI.updateUserRanking(userId, ranking);

      state = {
        'globalRank': globalRank,
        'gradeRank': gradeRank,
        'friendGroupRank': 0,
        'totalScore': totalScore,
        'winRate': winRate,
        'lastUpdated': DateTime.now().toString(),
      };
    } catch (e) {
      debugPrint('❌ Error updating ranking: $e');
      rethrow;
    }
  }

  /// Get rank badge/medal based on global rank
  String getRankBadge() {
    final rank = (state['globalRank'] as int?) ?? 0;
    if (rank == 0) return '👤'; // Not ranked
    if (rank <= 10) return '🥇'; // Top 10
    if (rank <= 50) return '🥈'; // Top 50
    if (rank <= 100) return '🥉'; // Top 100
    return '⭐'; // Regular ranking
  }

  /// Get rank title
  String getRankTitle() {
    final rank = (state['globalRank'] as int?) ?? 0;
    if (rank == 0) return 'ランク外';
    if (rank == 1) return '王様';
    if (rank <= 3) return 'エリート';
    if (rank <= 10) return 'トップ10';
    if (rank <= 50) return 'トップ50';
    if (rank <= 100) return 'トップ100';
    return 'ランク中';
  }

  /// Get percentile rank
  double getPercentileRank(int totalPlayers) {
    final rank = (state['globalRank'] as int?) ?? 0;
    if (rank == 0 || totalPlayers == 0) return 0.0;
    return ((totalPlayers - rank) / totalPlayers) * 100;
  }

  /// Get next milestone
  Map<String, dynamic> getNextMilestone() {
    final rank = (state['globalRank'] as int?) ?? 0;

    if (rank == 0) {
      return {
        'target': 100,
        'current': 0,
        'label': 'ランク100以内を目指そう！',
        'progress': 0.0,
      };
    }

    if (rank > 100) {
      return {
        'target': 100,
        'current': rank,
        'label': 'トップ100',
        'progress': ((100 - rank + 1) / 100).clamp(0.0, 1.0),
      };
    }

    if (rank > 50) {
      return {
        'target': 50,
        'current': rank,
        'label': 'トップ50',
        'progress': ((50 - rank + 1) / 50).clamp(0.0, 1.0),
      };
    }

    if (rank > 10) {
      return {
        'target': 10,
        'current': rank,
        'label': 'トップ10',
        'progress': ((10 - rank + 1) / 10).clamp(0.0, 1.0),
      };
    }

    return {
      'target': 1,
      'current': rank,
      'label': '王様を目指そう！',
      'progress': ((1 - rank + 1) / 1).clamp(0.0, 1.0),
    };
  }

  /// Calculate ranking streak bonus
  int calculateRankingBonus(int daysConsecutiveTopRank) {
    // Bonus points for maintaining top ranking
    return (daysConsecutiveTopRank * 10).clamp(0, 500);
  }

  /// Get ranking statistics
  Map<String, dynamic> getRankingStats() {
    return {
      'globalRank': state['globalRank'],
      'gradeRank': state['gradeRank'],
      'totalScore': state['totalScore'],
      'winRate': state['winRate'],
      'badge': getRankBadge(),
      'title': getRankTitle(),
      'nextMilestone': getNextMilestone(),
    };
  }

  /// Get competing players (nearby ranks)
  Future<List<LeaderboardEntry>> getCompetingPlayers(
    String leaderboardType,
    int userRank, {
    int radius = 5,
  }) async {
    try {
      // TODO: Fetch nearby ranked players
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching competing players: $e');
      return [];
    }
  }

  /// Get rank progress chart data
  Future<List<Map<String, dynamic>>> getRankProgressHistory() async {
    try {
      // TODO: Fetch historical rank data
      // Returns list of {date: String, rank: int}
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching rank history: $e');
      return [];
    }
  }

  /// Check if user can unlock a rank-based reward
  bool canUnlockReward(String rewardId) {
    final rank = (state['globalRank'] as int?) ?? 0;

    switch (rewardId) {
      case 'top_10_badge':
        return rank > 0 && rank <= 10;
      case 'top_50_badge':
        return rank > 0 && rank <= 50;
      case 'top_100_badge':
        return rank > 0 && rank <= 100;
      case 'elite_skin':
        return rank > 0 && rank <= 3;
      case 'champion_character':
        return rank == 1;
      default:
        return false;
    }
  }
}
