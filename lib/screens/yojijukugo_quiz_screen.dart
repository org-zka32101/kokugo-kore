import 'package:flutter/material.dart';
import '../data/yojijukugo_data.dart';
import '../widgets/generic_quiz_widget.dart';

class YojijukugoQuizScreen extends StatelessWidget {
  const YojijukugoQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericQuizScreen(
      title: '四字熟語クイズ',
      emoji: '🎴',
      themeColor: const Color(0xFF8E44AD),
      allItems: yojijukugoItems,
      questionsPerRound: 10,
    );
  }
}
