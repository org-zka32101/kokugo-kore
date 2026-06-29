// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardEntryImpl _$$LeaderboardEntryImplFromJson(
  Map<String, dynamic> json,
) => _$LeaderboardEntryImpl(
  userId: json['userId'] as String,
  displayName: json['displayName'] as String,
  profileImageUrl: json['profileImageUrl'] as String,
  grade: (json['grade'] as num).toInt(),
  rank: (json['rank'] as num).toInt(),
  totalScore: (json['totalScore'] as num).toInt(),
  averageAccuracy: (json['averageAccuracy'] as num).toDouble(),
  totalBattlesWon: (json['totalBattlesWon'] as num).toInt(),
  winRate: (json['winRate'] as num).toDouble(),
  lastUpdated: DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$$LeaderboardEntryImplToJson(
  _$LeaderboardEntryImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'displayName': instance.displayName,
  'profileImageUrl': instance.profileImageUrl,
  'grade': instance.grade,
  'rank': instance.rank,
  'totalScore': instance.totalScore,
  'averageAccuracy': instance.averageAccuracy,
  'totalBattlesWon': instance.totalBattlesWon,
  'winRate': instance.winRate,
  'lastUpdated': instance.lastUpdated.toIso8601String(),
};

_$RankingDataImpl _$$RankingDataImplFromJson(Map<String, dynamic> json) =>
    _$RankingDataImpl(
      rankingId: json['rankingId'] as String,
      rankingType: json['rankingType'] as String,
      grade: (json['grade'] as num).toInt(),
      entries: (json['entries'] as List<dynamic>)
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedDate: DateTime.parse(json['updatedDate'] as String),
    );

Map<String, dynamic> _$$RankingDataImplToJson(_$RankingDataImpl instance) =>
    <String, dynamic>{
      'rankingId': instance.rankingId,
      'rankingType': instance.rankingType,
      'grade': instance.grade,
      'entries': instance.entries,
      'updatedDate': instance.updatedDate.toIso8601String(),
    };

_$UserRankingImpl _$$UserRankingImplFromJson(Map<String, dynamic> json) =>
    _$UserRankingImpl(
      userId: json['userId'] as String,
      globalRank: (json['globalRank'] as num).toInt(),
      gradeRank: (json['gradeRank'] as num).toInt(),
      friendGroupRank: (json['friendGroupRank'] as num).toInt(),
      totalScore: (json['totalScore'] as num).toInt(),
      winRate: (json['winRate'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$UserRankingImplToJson(_$UserRankingImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'globalRank': instance.globalRank,
      'gradeRank': instance.gradeRank,
      'friendGroupRank': instance.friendGroupRank,
      'totalScore': instance.totalScore,
      'winRate': instance.winRate,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

_$BattleLeaderboardImpl _$$BattleLeaderboardImplFromJson(
  Map<String, dynamic> json,
) => _$BattleLeaderboardImpl(
  leaderboardId: json['leaderboardId'] as String,
  periodType: json['periodType'] as String,
  periodStart: DateTime.parse(json['periodStart'] as String),
  periodEnd: DateTime.parse(json['periodEnd'] as String),
  battleWinners: (json['battleWinners'] as List<dynamic>)
      .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  highestScorers: (json['highestScorers'] as List<dynamic>)
      .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$BattleLeaderboardImplToJson(
  _$BattleLeaderboardImpl instance,
) => <String, dynamic>{
  'leaderboardId': instance.leaderboardId,
  'periodType': instance.periodType,
  'periodStart': instance.periodStart.toIso8601String(),
  'periodEnd': instance.periodEnd.toIso8601String(),
  'battleWinners': instance.battleWinners,
  'highestScorers': instance.highestScorers,
};

_$ReadingLeaderboardImpl _$$ReadingLeaderboardImplFromJson(
  Map<String, dynamic> json,
) => _$ReadingLeaderboardImpl(
  leaderboardId: json['leaderboardId'] as String,
  periodType: json['periodType'] as String,
  periodStart: DateTime.parse(json['periodStart'] as String),
  periodEnd: DateTime.parse(json['periodEnd'] as String),
  topReaders: (json['topReaders'] as List<dynamic>)
      .map((e) => ReadingLeaderboardEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$ReadingLeaderboardImplToJson(
  _$ReadingLeaderboardImpl instance,
) => <String, dynamic>{
  'leaderboardId': instance.leaderboardId,
  'periodType': instance.periodType,
  'periodStart': instance.periodStart.toIso8601String(),
  'periodEnd': instance.periodEnd.toIso8601String(),
  'topReaders': instance.topReaders,
};

_$ReadingLeaderboardEntryImpl _$$ReadingLeaderboardEntryImplFromJson(
  Map<String, dynamic> json,
) => _$ReadingLeaderboardEntryImpl(
  userId: json['userId'] as String,
  displayName: json['displayName'] as String,
  profileImageUrl: json['profileImageUrl'] as String,
  totalReadingMinutes: (json['totalReadingMinutes'] as num).toInt(),
  passagesCompleted: (json['passagesCompleted'] as num).toInt(),
  averageComprehensionScore: (json['averageComprehensionScore'] as num)
      .toDouble(),
  rank: (json['rank'] as num).toInt(),
);

Map<String, dynamic> _$$ReadingLeaderboardEntryImplToJson(
  _$ReadingLeaderboardEntryImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'displayName': instance.displayName,
  'profileImageUrl': instance.profileImageUrl,
  'totalReadingMinutes': instance.totalReadingMinutes,
  'passagesCompleted': instance.passagesCompleted,
  'averageComprehensionScore': instance.averageComprehensionScore,
  'rank': instance.rank,
};
