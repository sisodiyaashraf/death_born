import 'package:flutter/material.dart';

class BossHealthBarOverlay extends StatelessWidget {
  final String bossName;
  final double currentHealth;
  final double maxHealth;

  const BossHealthBarOverlay({
    super.key,
    required this.bossName,
    required this.currentHealth,
    required this.maxHealth,
  });

  @override
  Widget build(BuildContext context) {
    final healthFraction = (currentHealth / maxHealth).clamp(0.0, 1.0);

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 360),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.redAccent, width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bossName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: healthFraction,
                      child: Container(color: Colors.redAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
