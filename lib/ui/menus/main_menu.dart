import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  final VoidCallback onNewGame;
  final VoidCallback? onContinue;
  final VoidCallback onSettings;
  final VoidCallback? onPlayChapter2Cutscene;

  const MainMenu({
    super.key,
    required this.onNewGame,
    this.onContinue,
    required this.onSettings,
    this.onPlayChapter2Cutscene,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B14),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.5), width: 1.5),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'DEATH BORN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: Colors.redAccent,
                          letterSpacing: 4.0,
                          shadows: [
                            Shadow(blurRadius: 16.0, color: Colors.purple, offset: Offset(0, 0)),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Arther Johnson & The Alenoid',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.cyanAccent,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 260),
                  child: Column(
                    children: [
                      _buildButton('NEW GAME', Colors.cyan, onNewGame),
                      const SizedBox(height: 12),
                      _buildButton(
                        'CONTINUE',
                        Colors.cyanAccent,
                        onContinue,
                        isDisabled: onContinue == null,
                      ),
                      const SizedBox(height: 12),
                      _buildButton('SETTINGS', Colors.purpleAccent, onSettings),
                      if (onPlayChapter2Cutscene != null) ...[
                        const SizedBox(height: 12),
                        _buildButton('CHAPTER 2 INTRO', Colors.deepPurpleAccent, onPlayChapter2Cutscene!),
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

  Widget _buildButton(
    String label,
    Color color,
    VoidCallback? onPressed, {
    bool isDisabled = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? Colors.grey.withValues(alpha: 0.15)
              : color.withValues(alpha: 0.2),
          side: BorderSide(
            color: isDisabled ? Colors.grey.withValues(alpha: 0.4) : color,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: isDisabled ? null : onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: isDisabled ? Colors.white38 : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
