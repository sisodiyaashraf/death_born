import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../components/player/player_component.dart';

class GraveCheckpoint extends PositionComponent with CollisionCallbacks {
  bool isActivated = false;
  final Paint _inactivePaint = Paint()..color = Colors.grey;
  final Paint _activePaint = Paint()
    ..color = Colors.greenAccent
    ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 8.0);

  final void Function(Vector2 respawnPoint) onActivated;

  GraveCheckpoint({
    required Vector2 position,
    required Vector2 size,
    required this.onActivated,
  }) : super(position: position, size: size, anchor: Anchor.bottomCenter) {
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is PlayerComponent && !isActivated) {
      isActivated = true;
      onActivated(position);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = isActivated ? _activePaint : _inactivePaint;
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), paint);

    if (isActivated) {
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 4),
        6.0,
        Paint()..color = Colors.lightGreenAccent,
      );
    }
  }
}
