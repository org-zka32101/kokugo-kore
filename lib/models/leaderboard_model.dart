import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_model.freezed.dart';
part 'leaderboard_model.g.dart';

@freezed
class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required String userId,
    required String displayName,
    required String profileImageUrl,
    required int grade,
    required int rank,
    required int totalScore,
    required double averageAccuracy,
    required int totalBattlesWon,
    required double winRate,
    required DateTime lastUpdated,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
}

@freezed
class RankingData with _$RankingData {
  const factory RankingData({
    required String rankingId,
    required String rankingType, // global, grade_level, friend_group
    required int grade, // null if global
    required List<LeaderboardEntry> entries,
    required DateTime updatedDate,
  }) = _RankingData;

  factory RankingData.fromJson(Map<String, dynamic> json) =>
      _$RankingDataFromJson(json);
}

@freezed
class UserRanking with _$UserRanking {
  const factory UserRanking({
    required String userId,
    required int globalRank,
    required int gradeRank,
    required int friendGroupRank,
    required int totalScore,
    required double winRate,
    required DateTime lastUpdated,
  }) = _UserRanking;

  factory UserRanking.fromJson(Map<String, dynamic> json) =>
      _$UserRankingFromJson(json);
}

@freezed
class BattleLeaderboard with _$BattleLeaderboard {
  const factory BattleLeaderboard({
    required String leaderboardId,
    required String periodType, // weekly, monthly, all_time
    required DateTime periodStart,
    required DateTime periodEnd,
    required List<LeaderboardEntry> battleWinners,
    required List<LeaderboardEntry> highestScorers,
  }) = _BattleLeaderboard;

  factory BattleLeaderboard.fromJson(Map<String, dynamic> json) =>
      _$BattleLeaderboardFromJson(json);
}

@freezed
class ReadingLeaderboard with _$ReadingLeaderboard {
  const factory ReadingLeaderboard({
    required String leaderboardId,
    required String periodType,
    required DateTime periodStart,
    required DateTime periodEnd,
    required List<ReadingLeaderboardEntry> topReaders,
  }) = _ReadingLeaderboard;

  factory ReadingLeaderboard.fromJson(Map<String, dynamic> json) =>
      _$ReadingLeaderboardFromJson(json);
}

@freezed
class ReadingLeaderboardEntry with _$ReadingLeaderboardEntry {
  const factory ReadingLeaderboardEntry({
    required String userId,
    required String displayName,
    required String profileImageUrl,
    required int totalReadingMinutes,
    required int passagesCompleted,
    required double averageComprehensionScore,
    required int rank,
  }) = _ReadingLeaderboardEntry;

  factory ReadingLeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$ReadingLeaderboardEntryFromJson(json);
}
