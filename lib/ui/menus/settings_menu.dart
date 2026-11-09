import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/services/audio_service.dart';

class SettingsMenu extends StatelessWidget {
  final VoidCallback onClose;

  const SettingsMenu({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final audioService = context.watch<AudioService>();

    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 340),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: const Color(0xFF161622),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.8), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SETTINGS',
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSlider(
                  label: 'Music Volume',
                  value: audioService.musicVolume,
                  onChanged: audioService.setMusicVolume,
                ),
                const SizedBox(height: 16),
                _buildSlider(
                  label: 'SFX Volume',
                  value: audioService.sfxVolume,
                  onChanged: audioService.setSfxVolume,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.withValues(alpha: 0.25),
                      side: const BorderSide(color: Colors.purpleAccent),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: onClose,
                    child: const Text('BACK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
            Text('${(value * 100).toInt()}%', style: const TextStyle(color: Colors.cyanAccent, fontSize: 13)),
          ],
        ),
        Slider(
          value: value,
          activeColor: Colors.cyanAccent,
          inactiveColor: Colors.white24,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
