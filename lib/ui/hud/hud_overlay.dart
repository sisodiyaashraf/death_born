import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/player_stats.dart';

class HudOverlay extends StatelessWidget {
  final VoidCallback onPausePressed;

  const HudOverlay({super.key, required this.onPausePressed});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<PlayerStats>();
    final healthFraction = (stats.health / stats.maxHealth).clamp(0.0, 1.0);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBar(
                  label: 'HP',
                  fraction: healthFraction,
                  color: Colors.redAccent,
                  current: stats.health.toInt(),
                  max: stats.maxHealth.toInt(),
                ),
                const SizedBox(height: 6),
                _buildCorruptionBar(stats.humanityMeter),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.pause_circle_filled, size: 36, color: Colors.white),
              onPressed: onPausePressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar({
    required String label,
    required double fraction,
    required Color color,
    required int current,
    required int max,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      height: 20,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: fraction,
              child: Container(color: color),
            ),
            Center(
              child: Text(
                '$label: $current/$max',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorruptionBar(double humanity) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      height: 14,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.6), width: 1.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple, Colors.cyan]),
              ),
            ),
            Positioned(
              left: (humanity * 190).clamp(0.0, 190.0),
              top: 0,
              bottom: 0,
              child: Container(width: 3, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
