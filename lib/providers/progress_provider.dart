import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _clearedPrefix = 'stage_cleared_';
const _streakKey = 'streak_count';
const _lastStudyKey = 'last_study_date';
const _totalCorrectKey = 'total_correct';
const _totalKanjiKey = 'total_kanji_correct';
const _totalReadingKey = 'total_reading_correct';
const _maxClearedKey = 'max_stage_cleared';
const _perfectStageKey = 'perfect_stage_count';

class LearningProgress {
  final Set<String> clearedStageIds;
  final int streakDays;
  final DateTime? lastStudyDate;
  final int totalCorrect;
  final int totalKanjiCorrect;
  final int totalReadingCorrect;
  final int maxStageCleared;
  final int perfectStageCount;

  const LearningProgress({
    required this.clearedStageIds,
    required this.streakDays,
    this.lastStudyDate,
    required this.totalCorrect,
    required this.totalKanjiCorrect,
    required this.totalReadingCorrect,
    required this.maxStageCleared,
    required this.perfectStageCount,
  });

  LearningProgress copyWith({
    Set<String>? clearedStageIds,
    int? streakDays,
    DateTime? lastStudyDate,
    int? totalCorrect,
    int? totalKanjiCorrect,
    int? totalReadingCorrect,
    int? maxStageCleared,
    int? perfectStageCount,
  }) {
    return LearningProgress(
      clearedStageIds: clearedStageIds ?? this.clearedStageIds,
      streakDays: streakDays ?? this.streakDays,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalKanjiCorrect: totalKanjiCorrect ?? this.totalKanjiCorrect,
      totalReadingCorrect: totalReadingCorrect ?? this.totalReadingCorrect,
      maxStageCleared: maxStageCleared ?? this.maxStageCleared,
      perfectStageCount: perfectStageCount ?? this.perfectStageCount,
    );
  }

  bool isCleared(int grade, int stageNumber) {
    return clearedStageIds.contains('g${grade}_s$stageNumber');
  }

  static const empty = LearningProgress(
    clearedStageIds: {},
    streakDays: 0,
    totalCorrect: 0,
    totalKanjiCorrect: 0,
    totalReadingCorrect: 0,
    maxStageCleared: 0,
    perfectStageCount: 0,
  );
}

class ProgressNotifier extends Notifier<LearningProgress> {
  @override
  LearningProgress build() => LearningProgress.empty;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_clearedPrefix)).toSet();
    final cleared = keys.map((k) => k.replaceFirst(_clearedPrefix, '')).toSet();

    final lastStudyStr = prefs.getString(_lastStudyKey);
    DateTime? lastStudy;
    if (lastStudyStr != null) {
      lastStudy = DateTime.tryParse(lastStudyStr);
    }

    state = LearningProgress(
      clearedStageIds: cleared,
      streakDays: prefs.getInt(_streakKey) ?? 0,
      lastStudyDate: lastStudy,
      totalCorrect: prefs.getInt(_totalCorrectKey) ?? 0,
      totalKanjiCorrect: prefs.getInt(_totalKanjiKey) ?? 0,
      totalReadingCorrect: prefs.getInt(_totalReadingKey) ?? 0,
      maxStageCleared: prefs.getInt(_maxClearedKey) ?? 0,
      perfectStageCount: prefs.getInt(_perfectStageKey) ?? 0,
    );
  }

  Future<void> recordResult({
    required int grade,
    required int stageNumber,
    required int correct,
    required int total,
    required bool isKanji,
    required bool isPerfect,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final stageId = 'g${grade}_s$stageNumber';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // ストリーク更新
    int streak = state.streakDays;
    final lastStudy = state.lastStudyDate;
    if (lastStudy == null) {
      streak = 1;
    } else {
      final lastDay = DateTime(lastStudy.year, lastStudy.month, lastStudy.day);
      final diff = today.difference(lastDay).inDays;
      if (diff == 0) {
        // 同日は変化なし
      } else if (diff == 1) {
        streak += 1;
      } else {
        streak = 1;
      }
    }

    final newCleared = {...state.clearedStageIds, stageId};
    final newTotal = state.totalCorrect + correct;
    final newKanji = state.totalKanjiCorrect + (isKanji ? correct : 0);
    final newReading = state.totalReadingCorrect + (isKanji ? 0 : correct);
    final newMax = stageNumber > state.maxStageCleared ? stageNumber : state.maxStageCleared;
    final newPerfect = isPerfect ? state.perfectStageCount + 1 : state.perfectStageCount;

    await prefs.setBool('$_clearedPrefix$stageId', true);
    await prefs.setInt(_streakKey, streak);
    await prefs.setString(_lastStudyKey, today.toIso8601String());
    await prefs.setInt(_totalCorrectKey, newTotal);
    await prefs.setInt(_totalKanjiKey, newKanji);
    await prefs.setInt(_totalReadingKey, newReading);
    await prefs.setInt(_maxClearedKey, newMax);
    await prefs.setInt(_perfectStageKey, newPerfect);

    state = state.copyWith(
      clearedStageIds: newCleared,
      streakDays: streak,
      lastStudyDate: today,
      totalCorrect: newTotal,
      totalKanjiCorrect: newKanji,
      totalReadingCorrect: newReading,
      maxStageCleared: newMax,
      perfectStageCount: newPerfect,
    );
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    final keysToRemove = prefs.getKeys()
        .where((k) =>
            k.startsWith(_clearedPrefix) ||
            k == _streakKey ||
            k == _lastStudyKey ||
            k == _totalCorrectKey ||
            k == _totalKanjiKey ||
            k == _totalReadingKey ||
            k == _maxClearedKey ||
            k == _perfectStageKey)
        .toList();
    for (final k in keysToRemove) {
      await prefs.remove(k);
    }
    state = LearningProgress.empty;
  }
}

final progressProvider =
    NotifierProvider<ProgressNotifier, LearningProgress>(ProgressNotifier.new);
