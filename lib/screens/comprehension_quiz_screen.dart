import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

class ComprehensionQuizScreen extends ConsumerStatefulWidget {
  final String passageId;
  final String passageTitle;

  const ComprehensionQuizScreen({
    super.key,
    required this.passageId,
    required this.passageTitle,
  });

  @override
  ConsumerState<ComprehensionQuizScreen> createState() => _ComprehensionQuizScreenState();
}

class _ComprehensionQuizScreenState extends ConsumerState<ComprehensionQuizScreen> {
  int _currentQuestion = 0;
  int _correctCount = 0;
  String? _selectedAnswer;
  bool _answered = false;

  final List<Map<String, dynamic>> _quiz = [
    {
      'question': 'ひらがなはいつごろに誕生したと考えられていますか？',
      'choices': ['7世紀ごろ', '9世紀ごろ', '11世紀ごろ', '13世紀ごろ'],
      'correct': 1,
      'type': '選択問題',
    },
    {
      'question': 'ひらがなが最初に使った人たちは、誰ですか？',
      'choices': ['皇帝', '学者', '女性や一般の人々', '僧侶'],
      'correct': 2,
      'type': '選択問題',
    },
    {
      'question': 'ひらがなの特徴として述べられていないものはどれですか？',
      'choices': ['書きやすい', '複雑な形をしている', '発音がはっきりしている', '流れるような形'],
      'correct': 1,
      'type': '選択問題',
    },
    {
      'question': 'ひらがなが使われた場面として述べられていないものはどれですか？',
      'choices': ['物語や詩を書くのに', '手紙の文章で', '数学の計算に', '子どもの教育に'],
      'correct': 2,
      'type': '選択問題',
    },
    {
      'question': 'この記事で最も伝えたい考えは何ですか？',
      'choices': [
        'ひらがなは複雑な文字である',
        'ひらがなは日本語を書く時に大切な役割がある',
        'ひらがなは昔より使われていない',
        'ひらがなは女性のためだけの文字である',
      ],
      'correct': 1,
      'type': '記述問題',
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion >= _quiz.length) {
      return _buildResultScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('理解度クイズ'),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          // プログレス
          _buildProgressBar(),

          // クイズコンテンツ
          Expanded(
            child: _buildQuizContent(),
          ),
        ],
      ),
    );
  }

  /// プログレスバー
  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '問題 ${_currentQuestion + 1}/${_quiz.length}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                '${((_currentQuestion / _quiz.length) * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 12, color: kTextMuted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _currentQuestion / _quiz.length,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  /// クイズコンテンツ
  Widget _buildQuizContent() {
    final current = _quiz[_currentQuestion];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 問題タイプ
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: kPrimaryColor.withAlpha(25),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              current['type'] as String,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 問題文
          Text(
            current['question'] as String,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),

          // 選択肢
          if (!_answered) ...[
            ...List.generate(
              (current['choices'] as List).length,
              (index) => _buildChoiceButton(
                current['choices'][index] as String,
                index,
                current['correct'] as int,
              ),
            ),
          ] else ...[
            _buildAnswerResult(
              current['choices'][current['correct'] as int] as String,
              current['correct'] as int,
            ),
          ],

          const SizedBox(height: 24),

          // 次へボタン
          if (_answered)
            ElevatedButton(
              onPressed: _goToNextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _currentQuestion == _quiz.length - 1 ? '結果を見る' : '次の問題へ',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            )
          else
            ElevatedButton(
              onPressed: _selectedAnswer != null ? _submitAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '答える',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  /// 選択肢ボタン
  Widget _buildChoiceButton(String choice, int index, int correctIndex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => setState(() => _selectedAnswer = choice),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _selectedAnswer == choice ? Colors.blue.shade50 : Colors.white,
            border: Border.all(
              color: _selectedAnswer == choice ? kPrimaryColor : Colors.grey.shade300,
              width: _selectedAnswer == choice ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _selectedAnswer == choice ? kPrimaryColor : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  choice,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 答え結果
  Widget _buildAnswerResult(String correctAnswer, int correctIndex) {
    final isCorrect = _selectedAnswer == correctAnswer;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            isCorrect ? '✓' : '✗',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isCorrect ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? '正解です！' : '不正解です',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                ),
                if (!isCorrect) ...[
                  const SizedBox(height: 4),
                  Text(
                    '正解: $correctAnswer',
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 結果画面
  Widget _buildResultScreen() {
    final accuracy = ((_correctCount / _quiz.length) * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('クイズ結果'),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // スコア表示
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accuracy >= 70 ? Colors.green.shade50 : Colors.orange.shade50,
                  border: Border.all(
                    color: accuracy >= 70 ? Colors.green : Colors.orange,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$accuracy%',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: accuracy >= 70 ? Colors.green : Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '正答率',
                        style: TextStyle(
                          fontSize: 12,
                          color: accuracy >= 70 ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 結果メッセージ
              Text(
                accuracy >= 90
                    ? '素晴らしい！'
                    : accuracy >= 70
                        ? 'よくできました！'
                        : 'もう一度読んでみましょう',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Text(
                '${_correctCount}問中${_quiz.length}問正解しました',
                style: const TextStyle(fontSize: 14, color: kTextMuted),
              ),
              const SizedBox(height: 24),

              // 詳細
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildResultRow('正答数', '$_correctCount/${_quiz.length}'),
                    const Divider(),
                    _buildResultRow('正答率', '$accuracy%'),
                    const Divider(),
                    _buildResultRow('獲得ポイント', '${_correctCount * 10}pt'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'メニューに戻る',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _submitAnswer() {
    final current = _quiz[_currentQuestion];
    final correctAnswer = current['choices'][current['correct']];

    if (_selectedAnswer == correctAnswer) {
      _correctCount++;
    }

    setState(() => _answered = true);
  }

  void _goToNextQuestion() {
    setState(() {
      _currentQuestion++;
      _selectedAnswer = null;
      _answered = false;
    });
  }
}
