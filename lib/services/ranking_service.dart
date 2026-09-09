import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../models/ranking_model.dart';

/// ランキング機能を提供するサービス
class RankingService {
  static const String APP_PREFIX = 'kokugo-kore';
  final _db = FirebaseDatabase.instance;

  /// フィルター条件に基づいて学生ランキングデータを取得
  Future<List<StudentRankingData>> getStudentRankings(RankingFilter filter) async {
    // Fetch student data from Firebase Realtime DB
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
        final sortedKeys = (grouped.keys.toList()..sort()).reversed.toList();
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

  /// 学生データを取得（Firebase Realtime DB から実データを取得）
  Future<List<StudentRankingData>> _fetchStudentData() async {
    try {
      final snapshot = await _db
          .ref('$APP_PREFIX/rankings/students')
          .orderByChild('score')
          .limitToLast(100)
          .once();

      final students = <StudentRankingData>[];

      if (snapshot.snapshot.exists) {
        int rank = 1;
        final jsonList = <Map<String, dynamic>>[];

        // スナップショットからデータを抽出
        for (final child in snapshot.snapshot.children) {
          try {
            final json = Map<String, dynamic>.from(child.value as Map);
            jsonList.add(json);
          } catch (e) {
            debugPrint('❌ Error parsing student data: $e');
          }
        }

        // scoreの降順でソート
        jsonList.sort((a, b) => (b['score'] as int? ?? 0).compareTo(a['score'] as int? ?? 0));

        // ランクを付与して StudentRankingData に変換
        for (final json in jsonList) {
          try {
            students.add(StudentRankingData(
              studentId: json['studentId'] ?? 'unknown',
              studentName: json['studentName'] ?? '不明',
              score: json['score'] ?? 0,
              rank: rank++,
              startedAt: json['startedAt'] != null
                  ? DateTime.parse(json['startedAt'] as String)
                  : DateTime.now(),
              birthYear: json['birthYear'] ?? 2020,
              acquiredAt: json['acquiredAt'] != null
                  ? DateTime.parse(json['acquiredAt'] as String)
                  : DateTime.now(),
              currentGrade: json['currentGrade'] ?? 1,
            ));
          } catch (e) {
            debugPrint('❌ Error creating StudentRankingData: $e');
          }
        }
      }

      return students;
    } catch (e) {
      debugPrint('❌ Error fetching student data from Firebase: $e');
      // フォールバック：サンプルデータを返す
      return _getFallbackSampleData();
    }
  }

  /// フォールバック：サンプルデータ
  List<StudentRankingData> _getFallbackSampleData() {
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
    ];
  }
}
