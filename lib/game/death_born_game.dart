import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'components/player/player_component.dart';
import 'components/npcs/alenoid_npc.dart';
import 'levels/test_level.dart';

class DeathBornGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late PlayerComponent player;
  late AlenoidNpc companion;
  late TestLevel level;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder.zoom = 2.0;

    level = TestLevel();
    await world.add(level);

    final playerSpawn = level.getPlayerSpawnPosition() ?? Vector2(100, 300);
    player = PlayerComponent(position: playerSpawn);
    await world.add(player);

    level.spawnEnemies(world);

    companion = AlenoidNpc(position: playerSpawn - Vector2(30, 40));
    await world.add(companion);

    camera.follow(player);
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
    companion.followTarget(player.position, dt);
  }

  void startMoveLeft() => player.moveLeft();
  void startMoveRight() => player.moveRight();
  void stopMoveHorizontal() => player.stopHorizontal();
  void triggerJump() => player.jump();
  void triggerAttack() => player.attack();

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
      player.moveLeft();
    } else if (isRight && !isLeft) {
      player.moveRight();
    } else {
      player.stopHorizontal();
    }

    if (isJump) {
      player.jump();
    }

    if (isAttack) {
      player.attack();
    }

    return KeyEventResult.handled;
  }
}
