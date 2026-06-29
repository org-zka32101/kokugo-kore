import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

class SummaryTrainingScreen extends ConsumerStatefulWidget {
  final String passageId;
  final String passageTitle;

  const SummaryTrainingScreen({
    super.key,
    required this.passageId,
    required this.passageTitle,
  });

  @override
  ConsumerState<SummaryTrainingScreen> createState() => _SummaryTrainingScreenState();
}

class _SummaryTrainingScreenState extends ConsumerState<SummaryTrainingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _selectedSummaryIndex;
  int? _selectedKeyword;
  bool _summaryAnswered = false;
  bool _keywordAnswered = false;

  final List<String> _summaryOptions = [
    'ひらがなは9世紀ごろに誕生し、女性や一般の人々が使い始めた、漢字から生まれた日本語の文字である。',
    'ひらがなは中国の漢字から生まれた複雑な文字で、現代でも学者しか使わない特別な文字である。',
    'ひらがなは20世紀に政府が作った文字で、漢字の代わりとして使われるようになった。',
    'ひらがなは子どもたちのために作られた文字で、大人は使わない簡単な文字である。',
  ];
  final int _correctSummaryIndex = 0;

  final List<Map<String, dynamic>> _keywordQuestions = [
    {
      'text': '「女文字」とはどういう意味ですか？',
      'choices': ['女性が好む文字', '女性が主に使っていた文字', '女性が作った文字', '女性にしか読めない文字'],
      'correct': 1,
    },
    {
      'text': '文章で「流れるような形」と言われるのはなぜですか？',
      'choices': ['水のように青い', '丸みを帯びた形をしているから', '書くのが速いから', '長い線が多いから'],
      'correct': 1,
    },
  ];
  int _currentKeywordQ = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('読解力強化'),
        backgroundColor: kPrimaryColor,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '📝 要約'),
            Tab(text: '🔑 表現'),
            Tab(text: '🗺️ 構造'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildExpressionTab(),
          _buildStructureTab(),
        ],
      ),
    );
  }

  // ─── 要約タブ ──────────────────────────────
  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('📝 要約問題', 'この記事の内容を正しく要約しているのはどれですか？'),
          const SizedBox(height: 20),

          if (!_summaryAnswered) ...[
            ...List.generate(_summaryOptions.length, (i) => _buildSummaryOption(i)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedSummaryIndex != null ? () => setState(() => _summaryAnswered = true) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('答える', style: TextStyle(color: Colors.white)),
              ),
            ),
          ] else ...[
            _buildSummaryResult(),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryOption(int index) {
    final isSelected = _selectedSummaryIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => setState(() => _selectedSummaryIndex = index),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.white,
            border: Border.all(
              color: isSelected ? kPrimaryColor : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isSelected ? kPrimaryColor : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(_summaryOptions[index], style: const TextStyle(fontSize: 13, height: 1.6)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryResult() {
    final isCorrect = _selectedSummaryIndex == _correctSummaryIndex;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
            border: Border.all(color: isCorrect ? Colors.green : Colors.red, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Text(isCorrect ? '✓' : '✗',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                      color: isCorrect ? Colors.green : Colors.red)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(isCorrect ? '正解です！上手に要約できています。' : '不正解です。記事全体の内容を確認しましょう。',
                    style: TextStyle(fontSize: 13, color: isCorrect ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('解説', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Text(
            '正しい要約は「誰が・いつ・何を・どのように」という4つの要素を含んでいます。\n'
            'ひらがなは①漢字から生まれ、②9世紀ごろ誕生し、③女性や一般の人々が使い始め、④日本語を書く文字として広まりました。',
            style: TextStyle(fontSize: 12, height: 1.7),
          ),
        ),
      ],
    );
  }

  // ─── 表現タブ ──────────────────────────────
  Widget _buildExpressionTab() {
    if (_currentKeywordQ >= _keywordQuestions.length) {
      return _buildExpressionComplete();
    }

    final q = _keywordQuestions[_currentKeywordQ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🔑 表現・語彙問題', '文章中の言葉の意味を考えましょう。'),
          const SizedBox(height: 20),

          // 問いの文章
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(q['text'] as String,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, height: 1.5)),
          ),
          const SizedBox(height: 20),

          ...List.generate(
            (q['choices'] as List).length,
            (i) => _buildKeywordOption(i, q['choices'][i] as String, q['correct'] as int),
          ),
          const SizedBox(height: 20),

          if (!_keywordAnswered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedKeyword != null
                    ? () {
                        if (_selectedKeyword == q['correct']) {
                          // 正解
                        }
                        setState(() => _keywordAnswered = true);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('答える', style: TextStyle(color: Colors.white)),
              ),
            )
          else
            ElevatedButton(
              onPressed: () => setState(() {
                _currentKeywordQ++;
                _selectedKeyword = null;
                _keywordAnswered = false;
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                _currentKeywordQ < _keywordQuestions.length - 1 ? '次の問題へ' : '完了',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKeywordOption(int index, String text, int correctIndex) {
    final isSelected = _selectedKeyword == index;
    Color borderColor = Colors.grey.shade300;
    Color? bgColor;

    if (_keywordAnswered) {
      if (index == correctIndex) {
        borderColor = Colors.green;
        bgColor = Colors.green.shade50;
      } else if (isSelected && index != correctIndex) {
        borderColor = Colors.red;
        bgColor = Colors.red.shade50;
      }
    } else if (isSelected) {
      borderColor = kPrimaryColor;
      bgColor = Colors.blue.shade50;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: _keywordAnswered ? null : () => setState(() => _selectedKeyword = index),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor ?? Colors.white,
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(String.fromCharCode(65 + index),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
              if (_keywordAnswered && index == correctIndex)
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpressionComplete() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text('表現問題クリア！', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('全問回答しました', style: TextStyle(color: kTextMuted)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() {
                _currentKeywordQ = 0;
                _selectedKeyword = null;
                _keywordAnswered = false;
              }),
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              child: const Text('もう一度', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 構造タブ ──────────────────────────────
  Widget _buildStructureTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🗺️ 文章構造の分析', '記事がどんな構成で書かれているかを確認しましょう。'),
          const SizedBox(height: 20),

          // 構造図
          _buildStructureMap(),
          const SizedBox(height: 24),

          // 段落ごとの役割
          const Text('各段落の役割', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildParagraphRoles(),
          const SizedBox(height: 24),

          // まとめ問題
          const Text('構造確認問題', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildStructureQuestion(),
        ],
      ),
    );
  }

  Widget _buildStructureMap() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildStructureNode('🌟 導入', 'ひらがなとは何か？', Colors.blue),
          _buildStructureArrow(),
          _buildStructureNode('📖 背景', 'なぜ生まれたか？', Colors.purple),
          _buildStructureArrow(),
          _buildStructureNode('🌱 誕生', 'いつ・誰が使い始めたか？', Colors.orange),
          _buildStructureArrow(),
          _buildStructureNode('✨ 特徴', 'どんな文字か？', Colors.green),
          _buildStructureArrow(),
          _buildStructureNode('📝 活用', 'どこで使われたか？', Colors.teal),
          _buildStructureArrow(),
          _buildStructureNode('🎯 まとめ', '現代のひらがな', Colors.red),
        ],
      ),
    );
  }

  Widget _buildStructureNode(String title, String content, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(width: 12),
          Expanded(child: Text(content, style: const TextStyle(fontSize: 12, color: kTextMuted))),
        ],
      ),
    );
  }

  Widget _buildStructureArrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(child: Icon(Icons.arrow_downward, color: Colors.grey.shade400, size: 18)),
    );
  }

  Widget _buildParagraphRoles() {
    final roles = [
      ('第1段落', '話題提示', '何について書くか示す'),
      ('第2-3段落', '根拠・理由', '誕生の背景を説明する'),
      ('第4段落', '詳細説明', '特徴を具体的に説明する'),
      ('第5段落', '展開', '活用場面を列挙する'),
      ('第6段落', 'まとめ', '現代における役割を述べる'),
    ];

    return Column(
      children: roles.map((r) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(r.$1, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(r.$2, style: const TextStyle(fontSize: 10, color: kPrimaryColor, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(r.$3, style: const TextStyle(fontSize: 11, color: kTextMuted))),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildStructureQuestion() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'この記事の文章構成を表す言葉はどれですか？',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...['起承転結', '問題提起→説明→まとめ', '時系列順', '比較対比'].asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.value == '問題提起→説明→まとめ' ? '✓ 正解です！' : '✗ もう一度考えてみましょう')),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(color: Colors.purple.shade100, borderRadius: BorderRadius.circular(4)),
                        child: Center(child: Text(String.fromCharCode(65 + e.key),
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple.shade700))),
                      ),
                      const SizedBox(width: 10),
                      Text(e.value, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: kTextMuted)),
      ],
    );
  }
}
