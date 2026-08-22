import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/quiz_data.dart';
import '../providers/adaptive_provider.dart';
import '../providers/daily_bonus_provider.dart';
import '../providers/learning_timer_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/badge_provider.dart';
import '../providers/coin_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/purchased_items_provider.dart';
import '../providers/profile_avatar_provider.dart';
import 'package:shared_core/models/avatar_model.dart';
import 'package:shared_core/widgets/avatar_widget.dart';
import '../theme/app_theme.dart';
import 'package:shared_core/shared_core.dart' show characterStateProvider;
import '../data/kokugo_characters.dart';
import '../widgets/app_intro_dialog.dart';
import '../widgets/daily_bonus_dialog.dart';
import '../widgets/daily_mission_card.dart';
import '../widgets/timer_chip_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _timerEndHandled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runStartupDialogs());
  }

  /// 初回起動時に表示しうる複数のダイアログ（デイリーボーナス・アプリ紹介・
  /// アップデート通知）が同時に積み重なって出ないよう、1つずつ順番に
  /// 表示して閉じられるのを待ってから次を出す。
  Future<void> _runStartupDialogs() async {
    await _checkDailyBonus();
    if (!mounted) return;
    await _checkFirstLaunchIntro();
    if (!mounted) return;
    await _checkForUpdate();
  }

  /// 初回インストール後、最初にホーム画面に来たときだけアプリの使い方を説明する。
  /// 同じ内容は設定画面の「このアプリの使い方」からいつでも再表示できる。
  Future<void> _checkFirstLaunchIntro() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenIntro = prefs.getBool('has_seen_app_intro') ?? false;
    if (hasSeenIntro) return;
    await prefs.setBool('has_seen_app_intro', true);
    if (!mounted) return;
    await showAppIntroDialog(context);
  }

  Future<void> _checkForUpdate() async {
    const currentVersion = '1.4.0';
    final prefs = await SharedPreferences.getInstance();
    final lastSeen = prefs.getString('last_seen_version');
    if (lastSeen != currentVersion) {
      await prefs.setString('last_seen_version', currentVersion);
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Text('🎉', style: TextStyle(fontSize: 28)),
              SizedBox(width: 8),
              Flexible(
                child: Text('v1.4.0 にアップデート！',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('✨ 新機能',
                    style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
                SizedBox(height: 6),
                Text('• 読解力強化トレーニングを追加'),
                Text('• アバターアイコンを一新'),
                Text('• 書き順アニメーション表示を追加'),
                SizedBox(height: 12),
                Text('🔧 改善',
                    style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
                SizedBox(height: 6),
                Text('• アプリ内課金の価格表示・エラー表示を改善'),
                Text('• キャラクターのレベル別イラスト表示に対応'),
                Text('• アプリ名を「小学コレ！国語」に変更'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('とじる'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // タイマー終了検知（ref.listen はbuildの外でできないのでdidChangeDependenciesで監視）
  }

  Future<void> _checkDailyBonus() {
    final bonus = ref.read(dailyBonusProvider);
    if (bonus.claimedToday || bonus.todayBonus <= 0) return Future.value();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DailyBonusDialog(
        streak: bonus.bonusStreak + 1,
        bonusCoins: bonus.todayBonus,
        onClaim: () async {
          final coins = await ref.read(dailyBonusProvider.notifier).claim();
          await ref.read(coinProvider.notifier).addCoins(coins);
          if (mounted) Navigator.of(context).pop();
        },
      ),
    );
  }

  void _handleTimerExpired() {
    if (_timerEndHandled) return;
    _timerEndHandled = true;
    showTimerEndDialog(context).then((_) {
      ref.read(learningTimerProvider.notifier).stop();
      _timerEndHandled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final adaptive = ref.watch(adaptiveProvider);
    final badges = ref.watch(badgeProvider);
    final coins = ref.watch(coinProvider);
    final profileState = ref.watch(profileProvider);
    final currentProfile = profileState.currentProfile;
    final timer = ref.watch(learningTimerProvider);
    final charStates = ref.watch(characterStateProvider);
    final purchased = ref.watch(purchasedItemsProvider);
    final profileAvatarState = ref.watch(profileAvatarProvider);
    final profileAvatar = currentProfile != null
        ? allAvatars.firstWhere(
            (a) => a.id == profileAvatarState.getSelectedAvatar(currentProfile.id),
            orElse: () => allAvatars.first,
          )
        : null;

    // テーマ背景色
    final bgColors = purchased.selectedBgId != null
        ? bgThemeColors[purchased.selectedBgId]
        : null;
    final topColor = bgColors != null ? Color(bgColors[0]) : kPrimaryColor;
    final bottomColor = bgColors != null ? Color(bgColors[1]) : kPrimaryDark;

    // タイマー終了を検知
    if (timer.isExpired && !_timerEndHandled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _handleTimerExpired());
    }

    final hasBg = bgColors != null;
    final bgImagePath = hasBg ? 'assets/backgrounds/${purchased.selectedBgId}.jpg' : null;

    return Container(
      decoration: hasBg
          ? BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgImagePath!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withAlpha(20),
                  BlendMode.darken,
                ),
              ),
            )
          : null,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 110,
            pinned: true,
            backgroundColor: topColor,
            forceElevated: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [topColor, bottomColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 56, bottom: 14, right: 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '📚 小学コレ！国語',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (currentProfile != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        profileAvatar != null
                            ? AvatarImage(avatar: profileAvatar, size: 16)
                            : const Text('😊', style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${currentProfile.name}（${currentProfile.grade}年生）',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            actions: [
              // タイマーチップ（動作中のみ表示）
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: TimerChip(
                  onTap: () => Navigator.pushNamed(context, '/smart-menu'),
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('プロフィール変更'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/profile-selection');
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('保護者レポート'),
                    onTap: () {
                      Navigator.pushNamed(context, '/parent-report');
                    },
                  ),
                ],
              ),
            ],
          ),

          // セーフティネットバナー
          if (adaptive.strugglingCount >= 2)
            SliverToBoxAdapter(
              child: _SafetyNetBanner(
                count: adaptive.strugglingCount,
                onTap: () => Navigator.pushNamed(context, '/parent-report'),
              ),
            ),

          SliverToBoxAdapter(
            child: DailyMissionCard(
              streakDays: progress.streakDays,
              progress: progress,
              adaptive: adaptive,
              onStart: () {
                for (var g = 1; g <= 6; g++) {
                  for (final stage in getStagesForGrade(g)) {
                    if (!progress.isCleared(stage.grade, stage.stageNumber)) {
                      Navigator.of(context).pushNamed('/quest', arguments: stage);
                      return;
                    }
                  }
                }
              },
              onStartStage: (stage) {
                Navigator.of(context).pushNamed('/quest', arguments: stage);
              },
            ),
          ),
          // ── お任せメニューバナー ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/smart-menu'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8E44AD), Color(0xFF6C3483)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF8E44AD).withAlpha(60),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'おまかせ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              timer.isActive
                                  ? 'タイマー残り ${timer.displayTime} ・ AIがステージを提案中'
                                  : '難易度を選ぶだけ！AIが今日のステージを提案',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.white70),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _StatsRow(
              progress: progress,
              badgeCount: badges.earnedBadges.length,
              coinCount: coins.totalCoins,
              onBadgeTap: () => Navigator.pushNamed(context, '/badges'),
            ),
          ),
          const SliverToBoxAdapter(
            child: _RecentCharactersSection(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
      ),
    );
  }
}

// ─── セーフティネットバナー ───────────────────────────────────
class _SafetyNetBanner extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _SafetyNetBanner({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFC107)),
        ),
        child: Row(
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '苦手なステージが$count個あります。保護者レポートを確認してみよう！',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF856404),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF856404), size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final LearningProgress progress;
  final int badgeCount;
  final int coinCount;
  final VoidCallback? onBadgeTap;
  const _StatsRow({required this.progress, required this.badgeCount, required this.coinCount, this.onBadgeTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _StatCard(label: 'れんぞく', value: '${progress.streakDays}日',
              emoji: '🔥', color: const Color(0xFFE74C3C)),
          const SizedBox(width: 10),
          _StatCard(label: 'コイン', value: '$coinCount枚',
              emoji: '🪙', color: const Color(0xFFFFB81C)),
          const SizedBox(width: 10),
          _StatCard(label: 'バッジ', value: '$badgeCount個',
              emoji: '🏅', color: kAccentGreen, onTap: onBadgeTap),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;
  final Color color;
  final VoidCallback? onTap;
  const _StatCard({required this.label, required this.value, required this.emoji, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Recent Characters (unlocked) ────────────────────────────
class _RecentCharactersSection extends ConsumerWidget {
  const _RecentCharactersSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charStates = ref.watch(characterStateProvider);
    final unlocked = kKokugoCharacters
        .where((c) => charStates[c.id]?.isUnlocked ?? false)
        .take(4)
        .toList();
    if (unlocked.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('キャラクター', style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/characters'),
                child: const Text('すべて見る'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: unlocked.map((c) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/characters'),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kPrimaryColor.withAlpha(60)),
                    ),
                    child: Column(
                      children: [
                        c.imageAsset != null
                            ? SizedBox(
                                width: 36,
                                height: 36,
                                child: Image.asset(c.imageAsset!, fit: BoxFit.contain),
                              )
                            : Text(c.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 4),
                        Text(c.name,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
