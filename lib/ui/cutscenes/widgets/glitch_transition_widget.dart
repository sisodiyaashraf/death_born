import 'package:flutter/material.dart';

class GlitchTransitionWidget extends StatelessWidget {
  final Widget child;
  final bool isGlitching;

  const GlitchTransitionWidget({
    super.key,
    required this.child,
    required this.isGlitching,
  });

  @override
  Widget build(BuildContext context) {
    if (!isGlitching) return child;

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Transform.translate(
            offset: const Offset(-4, 0),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.cyanAccent,
                BlendMode.modulate,
              ),
              child: child,
            ),
          ),
        ),
        Positioned.fill(
          child: Transform.translate(
            offset: const Offset(4, 0),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.redAccent,
                BlendMode.modulate,
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
