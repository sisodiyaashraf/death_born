import 'package:shared_preferences/shared_preferences.dart';

class GameSaveRepository {
  static const String _humanityKey = 'humanity_meter';
  static const String _highScoreKey = 'high_score';

  final SharedPreferences _prefs;

  GameSaveRepository(this._prefs);

  double getSavedHumanity() {
    return _prefs.getDouble(_humanityKey) ?? 0.5;
  }

  Future<void> saveHumanity(double value) async {
    await _prefs.setDouble(_humanityKey, value.clamp(0.0, 1.0));
  }

  int getHighScore() {
    return _prefs.getInt(_highScoreKey) ?? 0;
  }

  Future<void> saveHighScore(int score) async {
    await _prefs.setInt(_highScoreKey, score);
  }
}
