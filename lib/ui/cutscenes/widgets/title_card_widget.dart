import 'package:flutter/material.dart';

class TitleCardWidget extends StatelessWidget {
  final String episodeNumber;
  final String title;
  final double opacity;

  const TitleCardWidget({
    super.key,
    required this.episodeNumber,
    required this.title,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    if (opacity <= 0) return const SizedBox.shrink();

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: opacity.clamp(0.0, 1.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.4), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                episodeNumber.toUpperCase(),
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
