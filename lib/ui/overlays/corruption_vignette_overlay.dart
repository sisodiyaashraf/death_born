import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/services/humanity_service.dart';

class CorruptionVignetteOverlay extends StatelessWidget {
  const CorruptionVignetteOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final humanityService = context.watch<HumanityService>();
    final corruption = humanityService.corruption;
    final intensity = (corruption / 100.0).clamp(0.0, 1.0);

    if (intensity <= 0.2) return const SizedBox.shrink();

    final opacity = ((intensity - 0.2) / 0.8 * 0.45).clamp(0.0, 0.45);

    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.85,
            colors: [
              Colors.transparent,
              Colors.greenAccent.withValues(alpha: opacity * 0.4),
              Colors.purple.withValues(alpha: opacity),
            ],
            stops: const [0.5, 0.85, 1.0],
          ),
        ),
      ),
    );
  }
}
