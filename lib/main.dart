import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/models/cutscene_model.dart';
import 'data/models/player_stats.dart';
import 'data/repositories/cutscene_repository.dart';
import 'data/repositories/game_save_repository.dart';
import 'data/repositories/humanity_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'domain/controllers/dialogue_controller.dart';
import 'domain/services/audio_service.dart';
import 'domain/services/humanity_service.dart';
import 'game/death_born_game.dart';
import 'ui/cutscenes/cutscene_player.dart';
import 'ui/hud/hud_overlay.dart';
import 'ui/hud/on_screen_controls.dart';
import 'ui/menus/main_menu.dart';
import 'ui/menus/pause_menu.dart';
import 'ui/menus/settings_menu.dart';
import 'ui/overlays/choice_prompt_overlay.dart';
import 'ui/overlays/corruption_vignette_overlay.dart';
import 'ui/overlays/dialogue_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final saveRepository = PreferencesGameSaveRepository(prefs);
  final humanityRepository = PreferencesHumanityRepository(prefs);
  final settingsRepository = PreferencesSettingsRepository(prefs);
  final humanityService = HumanityService(repository: humanityRepository);
  final audioService = AudioService(settingsRepository: settingsRepository);

  runApp(
    MultiProvider(
      providers: [
        Provider<GameSaveRepository>.value(value: saveRepository),
        Provider<SettingsRepository>.value(value: settingsRepository),
        ChangeNotifierProvider<HumanityService>.value(value: humanityService),
        ChangeNotifierProvider<AudioService>.value(value: audioService),
        Provider<PlayerStats>.value(value: PlayerStats.initial()),
      ],
      child: const DeathBornApp(),
    ),
  );
}

class DeathBornApp extends StatefulWidget {
  const DeathBornApp({super.key});

  @override
  State<DeathBornApp> createState() => _DeathBornAppState();
}

class _DeathBornAppState extends State<DeathBornApp> {
  bool _isPlayingGame = false;
  bool _isPaused = false;
  bool _showSettings = false;
  bool _showChoicePrompt = false;
  CutsceneScene? _activeCutscene;

  late DeathBornGame _game;
  final CutsceneRepository _cutsceneRepository = CutsceneRepository();
  final DialogueController _dialogueController = DialogueController();

  @override
  void initState() {
    super.initState();
    _game = DeathBornGame(
      onEnemyDefeatedChoice: () => setState(() => _showChoicePrompt = true),
      onTriggerDialogue: (sceneId) => _dialogueController.startDialogue(sceneId),
    );
  }

  Future<void> _startChapter1() async {
    final scene = await _cutsceneRepository.loadScene('chapter1_intro');
    setState(() {
      _activeCutscene = scene;
      _isPlayingGame = false;
    });
  }

  Future<void> _startChapter2Cutscene() async {
    final scene = await _cutsceneRepository.loadScene('chapter2_intro');
    setState(() {
      _activeCutscene = scene;
      _isPlayingGame = false;
    });
  }

  void _enterGame() {
    setState(() {
      _activeCutscene = null;
      _game = DeathBornGame(
        onEnemyDefeatedChoice: () => setState(() => _showChoicePrompt = true),
        onTriggerDialogue: (sceneId) => _dialogueController.startDialogue(sceneId),
      );
      _isPlayingGame = true;
      _isPaused = false;
      _showSettings = false;
      _showChoicePrompt = false;
    });
  }

  void _returnToMenu() {
    setState(() {
      _activeCutscene = null;
      _isPlayingGame = false;
      _isPaused = false;
      _showSettings = false;
      _showChoicePrompt = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Death Born',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: _showSettings
          ? SettingsMenu(onClose: () => setState(() => _showSettings = false))
          : (_activeCutscene != null
              ? CutscenePlayer(
                  scene: _activeCutscene!,
                  onFinished: _enterGame,
                  onSkipped: _enterGame,
                )
              : (_isPlayingGame
                  ? Scaffold(
                      body: Stack(
                        children: [
                          GameWidget(game: _game),
                          const CorruptionVignetteOverlay(),
                          HudOverlay(
                            game: _game,
                            onPausePressed: () => setState(() => _isPaused = !_isPaused),
                          ),
                          OnScreenControls(game: _game),
                          DialogueOverlay(controller: _dialogueController),
                          if (_showChoicePrompt)
                            ChoicePromptOverlay(
                              onChoiceMade: () => setState(() => _showChoicePrompt = false),
                            ),
                          if (_isPaused)
                            PauseMenu(
                              onResume: () => setState(() => _isPaused = false),
                              onSettings: () => setState(() => _showSettings = true),
                              onMainMenu: _returnToMenu,
                            ),
                        ],
                      ),
                    )
                  : MainMenu(
                      onNewGame: _startChapter1,
                      onContinue: _enterGame,
                      onSettings: () => setState(() => _showSettings = true),
                      onPlayChapter2Cutscene: _startChapter2Cutscene,
                    ))),
    );
  }
}
