import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ユーザーのランキング順位を表すモデル
class UserRankInfo {
  final int rank; // 1位, 2位, ... (0は順位外)
  final String userName;
  final int score;
  final double accuracy;
  final bool isCurrentUser;

  const UserRankInfo({
    required this.rank,
    required this.userName,
    required this.score,
    required this.accuracy,
    required this.isCurrentUser,
  });

  /// TOP10ランカーかチェック
  bool get isTopTenRanker => rank > 0 && rank <= 10;
}

/// ユーザーの順位情報を取得するプロバイダー
class LeaderboardRankNotifier extends Notifier<UserRankInfo?> {
  @override
  UserRankInfo? build() => null;

  /// Firebaseから現在のランキング順位を取得
  Future<UserRankInfo?> fetchUserRank() async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) return null;

      final database = FirebaseDatabase.instance;
      final ref = database.ref('leaderboard/scores');
      final snapshot = await ref.orderByChild('score').get();

      if (!snapshot.exists) {
        state = null;
        return null;
      }

      // スコアが高い順にソート
      final entries = <String, Map<String, dynamic>>{};
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        data.forEach((key, value) {
          entries[key as String] = Map<String, dynamic>.from(value as Map);
        });
      }

      final sortedEntries = entries.entries.toList()
        ..sort((a, b) => (b.value['score'] as int? ?? 0)
            .compareTo(a.value['score'] as int? ?? 0));

      // ユーザーの順位を探す
      int userRank = 0;
      late UserRankInfo userInfo;

      for (int i = 0; i < sortedEntries.length; i++) {
        final entry = sortedEntries[i];
        if (entry.key == userId) {
          userRank = i + 1; // 1から始まる
          userInfo = UserRankInfo(
            rank: userRank,
            userName: entry.value['userName'] as String? ?? 'ユーザー',
            score: entry.value['score'] as int? ?? 0,
            accuracy:
                (entry.value['accuracy'] as num? ?? 0).toDouble(),
            isCurrentUser: true,
          );
          break;
        }
      }

      state = userInfo;
      return userInfo;
    } catch (e) {
      print('Error fetching leaderboard rank: $e');
      state = null;
      return null;
    }
  }

  /// 現在のユーザーIDを取得（SharedPreferencesから）
  Future<String?> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  /// ユーザーのスコアをFirebaseに保存
  Future<void> updateUserScore({
    required int score,
    required double accuracy,
    required String userName,
  }) async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) return;

      final database = FirebaseDatabase.instance;
      final ref = database.ref('leaderboard/scores/$userId');
      await ref.set({
        'userId': userId,
        'userName': userName,
        'score': score,
        'accuracy': accuracy,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // ランクを再計算
      await fetchUserRank();
    } catch (e) {
      print('Error updating leaderboard score: $e');
    }
  }

  /// ランキング上位10位のユーザーを取得
  Future<List<UserRankInfo>> fetchTopTenRankers() async {
    try {
      final database = FirebaseDatabase.instance;
      final ref = database.ref('leaderboard/scores');
      final snapshot = await ref.orderByChild('score').get();

      if (!snapshot.exists) {
        return [];
      }

      final entries = <String, Map<String, dynamic>>{};
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        data.forEach((key, value) {
          entries[key as String] = Map<String, dynamic>.from(value as Map);
        });
      }

      final sortedEntries = entries.entries.toList()
        ..sort((a, b) => (b.value['score'] as int? ?? 0)
            .compareTo(a.value['score'] as int? ?? 0));

      final currentUserId = await _getCurrentUserId();
      final topTen = <UserRankInfo>[];

      for (int i = 0; i < sortedEntries.length && i < 10; i++) {
        final entry = sortedEntries[i];
        topTen.add(UserRankInfo(
          rank: i + 1,
          userName: entry.value['userName'] as String? ?? 'ユーザー',
          score: entry.value['score'] as int? ?? 0,
          accuracy: (entry.value['accuracy'] as num? ?? 0).toDouble(),
          isCurrentUser: entry.key == currentUserId,
        ));
      }

      return topTen;
    } catch (e) {
      print('Error fetching top 10 rankers: $e');
      return [];
    }
  }
}

/// ユーザーのランキング順位をリアルタイムで監視
final leaderboardRankProvider =
    NotifierProvider<LeaderboardRankNotifier, UserRankInfo?>(
  LeaderboardRankNotifier.new,
);
