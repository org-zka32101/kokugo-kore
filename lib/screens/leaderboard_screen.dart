import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/leaderboard_privacy_provider.dart';
import '../providers/badge_provider.dart';
import '../providers/badge_metrics_provider.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load privacy settings and check leaderboard status
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(leaderboardPrivacyProvider.notifier).load();

      // Phase 2+ ユーザーがTOP10ランカーかチェック
      // 現在の実装ではモックデータを使用しているため、
      // 実際のランキングデータに基づいて判定する必要がある
      const userRank = 4; // あなたは4位（モックデータ）
      final isTopTenRanker = userRank <= 10;

      if (isTopTenRanker) {
        await ref.read(badgeMetricsProvider.notifier).setTopTenRanker(true);

        // 社交バッジをチェック
        final metricsState = ref.read(badgeMetricsProvider);
        await ref.read(badgeProvider.notifier).checkSocialBadges(
          friendInviteCount: metricsState.friendInvites,
          multiplayerWins: metricsState.multiplayerWins,
          isTopTenRanker: metricsState.isTopTenRanker,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final privacy = ref.watch(leaderboardPrivacyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ランキング'),
        backgroundColor: kPrimaryColor,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '🌍 グローバル'),
            Tab(text: '📍 学年別'),
            Tab(text: '👥 友人'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGlobalLeaderboard(privacy),
          _buildGradeLeaderboard(privacy),
          _buildFriendLeaderboard(privacy),
        ],
      ),
    );
  }

  /// グローバルランキング
  Widget _buildGlobalLeaderboard(LeaderboardPrivacyState privacy) {
    final rankings = [
      ('1位', '太郎', '小1', 4850, 95, true),
      ('2位', '花子', '小2', 4720, 92, false),
      ('3位', '次郎', '小1', 4650, 90, false),
      ('4位', 'あなた', '小1', 4200, 85, true), // 自分
      ('5位', '三郎', '小3', 4100, 88, false),
      ('6位', '四郎', '小2', 3950, 82, false),
      ('7位', '五郎', '小1', 3850, 80, false),
      ('8位', '六郎', '小4', 3700, 85, false),
      ('9位', '七郎', '小2', 3600, 78, false),
      ('10位', '八郎', '小1', 3500, 75, false),
    ];

    return _buildLeaderboardList(rankings, showYourRank: true, privacy: privacy);
  }

  /// 学年別ランキング
  Widget _buildGradeLeaderboard(LeaderboardPrivacyState privacy) {
    final rankings = [
      ('1位', '太郎', '小1', 4850, 95, true),
      ('2位', '次郎', '小1', 4650, 90, false),
      ('3位', 'あなた', '小1', 4200, 85, true), // 自分
      ('4位', '五郎', '小1', 3850, 80, false),
      ('5位', '八郎', '小1', 3500, 75, false),
    ];

    return Column(
      children: [
        // 学年選択
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildGradeTab('小1', true),
              _buildGradeTab('小2', false),
              _buildGradeTab('小3', false),
              _buildGradeTab('小4', false),
            ],
          ),
        ),
        Expanded(
          child: _buildLeaderboardList(rankings, showYourRank: true, privacy: privacy),
        ),
      ],
    );
  }

  Widget _buildGradeTab(String grade, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? kPrimaryColor : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        grade,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  /// 友人ランキング
  Widget _buildFriendLeaderboard(LeaderboardPrivacyState privacy) {
    final rankings = [
      ('1位', '太郎', '小1', 4850, 95, false),
      ('2位', '花子', '小2', 4720, 92, false),
      ('3位', 'あなた', '小1', 4200, 85, true), // 自分
      ('4位', '次郎', '小1', 4650, 90, false),
      ('5位', '三郎', '小3', 4100, 88, false),
      ('6位', '四郎', '小2', 3950, 82, false),
      ('7位', '五郎', '小1', 3850, 80, false),
      ('8位', '六郎', '小4', 3700, 85, false),
    ];

    return _buildLeaderboardList(rankings, showYourRank: true, privacy: privacy);
  }

  /// ランキングリスト
  Widget _buildLeaderboardList(
    List<(String, String, String, int, int, bool)> rankings, {
    required bool showYourRank,
    required LeaderboardPrivacyState privacy,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final (rank, name, grade, score, accuracy, isYou) = rankings[index];
        final rankNum = index + 1;

        // プライバシー設定に基づいて表示名を決定
        // 自分またはプライバシーがオフの場合は実名を表示
        // プライバシーがオンで他人の場合は匿名表示
        final displayName = (isYou || privacy.showNameInLeaderboard)
            ? name
            : 'ユーザー #${rankNum.toString().padLeft(3, '0')}';

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isYou ? Colors.blue.shade50 : Colors.white,
              border: Border.all(
                color: isYou ? kPrimaryColor : Colors.grey.shade300,
                width: isYou ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // ランク
                _buildRankBadge(rankNum),
                const SizedBox(width: 12),

                // ユーザー情報
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isYou) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'あなた',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            grade,
                            style: const TextStyle(
                              fontSize: 11,
                              color: kTextMuted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '正答率: $accuracy%',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // スコア
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      score.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'pts',
                      style: TextStyle(fontSize: 10, color: kTextMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ランクバッジ
  Widget _buildRankBadge(int rank) {
    final colors = [
      Colors.amber, // 1位
      Colors.grey, // 2位
      Colors.orange, // 3位
    ];

    final emoji = ['🥇', '🥈', '🥉'];

    Color color;
    String badge;

    if (rank <= 3) {
      color = colors[rank - 1];
      badge = emoji[rank - 1];
    } else {
      color = Colors.grey.shade400;
      badge = rank.toString();
    }

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: rank <= 3
            ? Text(badge, style: const TextStyle(fontSize: 22))
            : Text(
                rank.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
      ),
    );
  }
}
