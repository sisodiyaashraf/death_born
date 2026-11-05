import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class AlenoidNpc extends PositionComponent {
  double _timer = 0.0;
  final Paint _outerPaint = Paint()..color = Colors.purpleAccent;
  final Paint _innerPaint = Paint()..color = Colors.cyanAccent;

  AlenoidNpc({required Vector2 position})
      : super(position: position, size: Vector2(24, 24));

  void followTarget(Vector2 targetPos, double dt) {
    _timer += dt * 3.5;
    final floatOffset = Vector2(-28, -36 + sin(_timer) * 5);
    final destination = targetPos + floatOffset;
    position.lerp(destination, (dt * 4.0).clamp(0.0, 1.0));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final center = size / 2;
    canvas.drawCircle(center.toOffset(), size.x / 2, _outerPaint);
    canvas.drawCircle(center.toOffset(), size.x / 4, _innerPaint);
  }
}
