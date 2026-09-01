import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardPrivacyState {
  final bool showNameInLeaderboard;

  LeaderboardPrivacyState({
    this.showNameInLeaderboard = false, // デフォルトは名前を非公表
  });

  LeaderboardPrivacyState copyWith({
    bool? showNameInLeaderboard,
  }) {
    return LeaderboardPrivacyState(
      showNameInLeaderboard: showNameInLeaderboard ?? this.showNameInLeaderboard,
    );
  }
}

class LeaderboardPrivacyNotifier extends StateNotifier<LeaderboardPrivacyState> {
  LeaderboardPrivacyNotifier() : super(LeaderboardPrivacyState());

  static const _key = 'leaderboard_show_name';

  /// ローカルストレージから設定を復元
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final showName = prefs.getBool(_key) ?? false;
    state = LeaderboardPrivacyState(showNameInLeaderboard: showName);
  }

  /// 名前表示の設定をトグル
  Future<void> toggleNameVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !state.showNameInLeaderboard;
    await prefs.setBool(_key, newValue);
    state = state.copyWith(showNameInLeaderboard: newValue);
  }

  /// 名前表示の設定を指定値に変更
  Future<void> setNameVisibility(bool show) async {
    if (state.showNameInLeaderboard == show) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, show);
    state = state.copyWith(showNameInLeaderboard: show);
  }
}

final leaderboardPrivacyProvider =
    StateNotifierProvider<LeaderboardPrivacyNotifier, LeaderboardPrivacyState>(
  (ref) => LeaderboardPrivacyNotifier(),
);
