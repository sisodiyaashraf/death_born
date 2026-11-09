import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/player_stats.dart';
import '../../domain/services/humanity_service.dart';
import '../../game/death_born_game.dart';
import '../../game/powers/power_controller.dart';
import 'boss_health_bar_overlay.dart';

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
    final humanityService = context.watch<HumanityService>();
    final healthFraction = (stats.health / stats.maxHealth).clamp(0.0, 1.0);
    final powerController = game?.player?.powerController;
    final boss = game?.activeBoss;

    return SafeArea(
      child: Stack(
        children: [
          Padding(
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
                    _buildSplitMeter(humanityService.corruption, humanityService.humanity),
                    if (powerController != null) ...[
                      const SizedBox(height: 8),
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
          if (boss != null && !boss.isDefeated)
            BossHealthBarOverlay(
              bossName: boss.bossName,
              currentHealth: boss.health.currentHealth,
              maxHealth: boss.health.maxHealth,
            ),
        ],
      ),
    );
  }

  Widget _buildSplitMeter(double corruption, double humanity) {
    final total = (corruption + humanity).clamp(1.0, 200.0);
    final corruptionRatio = (corruption / total).clamp(0.0, 1.0);

    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      height: 16,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white30, width: 1.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: (corruptionRatio * 100).toInt().clamp(1, 99),
                  child: Container(color: Colors.purpleAccent),
                ),
                Expanded(
                  flex: ((1.0 - corruptionRatio) * 100).toInt().clamp(1, 99),
                  child: Container(color: Colors.cyanAccent),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'COR ${corruption.toInt()}',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'HUM ${humanity.toInt()}',
                      style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
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
              margin: const EdgeInsets.only(right: 6.0),
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
      constraints: const BoxConstraints(maxWidth: 220),
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
}
