/// ランキング関連のモデルクラス

/// 学生のランキングデータ
class StudentRankingData {
  final String studentId;
  final String studentName;
  final int score; // バッジ数またはポイント
  final int rank; // グループ内順位
  final DateTime startedAt;
  final int gradeLevel; // 学年（1-6など）
  final DateTime? acquiredAt; // 最後に獲得した日

  StudentRankingData({
    required this.studentId,
    required this.studentName,
    required this.score,
    required this.rank,
    required this.startedAt,
    required this.gradeLevel,
    this.acquiredAt,
  });

  @override
  String toString() =>
      'StudentRankingData(id: $studentId, name: $studentName, rank: $rank, score: $score)';
}

/// ランキング表示のフィルター設定
class RankingFilter {
  final RankingGroupBy groupBy;
  final DateTime? startDateRange;
  final int? specificGrade;

  RankingFilter({
    this.groupBy = RankingGroupBy.all,
    this.startDateRange,
    this.specificGrade,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingFilter &&
          runtimeType == other.runtimeType &&
          groupBy == other.groupBy &&
          startDateRange == other.startDateRange &&
          specificGrade == other.specificGrade;

  @override
  int get hashCode =>
      groupBy.hashCode ^ startDateRange.hashCode ^ specificGrade.hashCode;
}

/// ランキングのグループ化方法
enum RankingGroupBy {
  all,
  byGrade,
  byStartDate,
  byStartDateAndGrade,
}

extension RankingGroupByLabel on RankingGroupBy {
  String get label {
    switch (this) {
      case RankingGroupBy.all:
        return 'すべて';
      case RankingGroupBy.byGrade:
        return '学年別';
      case RankingGroupBy.byStartDate:
        return '開始月別';
      case RankingGroupBy.byStartDateAndGrade:
        return '学年×開始月';
    }
  }
}
