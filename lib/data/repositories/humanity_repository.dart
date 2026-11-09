import 'package:shared_preferences/shared_preferences.dart';
import '../models/humanity_state.dart';

abstract class HumanityRepository {
  Future<HumanityState> loadHumanityState();
  Future<void> saveHumanityState(HumanityState state);
  Future<Set<String>> loadChoices();
  Future<void> saveChoice(String choiceId);
}

class PreferencesHumanityRepository implements HumanityRepository {
  static const String _humanityKey = 'humanity_score';
  static const String _corruptionKey = 'corruption_score';
  static const String _choicesKey = 'story_choices';

  final SharedPreferences _prefs;

  PreferencesHumanityRepository(this._prefs);

  @override
  Future<HumanityState> loadHumanityState() async {
    final h = _prefs.getDouble(_humanityKey) ?? 50.0;
    final c = _prefs.getDouble(_corruptionKey) ?? 50.0;
    return HumanityState(humanity: h, corruption: c);
  }

  @override
  Future<void> saveHumanityState(HumanityState state) async {
    await _prefs.setDouble(_humanityKey, state.humanity);
    await _prefs.setDouble(_corruptionKey, state.corruption);
  }

  @override
  Future<Set<String>> loadChoices() async {
    final list = _prefs.getStringList(_choicesKey) ?? [];
    return list.toSet();
  }

  @override
  Future<void> saveChoice(String choiceId) async {
    final choices = await loadChoices();
    choices.add(choiceId);
    await _prefs.setStringList(_choicesKey, choices.toList());
  }
}
