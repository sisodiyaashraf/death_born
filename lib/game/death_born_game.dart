import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/player/player_component.dart';
import 'components/npcs/alenoid_npc.dart';
import 'levels/graveyard_level.dart';

class DeathBornGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  PlayerComponent? player;
  late AlenoidNpc companion;
  late GraveyardLevel graveyardLevel;

  Vector2 lastCheckpointPosition = Vector2(100, 430);
  double _fadeAlpha = 0.0;
  bool _isRespawning = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder.zoom = 2.0;

    graveyardLevel = GraveyardLevel(
      onCheckpointActivated: (point) => lastCheckpointPosition = point,
      onPlayerSpawned: (p) => _setupPlayer(p),
    );
    await world.add(graveyardLevel);
  }

  void _setupPlayer(PlayerComponent p) {
    player = p;
    camera.follow(p);

    companion = AlenoidNpc(position: p.position - Vector2(30, 40));
    world.add(companion);

    p.health.onDeath = () => triggerDeathRespawn();
  }

  void triggerDeathRespawn() {
    if (_isRespawning) return;
    _isRespawning = true;
  }

  void triggerScreenShake({double duration = 0.1, double intensity = 4.0}) {
    camera.viewfinder.add(
      MoveEffect.by(
        Vector2(intensity, 0),
        EffectController(duration: duration, alternate: true),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (player != null) {
      companion.followTarget(player!.position, dt);
    }

    if (_isRespawning) {
      _fadeAlpha = (_fadeAlpha + dt * 2.0).clamp(0.0, 1.0);
      if (_fadeAlpha >= 1.0 && player != null) {
        player!.position = lastCheckpointPosition.clone();
        player!.health.currentHealth = player!.health.maxHealth;
        player!.isGrounded = true;
        _isRespawning = false;
      }
    } else if (_fadeAlpha > 0.0) {
      _fadeAlpha = (_fadeAlpha - dt * 2.0).clamp(0.0, 1.0);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_fadeAlpha > 0) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, canvasSize.x, canvasSize.y),
        Paint()..color = Colors.black.withValues(alpha: _fadeAlpha),
      );
    }
  }

  void startMoveLeft() => player?.moveLeft();
  void startMoveRight() => player?.moveRight();
  void stopMoveHorizontal() => player?.stopHorizontal();
  void triggerJump() => player?.jump();
  void triggerAttack() => player?.attack();

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeft = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRight = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isJump = keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isAttack = keysPressed.contains(LogicalKeyboardKey.keyJ) ||
        keysPressed.contains(LogicalKeyboardKey.keyZ);

    if (isLeft && !isRight) {
      player?.moveLeft();
    } else if (isRight && !isLeft) {
      player?.moveRight();
    } else {
      player?.stopHorizontal();
    }

    if (isJump) player?.jump();
    if (isAttack) player?.attack();

    return KeyEventResult.handled;
  }
}
