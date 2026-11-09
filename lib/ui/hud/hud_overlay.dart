import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/player_stats.dart';
import '../../game/death_born_game.dart';
import '../../game/powers/power_controller.dart';

class HudOverlay extends StatelessWidget {
  final VoidCallback onPausePressed;
  final DeathBornGame? game;

  const HudOverlay({
    super.key,
    required this.onPausePressed,
    this.game,
  });

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<PlayerStats>();
    final healthFraction = (stats.health / stats.maxHealth).clamp(0.0, 1.0);
    final powerController = game?.player?.powerController;

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
                if (powerController != null) ...[
                  const SizedBox(height: 10),
                  _buildPowerCooldowns(powerController),
                ],
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

  Widget _buildPowerCooldowns(PowerController controller) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Row(
          children: controller.powers.map((power) {
            final cdProgress = power.cooldownProgress;
            final isReady = power.isReady;

            return Container(
              margin: const EdgeInsets.only(right: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isReady ? Colors.greenAccent : Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    power.name,
                    style: TextStyle(
                      color: isReady ? Colors.white : Colors.white54,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!isReady) ...[
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        value: cdProgress,
                        strokeWidth: 2,
                        color: Colors.greenAccent,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        );
      },
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
