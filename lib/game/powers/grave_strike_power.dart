import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../components/enemies/thug/states/thug_dead_state.dart';
import '../components/enemies/thug/thug_component.dart';
import '../components/player/ground_component.dart';
import '../components/player/player_component.dart';
import 'effects/shadow_trail_component.dart';
import 'humanity_service_stub.dart';
import 'power_base.dart';

class GraveStrikePower extends Power {
  final double strikeDistance;

  GraveStrikePower({this.strikeDistance = 160.0})
      : super(
          id: 'grave_strike',
          name: 'Grave Strike',
          cooldownDuration: 4.0,
        );

  @override
  bool activate(PlayerComponent player) {
    final startPos = player.position.clone();
    final direction = player.isFacingRight ? 1.0 : -1.0;
    final targetX = startPos.x + (direction * strikeDistance);

    final finalPos = _calculateFinalPosition(player, startPos, targetX);

    _eliminateEnemiesInPath(player, startPos, finalPos);

    HumanityService.instance.addCorruption(10.0);

    final gameWorld = player.game.world;
    gameWorld.add(ShadowTrailComponent(position: startPos, size: player.size));
    player.position = finalPos;
    gameWorld.add(ShadowTrailComponent(position: finalPos, size: player.size));

    return true;
  }

  void _eliminateEnemiesInPath(PlayerComponent player, Vector2 start, Vector2 end) {
    final minX = start.x < end.x ? start.x : end.x;
    final maxX = start.x > end.x ? start.x : end.x;
    final pathSegment = Rect.fromLTRB(minX, start.y - 30, maxX, start.y + 30);

    final enemies = player.game.world.children.whereType<ThugComponent>();
    for (final enemy in enemies) {
      final enemyRect = Rect.fromLTWH(
        enemy.position.x - enemy.size.x / 2,
        enemy.position.y - enemy.size.y / 2,
        enemy.size.x,
        enemy.size.y,
      );

      if (pathSegment.overlaps(enemyRect)) {
        enemy.health.takeDamage(enemy.health.maxHealth);
        enemy.setState(ThugDeadState());
      }
    }
  }

  Vector2 _calculateFinalPosition(PlayerComponent player, Vector2 start, double targetX) {
    final direction = (targetX - start.x).sign;
    double currentX = start.x;

    final grounds = player.game.world.children.whereType<GroundComponent>();
    const step = 8.0;
    final totalSteps = (strikeDistance / step).abs().toInt();

    for (var i = 0; i < totalSteps; i++) {
      final nextX = currentX + (direction * step);
      final testRect = Rect.fromLTWH(nextX - player.size.x / 2, start.y - player.size.y / 2, player.size.x, player.size.y);

      bool collides = false;
      for (final ground in grounds) {
        final groundRect = Rect.fromLTWH(ground.position.x, ground.position.y, ground.size.x, ground.size.y);
        if (testRect.overlaps(groundRect)) {
          collides = true;
          break;
        }
      }

      if (collides) break;
      currentX = nextX;
    }

    return Vector2(currentX, start.y);
  }
}
