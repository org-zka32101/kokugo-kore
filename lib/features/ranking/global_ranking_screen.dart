import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';

/// グローバル・教科別ランキング表示画面（Phase 4.3）
class GlobalRankingScreen extends ConsumerStatefulWidget {
  const GlobalRankingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GlobalRankingScreen> createState() =>
      _GlobalRankingScreenState();
}

class _GlobalRankingScreenState extends ConsumerState<GlobalRankingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ランキング'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '全教科'),
            Tab(text: '国語'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGlobalTab(context, ref),
          _buildSubjectTab(context, ref, 'japanese'),
        ],
      ),
    );
  }

  /// グローバルランキングタブ
  Widget _buildGlobalTab(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, _) {
        ref.watch(globalRankingProvider).when(
          data: (state) {
            return _RankingListView(
              title: '全教科合計スコア',
              entries: state.entries,
              isLoading: state.isLoading,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('エラーが発生しました: $error'),
          ),
        );

        return const SizedBox.shrink();
      },
    );
  }

  /// 教科別ランキングタブ
  Widget _buildSubjectTab(
    BuildContext context,
    WidgetRef ref,
    String subject,
  ) {
    return ref.watch(subjectRankingStreamProvider(subject)).when(
      data: (entries) {
        return _RankingListView(
          title: '国語スコア',
          entries: entries
              .map((e) => GlobalRankingEntry(
                    userId: e.userId,
                    username: e.username,
                    totalScore: e.score,
                    globalRank: e.subjectRank,
                    percentile: e.percentile,
                    lastUpdated: e.lastUpdated,
                  ))
              .toList(),
          isLoading: false,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('エラーが発生しました: $error'),
      ),
    );
  }
}

/// ランキング一覧表示ウィジェット
class _RankingListView extends StatelessWidget {
  final String title;
  final List<GlobalRankingEntry> entries;
  final bool isLoading;

  const _RankingListView({
    required this.title,
    required this.entries,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (entries.isEmpty) {
      return const Center(
        child: Text('ランキングデータがありません'),
      );
    }

    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _RankingTile(
          rank: entry.globalRank,
          username: entry.username,
          score: entry.totalScore,
          percentile: entry.percentile,
          isHighlight: index == 0, // 1位をハイライト
        );
      },
    );
  }
}

/// ランキング 1 件表示タイル
class _RankingTile extends StatelessWidget {
  final int rank;
  final String username;
  final int score;
  final double percentile;
  final bool isHighlight;

  const _RankingTile({
    required this.rank,
    required this.username,
    required this.score,
    required this.percentile,
    required this.isHighlight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isHighlight ? Colors.amber[50] : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRankColor(rank),
          child: Text(
            '$rank',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(username),
        subtitle: Text(
          'スコア: $score | 上位 ${percentile.toStringAsFixed(1)}%',
        ),
        trailing: isHighlight
            ? const Icon(Icons.star, color: Colors.amber)
            : null,
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[400]!;
      default:
        return Colors.blue;
    }
  }
}
