import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

class ReadingMenuScreen extends ConsumerStatefulWidget {
  const ReadingMenuScreen({super.key});

  @override
  ConsumerState<ReadingMenuScreen> createState() => _ReadingMenuScreenState();
}

class _ReadingMenuScreenState extends ConsumerState<ReadingMenuScreen> {
  String _selectedDifficulty = 'all'; // all, basic, standard, advanced

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('読解力トレーニング'),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヒーローセクション
            _buildHeroSection(),

            // 難易度選択
            _buildDifficultySelector(),

            // 統計情報
            _buildStatisticsSection(),

            // 記事リスト
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '記事を選択',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildArticlesList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ヒーローセクション
  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryColor, kPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📚 読解力を強化しよう',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '様々なジャンルの記事を読んで、理解度を高めましょう',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '🎯 今月: 12記事 読了 | 平均正答率: 78%',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// 難易度セレクタ
  Widget _buildDifficultySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '難易度を選択',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDifficultyButton('すべて', 'all'),
                const SizedBox(width: 8),
                _buildDifficultyButton('初級', 'basic'),
                const SizedBox(width: 8),
                _buildDifficultyButton('中級', 'standard'),
                const SizedBox(width: 8),
                _buildDifficultyButton('上級', 'advanced'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyButton(String label, String value) {
    final isSelected = _selectedDifficulty == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedDifficulty = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  /// 統計情報
  Widget _buildStatisticsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _buildStatCard('読了数', '12', '記事'),
          _buildStatCard('読書時間', '4h', '42m'),
          _buildStatCard('正答率', '78%', '平均'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: kTextMuted),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: const TextStyle(fontSize: 10, color: kTextMuted),
          ),
        ],
      ),
    );
  }

  /// 記事リスト
  Widget _buildArticlesList() {
    final articles = [
      (
        'ひらがなの歴史',
        '初級',
        'ひらがなはいつ、どのようにして生まれたのでしょうか？',
        '5分',
        78,
        '民俗'
      ),
      (
        '漢字の成り立ち',
        '中級',
        '中国から来た漢字が、日本でどのように変わったかを学びます。',
        '8分',
        85,
        '歴史'
      ),
      (
        '言葉と文化',
        '上級',
        '日本語の特徴と文化的背景を深く探求します。',
        '10分',
        72,
        '文化'
      ),
      (
        'むかし話の力',
        '初級',
        '昔話がもつ教訓と現代への影響をみていきます。',
        '6分',
        81,
        '文学'
      ),
      (
        '読書の効果',
        '中級',
        '読書がもたらす脳への影響と学習効果について。',
        '7分',
        79,
        '科学'
      ),
      (
        '情報を読み解く',
        '上級',
        '複雑なテキストから正確な情報を抽出する方法。',
        '12分',
        68,
        'スキル'
      ),
    ];

    return Column(
      children: articles.map((article) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildArticleCard(
            article.$1,
            article.$2,
            article.$3,
            article.$4,
            article.$5,
            article.$6,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildArticleCard(
    String title,
    String difficulty,
    String description,
    String readingTime,
    int accuracy,
    String genre,
  ) {
    final diffColor = difficulty == '初級'
        ? Colors.green
        : difficulty == '中級'
            ? Colors.orange
            : Colors.red;

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to reading_passage_screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('「$title」を開きます')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // タイトルと難易度
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: diffColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    difficulty,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: diffColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 説明
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: kTextMuted, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            // ジャンル、読了時間、正答率
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    genre,
                    style: const TextStyle(fontSize: 10),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      readingTime,
                      style: const TextStyle(fontSize: 11, color: kTextMuted),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.trending_up, size: 14, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      '$accuracy%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
