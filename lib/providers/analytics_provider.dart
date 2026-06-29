import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analytics_model.dart';
import '../services/firebase_realtime_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

final analyticsProvider = StateNotifierProvider<AnalyticsNotifier, ProgressAnalytics?>((ref) {
  return AnalyticsNotifier();
});

final learningPaceProvider = StateNotifierProvider<LearningPaceNotifier, LearningPaceData?>((ref) {
  return LearningPaceNotifier();
});

class AnalyticsNotifier extends StateNotifier<ProgressAnalytics?> {
  AnalyticsNotifier() : super(null);

  /// Save daily stats and update analytics
  Future<void> recordDailyStats(
    String userId, {
    required int questsCompleted,
    required int correctAnswers,
    required int totalAnswers,
    required int coinsEarned,
    required int studyMinutes,
    required Map<String, dynamic> categoryStats,
  }) async {
    try {
      final today = DateTime.now();
      final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final dailyStats = DailyStats(
        date: dateStr,
        questsCompleted: questsCompleted,
        correctAnswers: correctAnswers,
        totalAnswers: totalAnswers,
        coinsEarned: coinsEarned,
        studyMinutes: studyMinutes,
        categoryStats: categoryStats,
      );

      await FirebaseRealtimeAPI.saveDailyStats(userId, dailyStats);
    } catch (e) {
      debugPrint('❌ Error recording daily stats: $e');
      rethrow;
    }
  }

  /// Load analytics from Firebase
  Future<void> loadAnalytics(String userId) async {
    try {
      FirebaseRealtimeAPI.getAnalyticsStream(userId).listen((analytics) {
        state = analytics;
      });
    } catch (e) {
      debugPrint('❌ Error loading analytics: $e');
    }
  }

  /// Get accuracy for a specific category
  double getCategoryAccuracy(String categoryId) {
    if (state == null) return 0.0;
    final mastery = state!.categoryMastery[categoryId];
    if (mastery == null) return 0.0;
    return (mastery.correctCount / mastery.totalCount.clamp(1, double.maxFinite));
  }

  /// Calculate average accuracy for last N days
  Future<double> getAverageAccuracyLastDays(int days) async {
    if (state == null) return 0.0;

    final today = DateTime.now();
    double totalAccuracy = 0;
    int daysWithData = 0;

    for (int i = 0; i < days; i++) {
      final date = today.subtract(Duration(days: i));
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final dailyStats = state!.dailyHistory.where((s) => s.date == dateStr).firstOrNull;
      if (dailyStats != null && dailyStats.totalAnswers > 0) {
        totalAccuracy += (dailyStats.correctAnswers / dailyStats.totalAnswers);
        daysWithData++;
      }
    }

    return daysWithData > 0 ? totalAccuracy / daysWithData : 0.0;
  }

  /// Get total study time in hours for this week
  Future<int> getWeeklyStudyHours() async {
    if (state == null) return 0;
    int totalMinutes = 0;

    for (final stats in state!.dailyHistory) {
      totalMinutes += stats.studyMinutes;
    }

    return (totalMinutes / 60).toInt();
  }

  /// Get improvement trend (comparing last week to previous week)
  Future<double> getImprovementTrend() async {
    if (state == null) return 0.0;

    final lastWeekAvg = await getAverageAccuracyLastDays(7);
    final previousWeekAvg = await getAverageAccuracyLastDays(14);

    if (previousWeekAvg == 0) return 0.0;
    return ((lastWeekAvg - previousWeekAvg) / previousWeekAvg) * 100;
  }

  /// Predict mastery level based on recent practice
  double predictMasteryLevel(String categoryId) {
    if (state == null) return 0.0;
    final mastery = state!.categoryMastery[categoryId];
    if (mastery == null) return 0.0;

    final current = mastery.masteryLevel;
    final recent = mastery.recentScores.isNotEmpty
        ? (mastery.recentScores.reduce((a, b) => a + b) / mastery.recentScores.length) / 100
        : 0.0;

    return (current + recent) / 2;
  }
}

class LearningPaceNotifier extends StateNotifier<LearningPaceData?> {
  LearningPaceNotifier() : super(null);

  /// Analyze learning pace and provide recommendations
  Future<LearningPaceData> analyzeLearningPace(
    String userId,
    int averageQuestsPerDay,
    int inconsistencyDays,
  ) async {
    try {
      // Calculate recommended pace based on performance
      final recommendedDaily = _calculateRecommendedPace(averageQuestsPerDay);
      final consistencyScore = _calculateConsistencyScore(inconsistencyDays);

      final paceData = LearningPaceData(
        userId: userId,
        recommendedQuestsPerDay: recommendedDaily,
        averageQuestsPerDay: averageQuestsPerDay,
        inconsistencyDays: inconsistencyDays,
        studyConsistencyScore: consistencyScore,
        nextCheckDate: DateTime.now().add(const Duration(days: 7)),
      );

      state = paceData;
      return paceData;
    } catch (e) {
      debugPrint('❌ Error analyzing learning pace: $e');
      rethrow;
    }
  }

  /// Calculate recommended pace
  int _calculateRecommendedPace(int currentAverage) {
    // Recomm recommendation logic:
    // - If very consistent (20+ quests/day), increase to 25
    // - If moderate (10-19), maintain 15
    // - If low (< 10), recommend 10
    if (currentAverage >= 20) {
      return 25;
    } else if (currentAverage >= 10) {
      return 15;
    } else {
      return 10;
    }
  }

  /// Calculate consistency score (0.0 ~ 1.0)
  double _calculateConsistencyScore(int inconsistencyDays) {
    // Out of 30-day period, calculate consistency
    final consistency = ((30 - inconsistencyDays) / 30).clamp(0.0, 1.0);
    return consistency;
  }

  /// Get personalized recommendations based on pace
  List<String> getRecommendations(LearningPaceData pace) {
    final recommendations = <String>[];

    if (pace.studyConsistencyScore < 0.5) {
      recommendations.add('毎日の学習を心がけてみてください。');
    }

    if (pace.averageQuestsPerDay < pace.recommendedQuestsPerDay) {
      recommendations.add(
        '現在 ${pace.averageQuestsPerDay} 問/日ですが、${pace.recommendedQuestsPerDay} 問/日を目安に進めてみてください。',
      );
    }

    if (pace.studyConsistencyScore >= 0.8) {
      recommendations.add('毎日の学習が習慣化されており、素晴らしいです！');
    }

    return recommendations;
  }

  /// Load pace data from local storage
  Future<void> loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pacingString = prefs.getString('learning_pace_data');
      // TODO: Deserialize and set state
    } catch (e) {
      debugPrint('❌ Error loading pace data: $e');
    }
  }

  /// Save pace data to local storage
  Future<void> saveToPreferences(LearningPaceData pace) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // TODO: Serialize and save
      await prefs.setString('last_pace_check', DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('❌ Error saving pace data: $e');
    }
  }
}
