import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/models/badge_model.dart';
import '../models/badge_set_bonus_model.dart';
import '../providers/badge_provider.dart';
import '../theme/app_theme.dart';
import 'badge_detail_dialog.dart';

/// バッジフィルタータイプ
enum BadgeFilterType {
  all,      // すべて
  acquired, // 獲得済み
  missing,  // 未獲得
}

/// バッジ図鑑ウィジェット
class BadgeEncyclopedia extends ConsumerStatefulWidget {
  final List<BadgeModel> allBadges;

  const BadgeEncyclopedia({
    super.key,
    required this.allBadges,
  });

  @override
  ConsumerState<BadgeEncyclopedia> createState() => _BadgeEncyclopediaState();
}

class _BadgeEncyclopediaState extends ConsumerState<BadgeEncyclopedia> {
  late BadgeFilterType _selectedFilter;
  late String _selectedSet;
  late List<String> _setOptions;

  @override
  void initState() {
    super.initState();
    _selectedFilter = BadgeFilterType.all;
    _setOptions = ['すべてのセット', ...badgeSetBonuses.keys];
    _selectedSet = _setOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    final badgeState = ref.watch(badgeProvider);
    final earnedIds = badgeState.earnedBadges.map((e) => e.badge.id).toSet();

    // フィルタリング
    final filteredBadges = _filterBadges(earnedIds);

    // 統計情報
    final totalBadges = widget.allBadges.length;
    final acquiredCount = earnedIds.length;
    final acquiredPercent = totalBadges > 0 ? (acquiredCount / totalBadges * 100).toInt() : 0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー：統計情報
          _buildStatisticsSection(acquiredCount, totalBadges, acquiredPercent),

          // フィルター・ソートコントロール
          _buildFilterControls(),

          // バッジグリッド
          _buildBadgeGrid(filteredBadges, earnedIds),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(int acquired, int total, int percent) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor.withAlpha(240),
            kPrimaryColor.withAlpha(200),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'バッジ図鑑',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // プログレスバー
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: acquired / total,
                    minHeight: 8,
                    backgroundColor: Colors.white.withAlpha(100),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.green,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$acquired/$total',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '獲得率: $percent%',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // フィルタータイプ
          const Text(
            'フィルター',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: BadgeFilterType.values.map((filter) {
              final isSelected = _selectedFilter == filter;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_getFilterLabel(filter)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedFilter = filter);
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: kPrimaryColor,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // セット選択
          const Text(
            'セットで絞込',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _setOptions.map((setName) {
                final isSelected = _selectedSet == setName;
                final set = setName == 'すべてのセット'
                    ? null
                    : badgeSetBonuses[setName];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      set != null ? '${set.emoji} ${set.title}' : setName,
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedSet = setName);
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Colors.amber.shade300,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.black87 : Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeGrid(List<BadgeModel> badges, Set<String> earnedIds) {
    if (badges.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Text(
                _getEmptyMessage(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.85,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          final isAcquired = earnedIds.contains(badge.id);
          final acquiredAt = ref
              .watch(badgeProvider)
              .earnedBadges
              .firstWhere(
                (e) => e.badge.id == badge.id,
                orElse: () =>
                    EarnedBadge(badge: badge, earnedAt: DateTime.now()),
              )
              .earnedAt;

          return _buildBadgeCard(badge, isAcquired, acquiredAt);
        },
      ),
    );
  }

  Widget _buildBadgeCard(
    BadgeModel badge,
    bool isAcquired,
    DateTime acquiredAt,
  ) {
    final relatedSets = _getRelatedSetBonuses(badge.id);

    return GestureDetector(
      onTap: () {
        showBadgeDetailDialog(
          context,
          badge: badge,
          acquiredAt: isAcquired ? acquiredAt : null,
          isAcquired: isAcquired,
          relatedSetBonuses: relatedSets,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isAcquired ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAcquired ? Colors.green.shade300 : Colors.grey.shade300,
            width: isAcquired ? 2 : 1,
          ),
          boxShadow: isAcquired
              ? [
                  BoxShadow(
                    color: Colors.green.withAlpha(50),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // バッジコンテンツ
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // バッジアイコン
                Text(
                  badge.emoji,
                  style: TextStyle(
                    fontSize: 32,
                    color: isAcquired ? Colors.black87 : Colors.black38,
                  ),
                ),
                const SizedBox(height: 4),

                // バッジ名（省略）
                Text(
                  badge.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isAcquired ? Colors.black87 : Colors.black54,
                  ),
                ),
              ],
            ),

            // 未獲得時のオーバーレイ
            if (!isAcquired)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock,
                    color: Colors.white70,
                    size: 16,
                  ),
                ),
              ),

            // 獲得済みバッジ
            if (isAcquired)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<BadgeModel> _filterBadges(Set<String> earnedIds) {
    var filtered = widget.allBadges.toList();

    // フィルタータイプで絞込
    switch (_selectedFilter) {
      case BadgeFilterType.acquired:
        filtered =
            filtered.where((b) => earnedIds.contains(b.id)).toList();
        break;
      case BadgeFilterType.missing:
        filtered =
            filtered.where((b) => !earnedIds.contains(b.id)).toList();
        break;
      case BadgeFilterType.all:
        break;
    }

    // セットで絞込
    if (_selectedSet != 'すべてのセット') {
      final set = badgeSetBonuses[_selectedSet];
      if (set != null) {
        filtered = filtered
            .where((b) => set.requiredBadgeIds.contains(b.id))
            .toList();
      }
    }

    return filtered;
  }

  List<BadgeSetBonus> _getRelatedSetBonuses(String badgeId) {
    return badgeSetBonuses.values
        .where((set) => set.requiredBadgeIds.contains(badgeId))
        .toList();
  }

  String _getFilterLabel(BadgeFilterType filter) {
    switch (filter) {
      case BadgeFilterType.all:
        return 'すべて';
      case BadgeFilterType.acquired:
        return '獲得済み';
      case BadgeFilterType.missing:
        return '未獲得';
    }
  }

  String _getEmptyMessage() {
    switch (_selectedFilter) {
      case BadgeFilterType.acquired:
        return 'このセットで獲得済みのバッジはありません';
      case BadgeFilterType.missing:
        return 'このセットで未獲得のバッジはありません';
      case BadgeFilterType.all:
        return 'バッジがありません';
    }
  }
}
