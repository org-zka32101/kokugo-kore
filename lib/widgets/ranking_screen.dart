import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ranking_model.dart';
import '../providers/ranking_provider.dart';
import '../theme/app_theme.dart';

/// ランキング画面
class RankingScreen extends ConsumerWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(rankingFilterProvider);
    final rankedByGroup = ref.watch(rankedByGroupProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ランキング'),
        elevation: 0,
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // フィルタータブ
          _buildFilterTabs(context, ref, filter),

          // ランキング表示
          Expanded(
            child: rankedByGroup.when(
              data: (grouped) => _buildRankingList(context, grouped),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Text('エラーが発生しました: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// フィルタータブを構築
  Widget _buildFilterTabs(
    BuildContext context,
    WidgetRef ref,
    RankingFilter filter,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            _buildFilterChip(
              context,
              ref,
              RankingGroupBy.all,
              filter.groupBy,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context,
              ref,
              RankingGroupBy.byGrade,
              filter.groupBy,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context,
              ref,
              RankingGroupBy.byStartDate,
              filter.groupBy,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context,
              ref,
              RankingGroupBy.byStartDateAndGrade,
              filter.groupBy,
            ),
          ],
        ),
      ),
    );
  }

  /// フィルタームチップを構築
  Widget _buildFilterChip(
    BuildContext context,
    WidgetRef ref,
    RankingGroupBy groupBy,
    RankingGroupBy current,
  ) {
    final isSelected = groupBy == current;

    return FilterChip(
      label: Text(groupBy.label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          ref.read(rankingFilterProvider.notifier).state =
              RankingFilter(groupBy: groupBy);
        }
      },
      selectedColor: kPrimaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected ? kPrimaryColor : Colors.grey.shade300,
      ),
      backgroundColor: Colors.transparent,
    );
  }

  /// ランキングリストを構築
  Widget _buildRankingList(
    BuildContext context,
    Map<String, List<StudentRankingData>> grouped,
  ) {
    if (grouped.isEmpty) {
      return const Center(
        child: Text('ランキングデータがありません'),
      );
    }

    return ListView.builder(
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final groupName = grouped.keys.elementAt(index);
        final students = grouped[groupName]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // グループヘッダー
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                groupName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // ランキングタイル
            ...students.asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final student = entry.value;
              return _buildRankingTile(context, rank, student);
            }),

            const Divider(height: 24),
          ],
        );
      },
    );
  }

  /// ランキングタイルを構築
  Widget _buildRankingTile(
    BuildContext context,
    int rank,
    StudentRankingData student,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 順位バッジ
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getRankColor(rank),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _getRankColor(rank).withAlpha(100),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // 学生情報
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.studentName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${student.currentGrade}年生 • ${student.startedAt.month}月開始',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // スコア
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'バッジ',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${student.score}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 順位に応じた色を取得
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // 金
      case 2:
        return const Color(0xFFC0C0C0); // 銀
      case 3:
        return const Color(0xFFCD7F32); // 銅
      default:
        return Colors.grey.shade500;
    }
  }
}
