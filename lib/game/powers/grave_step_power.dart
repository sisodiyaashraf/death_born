import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../components/player/ground_component.dart';
import '../components/player/player_component.dart';
import 'effects/shadow_trail_component.dart';
import 'power_base.dart';

class GraveStepPower extends Power {
  final double teleportDistance;

  GraveStepPower({this.teleportDistance = 140.0})
      : super(
          id: 'grave_step',
          name: 'Grave Step',
          cooldownDuration: 2.5,
        );

  @override
  bool activate(PlayerComponent player) {
    final startPos = player.position.clone();
    final direction = player.isFacingRight ? 1.0 : -1.0;
    final targetX = startPos.x + (direction * teleportDistance);

    final finalPos = _calculateFinalPosition(player, startPos, targetX);

    final gameWorld = player.game.world;
    gameWorld.add(ShadowTrailComponent(position: startPos, size: player.size));

    player.position = finalPos;

    gameWorld.add(ShadowTrailComponent(position: finalPos, size: player.size));
    return true;
  }

  Vector2 _calculateFinalPosition(PlayerComponent player, Vector2 start, double targetX) {
    final direction = (targetX - start.x).sign;
    double currentX = start.x;

    final grounds = player.game.world.children.whereType<GroundComponent>();

    const step = 8.0;
    final totalSteps = (teleportDistance / step).abs().toInt();

    for (var i = 0; i < totalSteps; i++) {
      final nextX = currentX + (direction * step);
      final testRect = _createPlayerRect(nextX, start.y, player.size);

      bool collides = false;
      for (final ground in grounds) {
        final groundRect = _createGroundRect(ground);
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

  Rect _createPlayerRect(double x, double y, Vector2 size) {
    return Rect.fromLTWH(x - size.x / 2, y - size.y / 2, size.x, size.y);
  }

  Rect _createGroundRect(GroundComponent ground) {
    return Rect.fromLTWH(ground.position.x, ground.position.y, ground.size.x, ground.size.y);
  }
}
