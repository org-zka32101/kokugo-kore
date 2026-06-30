import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/adaptive_provider.dart';
import '../providers/badge_provider.dart';
import '../providers/coin_provider.dart';
import '../providers/daily_bonus_provider.dart';
import '../providers/learning_timer_provider.dart';
import '../providers/drawing_progress_provider.dart';
import '../providers/drawing_settings_provider.dart';
import '../providers/vocab_mastery_provider.dart';
import '../providers/grade_provider.dart';
import '../providers/premium_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/sound_provider.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.5, curve: Curves.easeIn)),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6, curve: Curves.elasticOut)),
    );
    _ctrl.forward();
    _load();
  }

  Future<void> _load() async {
    await Future.wait([
      ref.read(profileProvider.notifier).load(),
      ref.read(gradeProvider.notifier).load(),
      ref.read(progressProvider.notifier).load(),
      ref.read(badgeProvider.notifier).load(),
      ref.read(coinProvider.notifier).load(),
      ref.read(premiumProvider.notifier).load(),
      ref.read(soundProvider.notifier).load(),
      ref.read(drawingProgressProvider.notifier).load(),
      ref.read(drawingSettingsProvider.notifier).load(),
      ref.read(vocabMasteryProvider.notifier).load(),
      ref.read(dailyBonusProvider.notifier).load(),
      ref.read(adaptiveProvider.notifier).load(),
      ref.read(learningTimerProvider.notifier).load(),
      FirebaseService.signInAnonymously(),
    ]);
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    // バージョンアップ時にお知らせを表示（初回インストールは除く）
    const currentVersion = '1.1.0';
    final prefs = await SharedPreferences.getInstance();
    final lastVersion = prefs.getString('app_last_version');
    if (lastVersion != null && lastVersion != currentVersion) {
      if (mounted) await _showWhatsNew(context, currentVersion);
    }
    await prefs.setString('app_last_version', currentVersion);

    if (!mounted) return;
    final profiles = ref.read(profileProvider).profiles;
    final currentProfile = ref.read(profileProvider).currentProfileId;

    if (profiles.isEmpty) {
      Navigator.of(context).pushReplacementNamed('/profile-selection');
    } else if (currentProfile == null) {
      Navigator.of(context).pushReplacementNamed('/profile-selection');
    } else {
      final isFirst = ref.read(gradeProvider.notifier).isFirstLaunch;
      Navigator.of(context).pushReplacementNamed(
        isFirst ? '/onboarding' : '/home',
      );
    }
  }

  Future<void> _showWhatsNew(BuildContext context, String version) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            const Text('🎉', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            const Text(
              'アップデートしました！',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'v$version',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _WhatsNewItem('ことわざ・慣用句が各50問以上に増加'),
              _WhatsNewItem('ことばクイズが200語以上に増加'),
              _WhatsNewItem('各クイズが10問ラウンド制に変更'),
              _WhatsNewItem('選択肢の位置がランダムになりました'),
              _WhatsNewItem('漢字おぼえるタブを改善'),
              _WhatsNewItem('せってい画面にアプリの使い方を追加'),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'はじめる！',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryColor, kPrimaryDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 大きなアプリアイコン（真ん中）
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          'assets/logos/app_icon_512.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      '小学コレ！国語',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ひらがなから読解・作文まで',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WhatsNewItem extends StatelessWidget {
  final String text;
  const _WhatsNewItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('✅ ', style: TextStyle(fontSize: 13)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
