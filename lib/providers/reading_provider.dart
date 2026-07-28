import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/reading_passage_model.dart';
import '../services/firebase_realtime_db.dart';

final currentReadingSessionProvider = StateNotifierProvider<ReadingSessionNotifier, ReadingSession?>((ref) {
  return ReadingSessionNotifier();
});

final readingAnalyticsProvider = StateNotifierProvider<ReadingAnalyticsNotifier, ReadingAnalytics?>((ref) {
  return ReadingAnalyticsNotifier();
});

final readingPassagesProvider = FutureProvider<List<ReadingPassage>>((ref) async {
  // TODO: Fetch passages from local data or Firebase
  return [];
});

final userReadingHistoryProvider = FutureProvider.family<List<ReadingSession>, String>((ref, userId) async {
  return FirebaseRealtimeAPI.getReadingHistory(userId);
});

class ReadingSessionNotifier extends StateNotifier<ReadingSession?> {
  ReadingSessionNotifier() : super(null);

  /// Start a new reading session
  Future<void> startReadingSession(String userId, String passageId) async {
    try {
      final session = ReadingSession(
        sessionId: const Uuid().v4(),
        userId: userId,
        passageId: passageId,
        startedDate: DateTime.now(),
        completedDate: null,
        readingDurationSeconds: 0,
        answeredQuestionIds: [],
        answerCorrectness: [],
        comprehensionScore: 0.0,
        isCompleted: false,
      );

      state = session;
    } catch (e) {
      debugPrint('❌ Error starting reading session: $e');
      rethrow;
    }
  }

  /// Record a question answer
  Future<void> recordAnswer(String questionId, bool isCorrect) async {
    try {
      if (state == null) return;

      final updated = ReadingSession(
        sessionId: state!.sessionId,
        userId: state!.userId,
        passageId: state!.passageId,
        startedDate: state!.startedDate,
        completedDate: state!.completedDate,
        readingDurationSeconds: state!.readingDurationSeconds,
        answeredQuestionIds: [...state!.answeredQuestionIds, questionId],
        answerCorrectness: [...state!.answerCorrectness, isCorrect],
        comprehensionScore: state!.comprehensionScore,
        isCompleted: state!.isCompleted,
      );

      state = updated;
    } catch (e) {
      debugPrint('❌ Error recording answer: $e');
      rethrow;
    }
  }

  /// Complete reading session
  Future<void> completeSession(double comprehensionScore) async {
    try {
      if (state == null) return;

      final updated = ReadingSession(
        sessionId: state!.sessionId,
        userId: state!.userId,
        passageId: state!.passageId,
        startedDate: state!.startedDate,
        completedDate: DateTime.now(),
        readingDurationSeconds: DateTime.now().difference(state!.startedDate).inSeconds,
        answeredQuestionIds: state!.answeredQuestionIds,
        answerCorrectness: state!.answerCorrectness,
        comprehensionScore: comprehensionScore,
        isCompleted: true,
      );

      await FirebaseRealtimeAPI.saveReadingSession(state!.userId, updated);
      state = updated;
    } catch (e) {
      debugPrint('❌ Error completing session: $e');
      rethrow;
    }
  }

  /// Calculate comprehension score
  double calculateComprehensionScore() {
    if (state == null || state!.answerCorrectness.isEmpty) return 0.0;

    final correct = state!.answerCorrectness.where((a) => a).length;
    return (correct / state!.answerCorrectness.length) * 100;
  }

  /// Get reading duration in minutes
  int getReadingDurationMinutes() {
    if (state == null) return 0;
    return (state!.readingDurationSeconds / 60).toInt();
  }
}

class ReadingAnalyticsNotifier extends StateNotifier<ReadingAnalytics?> {
  ReadingAnalyticsNotifier() : super(null);

  /// Load reading analytics from Firebase
  Future<void> loadAnalytics(String userId) async {
    try {
      FirebaseRealtimeAPI.getReadingAnalyticsStream(userId).listen((analytics) {
        state = analytics;
      });
    } catch (e) {
      debugPrint('❌ Error loading reading analytics: $e');
    }
  }

  /// Update reading analytics
  Future<void> updateAnalytics(
    String userId, {
    required int passagesRead,
    required double avgComprehensionScore,
    required int totalReadingMinutes,
  }) async {
    try {
      if (state == null) return;

      final updated = ReadingAnalytics(
        userId: userId,
        totalPassagesRead: passagesRead,
        averageComprehensionScore: avgComprehensionScore,
        totalReadingMinutes: totalReadingMinutes,
        difficultyDistribution: state!.difficultyDistribution,
        favoritedGenres: state!.favoritedGenres,
        lastReadingDate: DateTime.now(),
      );

      state = updated;
    } catch (e) {
      debugPrint('❌ Error updating analytics: $e');
      rethrow;
    }
  }

  /// Get average reading speed (characters per minute)
  Future<int> getReadingSpeed() async {
    if (state == null) return 0;
    // This would require passage character count data
    // Placeholder for now
    return 150; // Average reading speed in CPM
  }

  /// Get reading difficulty level distribution
  Map<String, int> getDifficultyDistribution() {
    if (state == null) return {};
    return state!.difficultyDistribution.cast<String, int>();
  }

  /// Get reading level assessment
  String getReadingLevelAssessment() {
    if (state == null) return '不明';

    final avgScore = state!.averageComprehensionScore;
    if (avgScore >= 90) return '上級';
    if (avgScore >= 70) return '中級';
    if (avgScore >= 50) return '初級';
    return '初心者';
  }

  /// Get reading recommendations based on performance
  List<String> getReadingRecommendations() {
    if (state == null) return [];

    final recommendations = <String>[];
    final avgScore = state!.averageComprehensionScore;

    if (avgScore < 60) {
      recommendations.add('「初級」レベルの記事から始めてみてください。');
    }

    if (state!.difficultyDistribution['advanced'] == null || ((state!.difficultyDistribution['advanced'] as int?) ?? 0) == 0) {
      recommendations.add('難しい記事にも挑戦して、読解力を伸ばしましょう。');
    }

    if ((state!.totalReadingMinutes ~/ 60) < 5) {
      recommendations.add('毎日の読書習慣をつけることが大切です。');
    }

    return recommendations;
  }

  /// Track favorite genres
  void addFavoriteGenre(String genre) {
    if (state == null) return;

    final updated = state!.favoritedGenres.toSet();
    updated.add(genre);

    state = ReadingAnalytics(
      userId: state!.userId,
      totalPassagesRead: state!.totalPassagesRead,
      averageComprehensionScore: state!.averageComprehensionScore,
      totalReadingMinutes: state!.totalReadingMinutes,
      difficultyDistribution: state!.difficultyDistribution,
      favoritedGenres: updated.toList(),
      lastReadingDate: state!.lastReadingDate,
    );
  }
}
