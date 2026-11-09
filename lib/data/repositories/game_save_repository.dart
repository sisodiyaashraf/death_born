import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/save_game_model.dart';

abstract class GameSaveRepository {
  Future<SaveGameModel?> loadSaveGame();
  Future<void> saveGame(SaveGameModel saveModel);
  Future<bool> hasSaveGame();
  Future<void> clearSaveGame();
}

class PreferencesGameSaveRepository implements GameSaveRepository {
  static const String _saveKey = 'death_born_save_slot_1';
  final SharedPreferences _prefs;

  PreferencesGameSaveRepository(this._prefs);

  @override
  Future<SaveGameModel?> loadSaveGame() async {
    final rawJson = _prefs.getString(_saveKey);
    if (rawJson == null) return null;
    try {
      final map = json.decode(rawJson) as Map<String, dynamic>;
      return SaveGameModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveGame(SaveGameModel saveModel) async {
    final rawJson = json.encode(saveModel.toJson());
    await _prefs.setString(_saveKey, rawJson);
  }

  @override
  Future<bool> hasSaveGame() async {
    return _prefs.containsKey(_saveKey);
  }

  @override
  Future<void> clearSaveGame() async {
    await _prefs.remove(_saveKey);
  }
}
