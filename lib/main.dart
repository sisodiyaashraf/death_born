import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/models/cutscene_model.dart';
import 'data/models/player_stats.dart';
import 'data/repositories/cutscene_repository.dart';
import 'data/repositories/game_save_repository.dart';
import 'game/death_born_game.dart';
import 'ui/cutscenes/cutscene_player.dart';
import 'ui/hud/hud_overlay.dart';
import 'ui/hud/on_screen_controls.dart';
import 'ui/menus/main_menu.dart';
import 'ui/menus/pause_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final saveRepository = GameSaveRepository(prefs);

  runApp(
    Provider<GameSaveRepository>.value(
      value: saveRepository,
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
  CutsceneScene? _activeCutscene;

  late DeathBornGame _game;
  final CutsceneRepository _cutsceneRepository = CutsceneRepository();

  @override
  void initState() {
    super.initState();
    _game = DeathBornGame();
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
      _game = DeathBornGame();
      _isPlayingGame = true;
      _isPaused = false;
    });
  }

  void _returnToMenu() {
    setState(() {
      _activeCutscene = null;
      _isPlayingGame = false;
      _isPaused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<PlayerStats>.value(
      value: PlayerStats.initial(),
      child: MaterialApp(
        title: 'Death Born',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        home: _activeCutscene != null
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
                        HudOverlay(
                          game: _game,
                          onPausePressed: () => setState(() => _isPaused = !_isPaused),
                        ),
                        OnScreenControls(game: _game),
                        if (_isPaused)
                          PauseMenu(
                            onResume: () => setState(() => _isPaused = false),
                            onMainMenu: _returnToMenu,
                          ),
                      ],
                    ),
                  )
                : MainMenu(
                    onStartGame: _startChapter1,
                    onPlayChapter2Cutscene: _startChapter2Cutscene,
                  )),
      ),
    );
  }
}
