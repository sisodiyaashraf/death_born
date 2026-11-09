import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/settings_repository.dart';

class AudioService extends ChangeNotifier {
  static AudioService? _instance;
  static AudioService get instance => _instance ?? AudioService();

  final SettingsRepository? _settingsRepository;

  double _musicVolume = 0.7;
  double _sfxVolume = 0.8;
  String? _currentMusicTrack;

  AudioService({SettingsRepository? settingsRepository})
      : _settingsRepository = settingsRepository {
    _instance = this;
    _init();
  }

  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  Future<void> _init() async {
    if (_settingsRepository != null) {
      _musicVolume = await _settingsRepository!.getMusicVolume();
      _sfxVolume = await _settingsRepository!.getSfxVolume();
      FlameAudio.bgm.initialize();
      notifyListeners();
    }
  }

  Future<void> preloadAssets(List<String> files) async {
    try {
      await FlameAudio.audioCache.loadAll(files);
    } catch (_) {}
  }

  Future<void> playMusic(String filename) async {
    if (_currentMusicTrack == filename) return;
    _currentMusicTrack = filename;
    try {
      await FlameAudio.bgm.play(filename, volume: _musicVolume);
    } catch (_) {}
  }

  Future<void> stopMusic() async {
    _currentMusicTrack = null;
    try {
      await FlameAudio.bgm.stop();
    } catch (_) {}
  }

  Future<void> crossfadeMusic(String newTrack) async {
    await stopMusic();
    await playMusic(newTrack);
  }

  Future<void> playSfx(String filename) async {
    try {
      await FlameAudio.play(filename, volume: _sfxVolume);
    } catch (_) {}
  }

  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    _settingsRepository?.saveMusicVolume(_musicVolume);
    notifyListeners();
  }

  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
    _settingsRepository?.saveSfxVolume(_sfxVolume);
    notifyListeners();
  }
}
