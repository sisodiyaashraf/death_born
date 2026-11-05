import 'package:flutter/material.dart';
import '../../core/utils/platform_utils.dart';
import '../../game/death_born_game.dart';

class OnScreenControls extends StatelessWidget {
  final DeathBornGame game;

  const OnScreenControls({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    if (!PlatformUtils.isTouchDevice()) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildDpad(),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDpad() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHoldButton(
          icon: Icons.arrow_back_ios_new,
          onTapDown: game.startMoveLeft,
          onTapUp: game.stopMoveHorizontal,
        ),
        const SizedBox(width: 12),
        _buildHoldButton(
          icon: Icons.arrow_forward_ios,
          onTapDown: game.startMoveRight,
          onTapUp: game.stopMoveHorizontal,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          label: 'ATK',
          color: Colors.redAccent,
          onPressed: game.triggerAttack,
        ),
        const SizedBox(width: 12),
        _buildActionButton(
          label: 'JUMP',
          color: Colors.cyanAccent,
          onPressed: game.triggerJump,
        ),
      ],
    );
  }

  Widget _buildHoldButton({
    required IconData icon,
    required VoidCallback onTapDown,
    required VoidCallback onTapUp,
  }) {
    return GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: onTapUp,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white54, width: 2),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
