import 'package:flutter/material.dart';

class SubtitleWidget extends StatelessWidget {
  final String text;

  const SubtitleWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();

    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              height: 1.3,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3.0
                ..color = Colors.black,
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
