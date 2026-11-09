import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/services/humanity_service.dart';

class ChoicePromptOverlay extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onChoiceMade;

  const ChoicePromptOverlay({
    super.key,
    this.title = 'FATE OF THE ENEMY',
    this.description = 'The enemy is defeated. Will you show mercy or consume their essence?',
    required this.onChoiceMade,
  });

  @override
  Widget build(BuildContext context) {
    final humanityService = context.read<HumanityService>();

    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      alignment: Alignment.center,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color(0xFF181826),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.8), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan.withValues(alpha: 0.25),
                          side: const BorderSide(color: Colors.cyanAccent, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          humanityService.addHumanity(15.0);
                          humanityService.recordChoice('spared_thug_ch1');
                          onChoiceMade();
                        },
                        child: const Column(
                          children: [
                            Text('SPARE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text('+15 Humanity', style: TextStyle(color: Colors.cyanAccent, fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.withValues(alpha: 0.25),
                          side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          humanityService.addCorruption(20.0);
                          humanityService.recordChoice('finished_thug_ch1');
                          onChoiceMade();
                        },
                        child: const Column(
                          children: [
                            Text('FINISH', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text('+20 Corruption', style: TextStyle(color: Colors.purpleAccent, fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
