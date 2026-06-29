import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

class ReadingPassageScreen extends ConsumerStatefulWidget {
  final String passageId;
  final String title;

  const ReadingPassageScreen({
    super.key,
    required this.passageId,
    required this.title,
  });

  @override
  ConsumerState<ReadingPassageScreen> createState() => _ReadingPassageScreenState();
}

class _ReadingPassageScreenState extends ConsumerState<ReadingPassageScreen> {
  late ScrollController _scrollController;
  int _scrollPercentage = 0;

  final String _content = '''
ひらがなの歴史

ひらがなは、日本語を書くために、中国の文字である漢字から生まれた独自の文字です。

ひらがなが生まれた背景

古い時代の日本では、文字がありませんでした。中国から漢字が伝わってくると、日本人はこの漢字を使って日本語を書くようになりました。

しかし、漢字は複雑で、覚えるのに時間がかかります。そこで、人々は、漢字の一部を使って、もっと簡単に書ける文字を作ることにしました。これがひらがなです。

ひらがなの誕生

ひらがなは、9世紀ごろに誕生したと考えられています。最初に使ったのは、女性や一般の人々でした。当時、学問の世界では、漢文が使われ、ひらがなは「女文字」と呼ばれていました。

ひらがなの特徴

ひらがなには、いくつかの特徴があります。

1. 書きやすい
ひらがなは、漢字のように複雑な形をしていません。少ない線で書くことができます。

2. 発音がはっきりしている
ひらがなの文字は、それぞれ一つの音を表しています。

3. 流れるような形
ひらがなの文字は、丸みを帯びた形をしていて、流れるように見えます。

ひらがなの活躍

時代が進むと、ひらがなはもっと多くの場面で使われるようになりました。

• 物語や詩を書くのに使われました
• 手紙の文章で使われました
• やがて、子どもの教育にも使われるようになりました

現代のひらがな

今では、ひらがなは日本語を書く時に、とても大切な役割をしています。

子どもたちが学校で一番最初に習う文字は、ひらがなです。漢字を学ぶ時も、ひらがなで読み方を示します。

ひらがなは、日本文化を代表する文字の一つになりました。
''';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollPercentage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollPercentage() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    setState(() {
      _scrollPercentage = ((currentScroll / maxScroll) * 100).toInt().clamp(0, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('記事を読む'),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // プログレスバー
          LinearProgressIndicator(
            value: _scrollPercentage / 100,
            minHeight: 3,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),

          // スクロール可能なコンテンツ
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // タイトル
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 記事情報
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text('読む時間: 5分', style: TextStyle(fontSize: 11, color: kTextMuted)),
                      const SizedBox(width: 16),
                      Icon(Icons.trending_up, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      const Text('推奨学年: 小1-2', style: TextStyle(fontSize: 11, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 本文
                  Text(
                    _content,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.8,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 読了ボタン
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showCompletionDialog(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '読み終わった',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('📖 記事を読み終わりました'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'この記事について、理解度クイズに答えてください。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '💡 クイズに答えると、理解度が記録されます。',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('戻る'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to comprehension_quiz_screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('理解度クイズに進みます')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text(
              'クイズに答える',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
