import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/sprite_sheet_loader.dart';

enum PlayerState { idle, run, jump, fall, attack, hurt, dead }

class PlayerSprites {
  final Map<PlayerState, SpriteAnimation> animations = {};

  Future<void> loadAnimations(FlameGame game) async {
    try {
      animations[PlayerState.idle] = await SpriteSheetLoader.loadAnimation(
        game: game,
        imagePath: 'player_idle.png',
        frameSize: Vector2(32, 48),
        row: 0,
        frameCount: 4,
        stepTime: 0.15,
      );
      animations[PlayerState.run] = await SpriteSheetLoader.loadAnimation(
        game: game,
        imagePath: 'player_run.png',
        frameSize: Vector2(32, 48),
        row: 0,
        frameCount: 6,
        stepTime: 0.1,
      );
      animations[PlayerState.jump] = await SpriteSheetLoader.loadAnimation(
        game: game,
        imagePath: 'player_jump.png',
        frameSize: Vector2(32, 48),
        row: 0,
        frameCount: 2,
        stepTime: 0.1,
      );
      animations[PlayerState.fall] = await SpriteSheetLoader.loadAnimation(
        game: game,
        imagePath: 'player_fall.png',
        frameSize: Vector2(32, 48),
        row: 0,
        frameCount: 2,
        stepTime: 0.1,
      );
      animations[PlayerState.attack] = await SpriteSheetLoader.loadAnimation(
        game: game,
        imagePath: 'player_attack.png',
        frameSize: Vector2(32, 48),
        row: 0,
        frameCount: 4,
        stepTime: 0.08,
        loop: false,
      );
      animations[PlayerState.hurt] = await SpriteSheetLoader.loadAnimation(
        game: game,
        imagePath: 'player_hurt.png',
        frameSize: Vector2(32, 48),
        row: 0,
        frameCount: 2,
        stepTime: 0.12,
        loop: false,
      );
      animations[PlayerState.dead] = await SpriteSheetLoader.loadAnimation(
        game: game,
        imagePath: 'player_dead.png',
        frameSize: Vector2(32, 48),
        row: 0,
        frameCount: 4,
        stepTime: 0.15,
        loop: false,
      );
    } catch (_) {
      _loadFallbackAnimations();
    }
  }

  void _loadFallbackAnimations() {
    for (final state in PlayerState.values) {
      final color = _getFallbackColor(state);
      final sprite = Sprite(_createColorImage(color));
      animations[state] = SpriteAnimation.spriteList(
        [sprite],
        stepTime: 1.0,
      );
    }
  }

  Color _getFallbackColor(PlayerState state) {
    switch (state) {
      case PlayerState.idle:
        return Colors.cyan;
      case PlayerState.run:
        return Colors.blueAccent;
      case PlayerState.jump:
        return Colors.lightBlueAccent;
      case PlayerState.fall:
        return Colors.tealAccent;
      case PlayerState.attack:
        return Colors.redAccent;
      case PlayerState.hurt:
        return Colors.orangeAccent;
      case PlayerState.dead:
        return Colors.purple;
    }
  }

  static ui.Image _createColorImage(Color color) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 32, 48),
      Paint()..color = color,
    );
    return recorder.endRecording().toImageSync(32, 48);
  }
}
