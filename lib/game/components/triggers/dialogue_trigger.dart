import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../player/player_component.dart';

class DialogueTrigger extends PositionComponent with CollisionCallbacks {
  final String sceneId;
  final void Function(String sceneId) onTriggered;
  bool hasTriggered = false;

  DialogueTrigger({
    required Vector2 position,
    required Vector2 size,
    required this.sceneId,
    required this.onTriggered,
  }) : super(position: position, size: size) {
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is PlayerComponent && !hasTriggered) {
      hasTriggered = true;
      other.stopHorizontal();
      onTriggered(sceneId);
    }
  }
}
