import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/models/ranking_model.dart';

void main() {
  group('RankingModel Tests', () {
    test('StudentRankingData creates instance correctly', () {
      final now = DateTime.now();
      final student = StudentRankingData(
        studentId: 'student_1',
        studentName: '田中 太郎',
        score: 15,
        rank: 1,
        startedAt: now,
        gradeLevel: 5,
        acquiredAt: now,
      );

      expect(student.studentId, 'student_1');
      expect(student.studentName, '田中 太郎');
      expect(student.score, 15);
      expect(student.rank, 1);
      expect(student.gradeLevel, 5);
      expect(student.acquiredAt, now);
    });

    test('StudentRankingData toString works', () {
      final student = StudentRankingData(
        studentId: 'student_1',
        studentName: '田中 太郎',
        score: 15,
        rank: 1,
        startedAt: DateTime(2026, 1, 15),
        gradeLevel: 5,
      );

      final string = student.toString();
      expect(string, contains('student_1'));
      expect(string, contains('田中 太郎'));
      expect(string, contains('rank: 1'));
      expect(string, contains('score: 15'));
    });

    test('RankingFilter creates instance correctly', () {
      final filter = RankingFilter(
        groupBy: RankingGroupBy.byGrade,
        specificGrade: 5,
      );

      expect(filter.groupBy, RankingGroupBy.byGrade);
      expect(filter.specificGrade, 5);
      expect(filter.startDateRange, isNull);
    });

    test('RankingFilter equality works', () {
      final filter1 = RankingFilter(
        groupBy: RankingGroupBy.byGrade,
        specificGrade: 5,
      );
      final filter2 = RankingFilter(
        groupBy: RankingGroupBy.byGrade,
        specificGrade: 5,
      );
      final filter3 = RankingFilter(
        groupBy: RankingGroupBy.byStartDate,
        specificGrade: 5,
      );

      expect(filter1, filter2);
      expect(filter1, isNot(filter3));
    });

    test('RankingFilter hash code works', () {
      final filter1 = RankingFilter(
        groupBy: RankingGroupBy.byGrade,
        specificGrade: 5,
      );
      final filter2 = RankingFilter(
        groupBy: RankingGroupBy.byGrade,
        specificGrade: 5,
      );

      expect(filter1.hashCode, filter2.hashCode);
    });

    test('RankingGroupBy.all label is correct', () {
      expect(RankingGroupBy.all.label, 'すべて');
    });

    test('RankingGroupBy.byGrade label is correct', () {
      expect(RankingGroupBy.byGrade.label, '学年別');
    });

    test('RankingGroupBy.byStartDate label is correct', () {
      expect(RankingGroupBy.byStartDate.label, '開始月別');
    });

    test('RankingGroupBy.byStartDateAndGrade label is correct', () {
      expect(
        RankingGroupBy.byStartDateAndGrade.label,
        '学年×開始月',
      );
    });

    test('StudentRankingData with minimal parameters', () {
      final student = StudentRankingData(
        studentId: 'student_1',
        studentName: '田中 太郎',
        score: 10,
        rank: 1,
        startedAt: DateTime(2026, 1, 1),
        gradeLevel: 5,
      );

      expect(student.acquiredAt, isNull);
    });

    test('RankingFilter with default groupBy', () {
      final filter = RankingFilter();

      expect(filter.groupBy, RankingGroupBy.all);
      expect(filter.startDateRange, isNull);
      expect(filter.specificGrade, isNull);
    });
  });
}
