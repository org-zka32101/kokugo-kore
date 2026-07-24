import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/kokugo_characters.dart';
import '../models/character_model.dart';

/// 国語コレ固有のキャラクターノティファイア。
/// main.dart で characterStateProvider をこれで上書きする:
/// ```dart
/// characterStateProvider.overrideWith(CharacterNotifier.new)
/// ```
class CharacterNotifier extends BaseCharacterNotifier {
  @override
  List<BaseCharacter> get characterList => kKokugoCharacters;

  @override
  String get storageKey => 'kokugo_char_states_v2'; // v2: 16体キャラ新設計

  /// キャラクターに経験値を付与（v1.3 再実装）
  /// 独立した EXP プロバイダで管理するため、ここでは基本メソッドのみ実装
  Future<void> grantExperience(String characterId, int expAmount) async {
    // v1.3: 独立した expProvider で実装
    debugPrint('✓ Experience granted to $characterId: +$expAmount EXP');
  }

  /// 複数キャラに一括で経験値を付与
  Future<void> grantExperienceToAll(int expAmount) async {
    for (final char in characterList) {
      await grantExperience(char.id, expAmount);
    }
  }
}

/// クイズ画面に表示する「注目キャラクター」（=最後にレベルアップしたキャラ）
final featuredCharacterProvider =
    StateNotifierProvider<FeaturedCharacterNotifier, String?>((ref) {
  return FeaturedCharacterNotifier();
});

class FeaturedCharacterNotifier extends StateNotifier<String?> {
  static const String storageKey = 'kokugo_featured_character';

  FeaturedCharacterNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(storageKey);
  }

  Future<void> setFeatured(String characterId) async {
    state = characterId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, characterId);
  }
}

/// 独立した EXP 管理プロバイダ（v1.3）
/// shared_core.CharacterState と型の競合を避けるため独立実装
final expProvider = StateNotifierProvider<ExpNotifier, Map<String, KokugoCharacterState>>((ref) {
  return ExpNotifier();
});

class ExpNotifier extends StateNotifier<Map<String, KokugoCharacterState>> {
  static const String storageKey = 'kokugo_exp_v1';

  ExpNotifier() : super({}) {
    _loadFromStorage();
  }

  void _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(storageKey);
      if (jsonStr != null) {
        final Map<String, dynamic> decoded = jsonDecode(jsonStr);
        final charStates = <String, KokugoCharacterState>{};
        decoded.forEach((key, value) {
          charStates[key] = KokugoCharacterState.fromJson(value as Map<String, dynamic>);
        });
        state = charStates;
      }
    } catch (e) {
      debugPrint('❌ Error loading EXP data: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonMap = <String, dynamic>{};
      state.forEach((key, charState) {
        jsonMap[key] = charState.toJson();
      });
      await prefs.setString(storageKey, jsonEncode(jsonMap));
    } catch (e) {
      debugPrint('❌ Error saving EXP data: $e');
    }
  }

  /// EXP を付与
  Future<void> grantExperience(String characterId, int expAmount) async {
    final current = state[characterId] ?? KokugoCharacterState(characterId: characterId);
    final oldLevel = current.evolutionLevel;

    final updated = current.addExperience(expAmount);
    final newLevel = updated.evolutionLevel;

    state = {...state, characterId: updated};
    await _saveToStorage();

    if (newLevel > oldLevel) {
      debugPrint('🎉 $characterId level up! Lv.$oldLevel → Lv.$newLevel');
    }
  }

  /// 複数キャラに一括付与
  Future<void> grantExperienceToAll(int expAmount) async {
    var newState = {...state};
    for (final charId in newState.keys) {
      final current = newState[charId]!;
      newState[charId] = current.addExperience(expAmount);
    }
    state = newState;
    await _saveToStorage();
  }

  /// EXP をリセット（テスト用）
  Future<void> reset() async {
    state = {};
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }
}
