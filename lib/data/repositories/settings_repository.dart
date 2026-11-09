import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsRepository {
  Future<double> getMusicVolume();
  Future<void> saveMusicVolume(double volume);
  Future<double> getSfxVolume();
  Future<void> saveSfxVolume(double volume);
}

class PreferencesSettingsRepository implements SettingsRepository {
  static const String _musicKey = 'music_volume';
  static const String _sfxKey = 'sfx_volume';

  final SharedPreferences _prefs;

  PreferencesSettingsRepository(this._prefs);

  @override
  Future<double> getMusicVolume() async {
    return _prefs.getDouble(_musicKey) ?? 0.7;
  }

  @override
  Future<void> saveMusicVolume(double volume) async {
    await _prefs.setDouble(_musicKey, volume.clamp(0.0, 1.0));
  }

  @override
  Future<double> getSfxVolume() async {
    return _prefs.getDouble(_sfxKey) ?? 0.8;
  }

  @override
  Future<void> saveSfxVolume(double volume) async {
    await _prefs.setDouble(_sfxKey, volume.clamp(0.0, 1.0));
  }
}
