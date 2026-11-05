import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/models/player_stats.dart';
import 'data/repositories/game_save_repository.dart';
import 'game/death_born_game.dart';
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
  bool _isPlaying = false;
  bool _isPaused = false;
  late DeathBornGame _game;

  @override
  void initState() {
    super.initState();
    _game = DeathBornGame();
  }

  void _startGame() {
    setState(() {
      _game = DeathBornGame();
      _isPlaying = true;
      _isPaused = false;
    });
  }

  void _returnToMenu() {
    setState(() {
      _isPlaying = false;
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
        home: _isPlaying
            ? Scaffold(
                body: Stack(
                  children: [
                    GameWidget(game: _game),
                    HudOverlay(
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
            : MainMenu(onStartGame: _startGame),
      ),
    );
  }
}
