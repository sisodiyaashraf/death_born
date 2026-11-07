import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  final VoidCallback onStartGame;
  final VoidCallback? onPlayChapter2Cutscene;

  const MainMenu({
    super.key,
    required this.onStartGame,
    this.onPlayChapter2Cutscene,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D18),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'DEATH BORN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: Colors.redAccent,
                    letterSpacing: 4.0,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Arther Johnson & The Alenoid',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.cyanAccent,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 48),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 260),
                  child: Column(
                    children: [
                      _buildButton('START GAME', Colors.cyan, onStartGame),
                      if (onPlayChapter2Cutscene != null) ...[
                        const SizedBox(height: 12),
                        _buildButton('CHAPTER 2 INTRO', Colors.purpleAccent, onPlayChapter2Cutscene!),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.2),
          side: BorderSide(color: color, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
