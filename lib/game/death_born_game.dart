import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/bosses/enforcer/enforcer_boss.dart';
import 'components/player/player_component.dart';
import 'components/npcs/alenoid_npc.dart';
import 'components/triggers/dialogue_trigger.dart';
import 'levels/graveyard_level.dart';

class DeathBornGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  PlayerComponent? player;
  late AlenoidNpc companion;
  late GraveyardLevel graveyardLevel;

  final void Function()? onEnemyDefeatedChoice;
  final void Function(String sceneId)? onTriggerDialogue;

  Vector2 lastCheckpointPosition = Vector2(100, 430);
  double _fadeAlpha = 0.0;
  bool _isRespawning = false;

  DeathBornGame({
    this.onEnemyDefeatedChoice,
    this.onTriggerDialogue,
  });

  EnforcerBoss? get activeBoss =>
      world.children.whereType<EnforcerBoss>().firstOrNull;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder.zoom = 2.0;

    graveyardLevel = GraveyardLevel(
      onCheckpointActivated: (point) => lastCheckpointPosition = point,
      onPlayerSpawned: (p) => _setupPlayer(p),
      onThugDefeated: onEnemyDefeatedChoice,
    );
    await world.add(graveyardLevel);

    if (onTriggerDialogue != null) {
      await world.add(
        DialogueTrigger(
          position: Vector2(250, 430),
          size: Vector2(40, 60),
          sceneId: 'chapter5_clinic',
          onTriggered: (sceneId) => onTriggerDialogue!(sceneId),
        ),
      );
    }
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
  void triggerGraveStep() => player?.usePower('grave_step');
  void triggerGraveStrike() => player?.usePower('grave_strike');

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
    final isGraveStep = keysPressed.contains(LogicalKeyboardKey.keyE) ||
        keysPressed.contains(LogicalKeyboardKey.shiftLeft);
    final isGraveStrike = keysPressed.contains(LogicalKeyboardKey.keyQ);

    if (isLeft && !isRight) {
      player?.moveLeft();
    } else if (isRight && !isLeft) {
      player?.moveRight();
    } else {
      player?.stopHorizontal();
    }

    if (isJump) player?.jump();
    if (isAttack) player?.attack();
    if (isGraveStep) player?.usePower('grave_step');
    if (isGraveStrike) player?.usePower('grave_strike');

    return KeyEventResult.handled;
  }
}
