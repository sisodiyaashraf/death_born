import 'package:flame/components.dart';
import '../../core/constants/game_constants.dart';

class PhysicsSystem {
  static void applyGravity(Vector2 velocity, double dt) {
    velocity.y += GameConstants.gravity * dt;
  }

  static void clampPosition(Vector2 position, Vector2 bounds) {
    position.x = position.x.clamp(0.0, bounds.x);
  }
}
