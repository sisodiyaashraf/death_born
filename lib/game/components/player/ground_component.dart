import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GroundComponent extends PositionComponent with CollisionCallbacks {
  final Paint _paint = Paint()..color = const Color(0xFF2A2A3D);

  GroundComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size) {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRect(rect, _paint);
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.x, 0),
      Paint()
        ..color = Colors.cyanAccent
        ..strokeWidth = 2.0,
    );
  }
}
