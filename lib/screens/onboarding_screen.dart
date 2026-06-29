import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/grade_provider.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF9E6), Color(0xFFFFE8A1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text('📚', style: TextStyle(fontSize: 72)),
              const SizedBox(height: 16),
              const Text(
                '国語コレ！',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'まず、なんねんせいか\nおしえてね！',
                style: TextStyle(fontSize: 18, color: kTextDark, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    for (int g = 1; g <= 6; g++) _GradeButton(grade: g),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeFeature extends StatelessWidget {
  final String emoji;
  final String title;
  final String desc;

  const _WelcomeFeature({
    required this.emoji,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 11,
                  color: kTextMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GradeButton extends ConsumerWidget {
  final int grade;
  const _GradeButton({required this.grade});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = gradeGroupOf(grade);
    final color = gradeColor(group);
    final labels = ['', '小1', '小2', '小3', '小4', '小5', '小6'];
    final emojis = ['', '🐣', '🐥', '🐤', '🦆', '🦅', '🦁'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: () async {
          await ref.read(gradeProvider.notifier).setGrade(grade);
          if (context.mounted) {
            await _showWelcomeGuide(context);
            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
        ),
        child: Row(
          children: [
            Text(emojis[grade], style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Text(
              labels[grade],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _showWelcomeGuide(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: const [
            Text('🎉', style: TextStyle(fontSize: 48)),
            SizedBox(height: 12),
            Text(
              'ようこそ！',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '国語コレ！は、\nひらがなから読解・作文までを\n楽しく学べるアプリです。',
                style: TextStyle(fontSize: 15, height: 1.6, color: kTextDark),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _WelcomeFeature(
                emoji: '💡',
                title: 'わかる',
                desc: '知識を一覧で確認\nひらがな・漢字などを学べます',
              ),
              SizedBox(height: 12),
              _WelcomeFeature(
                emoji: '❓',
                title: 'といて',
                desc: 'クイズで練習\n10問ずつチャレンジしましょう',
              ),
              SizedBox(height: 12),
              _WelcomeFeature(
                emoji: '🏅',
                title: 'ためる',
                desc: 'バッジやコイン\nがくしゅうで毎日増えます',
              ),
              SizedBox(height: 12),
              _WelcomeFeature(
                emoji: '🔥',
                title: 'つづける',
                desc: 'れんぞく記録\n毎日つづけるとレベルアップ',
              ),
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
}
