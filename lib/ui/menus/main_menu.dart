import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  final VoidCallback onStartGame;

  const MainMenu({super.key, required this.onStartGame});

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
                  constraints: const BoxConstraints(maxWidth: 240),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan.withValues(alpha: 0.2),
                      side: const BorderSide(color: Colors.cyanAccent, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: onStartGame,
                    child: const Text(
                      'START GAME',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
