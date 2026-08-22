import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/ad_service.dart';
import 'data/kana_data.dart';
import 'firebase_options.dart';
import 'models/quest_model.dart';
import 'screens/character_screen.dart';
import 'screens/home_screen.dart';
import 'screens/idiom_quiz_screen.dart';
import 'screens/kanji_list_screen.dart';
import 'screens/kana_list_screen.dart';
import 'screens/learn_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/proverb_quiz_screen.dart';
import 'screens/profile_selection_screen.dart';
import 'screens/quest_screen.dart';
import 'screens/result_screen.dart';
import 'screens/settings_screen.dart';
import 'package:shared_core/shared_core.dart'
    show characterStateProvider, coinProvider, CoinState, CoinNotifier, premiumProvider, PremiumState, PremiumNotifier, avatarProvider, CrossPromoService;
import 'providers/character_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/progress_provider.dart';
import 'providers/purchased_items_provider.dart';
import 'providers/profile_avatar_provider.dart';
import 'screens/shop_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/stage_select_screen.dart';
import 'screens/study_menu_screen.dart';
import 'screens/parent_report_screen.dart';
import 'screens/parent_dashboard_screen.dart';
import 'screens/child_profile_dashboard_screen.dart';
import 'screens/learning_analytics_screen.dart';
import 'screens/recommended_pace_screen.dart';
import 'screens/multiplayer_menu_screen.dart';
import 'screens/friend_invitation_screen.dart';
import 'screens/battle_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/badge_screen.dart';
import 'screens/reading_menu_screen.dart';
import 'screens/smart_menu_screen.dart';
import 'screens/yojijukugo_quiz_screen.dart';
import 'screens/synonym_antonym_quiz_screen.dart';
import 'screens/homophone_quiz_screen.dart';
import 'screens/grammar_quiz_screen.dart';
import 'screens/bushu_quiz_screen.dart';
import 'screens/haiku_quiz_screen.dart';
import 'screens/upgrade_screen.dart';
import 'screens/vocabulary_screen.dart';
import 'screens/writing_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/premium_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // エッジtoエッジ表示（SafeAreaで余白制御）
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await CrossPromoService.init();
  } catch (_) {}

  // AdMob 初期化
  await AdService.initialize();

  // テスト用設定: コイン初期値を999999に設定・全機能開放
  const bool isTestMode = false; // リリース版：本番機能のみ
  if (isTestMode) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_coins', 999999);
    await prefs.setBool('is_premium', true); // プレミアム有効化
    // 全ステージを開放
    await prefs.setInt('unlocked_stages', 100); // 全ステージ開放フラグ
  }

  runApp(ProviderScope(
    overrides: [
      // 国語コレのキャラクターノティファイアを注入
      characterStateProvider.overrideWith(CharacterNotifier.new),
    ],
    child: const KokugoKoreApp(),
  ));
}

class KokugoKoreApp extends ConsumerWidget {
  const KokugoKoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: '小学コレ！国語',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/profile-selection': (context) => const ProfileSelectionScreen(),
        '/home': (context) => const RootShell(),
        '/stages': (context) => const StageSelectScreen(),
        '/characters': (context) => const CharacterScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/upgrade': (context) => const UpgradeScreen(),
        '/parent-report': (context) => const ParentReportScreen(),
        '/smart-menu': (context) => const SmartMenuScreen(),
        '/yojijukugo-quiz': (context) => const YojijukugoQuizScreen(),
        '/synonym-antonym-quiz': (context) => const SynonymAntonymQuizScreen(),
        '/homophone-quiz': (context) => const HomophoneQuizScreen(),
        '/grammar-quiz': (context) => const GrammarQuizScreen(),
        '/bushu-quiz': (context) => const BushuQuizScreen(),
        '/haiku-quiz': (context) => const HaikuQuizScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/terms': (context) => const PrivacyPolicyScreen(),
        '/shop': (context) => const ShopScreen(),
        '/learn': (context) => const LearnScreen(),
        '/vocabulary': (context) => const PremiumGate(
              featureName: 'ことば',
              featureEmoji: '💬',
              child: VocabularyScreen(),
            ),
        '/writing': (context) => const WritingScreen(),
        '/kanji': (context) => const KanjiListScreen(),
        '/proverb-quiz': (context) => const PremiumGate(
              featureName: 'ことわざ',
              featureEmoji: '🏮',
              child: ProverbQuizScreen(),
            ),
        '/idiom-quiz': (context) => const PremiumGate(
              featureName: '慣用句',
              featureEmoji: '🏮',
              child: IdiomQuizScreen(),
            ),
        '/parent-dashboard': (context) => const ParentDashboardScreen(),
        '/multiplayer': (context) => const PremiumGate(
              featureName: 'マルチプレイ',
              featureEmoji: '⚔️',
              child: MultiplayerMenuScreen(),
            ),
        '/friend-invitation': (context) => const FriendInvitationScreen(),
        '/leaderboard': (context) => const PremiumGate(
              featureName: 'マルチプレイ',
              featureEmoji: '⚔️',
              child: LeaderboardScreen(),
            ),
        '/reading': (context) => const PremiumGate(
              featureName: '読解力強化',
              featureEmoji: '📖',
              child: ReadingMenuScreen(),
            ),
        '/badges': (context) => const BadgeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/quest') {
          final stage = settings.arguments as Stage;
          return MaterialPageRoute(
            builder: (_) => QuestScreen(stage: stage),
            settings: settings,
          );
        }
        if (settings.name == '/result') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => ResultScreen(
              result: args['result'] as QuestResult,
              stage: args['stage'] as Stage,
            ),
            settings: settings,
          );
        }
        if (settings.name == '/kana') {
          final kanaType = settings.arguments as KanaType;
          return MaterialPageRoute(
            builder: (_) => PremiumGate(
              featureName: 'ひらがな・カタカナ',
              featureEmoji: 'あ',
              child: KanaListScreen(kanaType: kanaType),
            ),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}

class RootShell extends ConsumerStatefulWidget {
  const RootShell({super.key});

  @override
  ConsumerState<RootShell> createState() => _RootShellState();
}

class _RootShellState extends ConsumerState<RootShell> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load persisted state for all stateful providers
      await ref.read(coinProvider.notifier).load();
      await ref.read(progressProvider.notifier).load();
      await ref.read(purchasedItemsProvider.notifier).load();
      await ref.read(profileAvatarProvider.notifier).load();
      await ref.read(avatarProvider.notifier).load();
      // Check character unlocks with loaded progress
      final progress = ref.read(progressProvider);
      await ref
          .read(characterStateProvider.notifier)
          .checkUnlocks(progress.clearedStageIds.length);
    });
  }

  static const _screens = [
    HomeScreen(),
    StudyMenuScreen(),
    CharacterScreen(),
    ShopScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        // 下部セーフエリア確保
        selectedFontSize: 11,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'まなぶ'),
          BottomNavigationBarItem(icon: Icon(Icons.face), label: 'キャラクター'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'ショップ'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'せってい'),
        ],
      ),
    );
  }
}
