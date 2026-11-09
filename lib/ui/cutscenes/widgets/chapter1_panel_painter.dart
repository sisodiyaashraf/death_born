import 'package:flutter/material.dart';

class Chapter1PanelPainter extends CustomPainter {
  const Chapter1PanelPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF0D0204);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final skyPaint = Paint()..color = const Color(0xFF8B0000);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.45), skyPaint);

    final crackPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final crackPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..lineTo(size.width * 0.45, size.height * 0.7)
      ..lineTo(size.width * 0.55, size.height * 0.75)
      ..lineTo(size.width * 0.85, size.height * 0.65);
    canvas.drawPath(crackPath, crackPaint);

    final soilPaint = Paint()..color = Colors.black;
    final soilPath = Path()
      ..moveTo(0, size.height * 0.45)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(soilPath, soilPaint);

    final handPaint = Paint()..color = const Color(0xFFE8E8E8);
    final handCenter = Offset(size.width * 0.5, size.height * 0.55);

    canvas.drawRect(
      Rect.fromCenter(center: handCenter, width: 28, height: 48),
      handPaint,
    );

    for (var i = 0; i < 4; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          handCenter.dx - 12 + (i * 7),
          handCenter.dy - 32,
          5,
          18,
        ),
        handPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Chapter1PanelWidget extends StatelessWidget {
  const Chapter1PanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CustomPaint(
        painter: const Chapter1PanelPainter(),
      ),
    );
  }
}
