import '../models/ranking_model.dart';

/// ランキング機能を提供するサービス
class RankingService {
  /// フィルター条件に基づいて学生ランキングデータを取得
  Future<List<StudentRankingData>> getStudentRankings(RankingFilter filter) async {
    // TODO: Firestore/APIから学生データを取得
    // 現在はモックデータを返す
    final students = await _fetchStudentData();

    // バッジ獲得数でソート
    students.sort((a, b) => b.score.compareTo(a.score));

    return students;
  }

  /// グループ化されたランキングデータを取得
  /// キー: グループ名（例：「5年生」「2026年9月」）
  /// 値: そのグループ内のランキング
  Future<Map<String, List<StudentRankingData>>> getGroupedRankings(
    RankingFilter filter,
  ) async {
    final rankings = await getStudentRankings(filter);
    return _groupRankings(rankings, filter.groupBy);
  }

  /// ランキングデータをグループ化
  Map<String, List<StudentRankingData>> _groupRankings(
    List<StudentRankingData> rankings,
    RankingGroupBy groupBy,
  ) {
    final Map<String, List<StudentRankingData>> grouped = {};

    switch (groupBy) {
      case RankingGroupBy.all:
        grouped['全体'] = rankings;

      case RankingGroupBy.byGrade:
        for (var student in rankings) {
          final key = '${student.currentGrade}年生';
          grouped.putIfAbsent(key, () => []);
          grouped[key]!.add(student);
        }
        // 学年順でソート
        final sortedKeys = grouped.keys.toList()
          ..sort((a, b) {
            final gradeA =
                int.tryParse(a.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
            final gradeB =
                int.tryParse(b.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
            return gradeA.compareTo(gradeB);
          });
        final sortedGrouped = <String, List<StudentRankingData>>{};
        for (var key in sortedKeys) {
          sortedGrouped[key] = grouped[key]!;
        }
        return sortedGrouped;

      case RankingGroupBy.byStartDate:
        for (var student in rankings) {
          final month = '${student.startedAt.year}年${student.startedAt.month}月';
          grouped.putIfAbsent(month, () => []);
          grouped[month]!.add(student);
        }
        // 開始月で降順にソート（最新順）
        final sortedKeys = grouped.keys.toList()..sort().reversed;
        final sortedGrouped = <String, List<StudentRankingData>>{};
        for (var key in sortedKeys) {
          sortedGrouped[key] = grouped[key]!;
        }
        return sortedGrouped;

      case RankingGroupBy.byStartDateAndGrade:
        for (var student in rankings) {
          final key =
              '${student.currentGrade}年生 (${student.startedAt.month}月開始)';
          grouped.putIfAbsent(key, () => []);
          grouped[key]!.add(student);
        }
    }

    return grouped;
  }

  /// 特定の学生のランキング順位を取得
  Future<int?> getStudentRank(String studentId, RankingFilter filter) async {
    final rankings = await getStudentRankings(filter);
    final index =
        rankings.indexWhere((student) => student.studentId == studentId);
    return index >= 0 ? index + 1 : null;
  }

  /// 学生データを取得（モックデータ）
  /// TODO: Firestore/APIから実際のデータを取得する
  Future<List<StudentRankingData>> _fetchStudentData() async {
    // シミュレーション：API呼び出しの遅延
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      StudentRankingData(
        studentId: 'student_1',
        studentName: '田中 太郎',
        score: 15,
        rank: 1,
        startedAt: DateTime(2026, 1, 15),
        birthYear: 2021,
        acquiredAt: DateTime(2026, 8, 20),
      ),
      StudentRankingData(
        studentId: 'student_2',
        studentName: '山田 花子',
        score: 13,
        rank: 2,
        startedAt: DateTime(2026, 2, 10),
        birthYear: 2021,
        acquiredAt: DateTime(2026, 8, 18),
      ),
      StudentRankingData(
        studentId: 'student_3',
        studentName: '佐藤 次郎',
        score: 12,
        rank: 3,
        startedAt: DateTime(2026, 1, 5),
        birthYear: 2022,
        acquiredAt: DateTime(2026, 8, 15),
      ),
      StudentRankingData(
        studentId: 'student_4',
        studentName: '鈴木 美咲',
        score: 11,
        rank: 4,
        startedAt: DateTime(2026, 3, 20),
        birthYear: 2021,
        acquiredAt: DateTime(2026, 8, 12),
      ),
      StudentRankingData(
        studentId: 'student_5',
        studentName: '小林 健太',
        score: 10,
        rank: 5,
        startedAt: DateTime(2026, 2, 28),
        birthYear: 2022,
        acquiredAt: DateTime(2026, 8, 10),
      ),
      StudentRankingData(
        studentId: 'student_6',
        studentName: '加藤 由美',
        score: 9,
        rank: 6,
        startedAt: DateTime(2026, 4, 1),
        birthYear: 2020,
        acquiredAt: DateTime(2026, 8, 8),
      ),
      StudentRankingData(
        studentId: 'student_7',
        studentName: '伊藤 大樹',
        score: 8,
        rank: 7,
        startedAt: DateTime(2026, 3, 10),
        birthYear: 2022,
        acquiredAt: DateTime(2026, 8, 5),
      ),
    ];
  }
}
