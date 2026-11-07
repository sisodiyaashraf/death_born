import 'dart:async';
import 'package:flutter/material.dart';

import '../../data/models/cutscene_model.dart';
import 'widgets/glitch_transition_widget.dart';
import 'widgets/title_card_widget.dart';
import 'widgets/subtitle_widget.dart';

class CutscenePlayer extends StatefulWidget {
  final CutsceneScene scene;
  final VoidCallback onFinished;
  final VoidCallback onSkipped;

  const CutscenePlayer({
    super.key,
    required this.scene,
    required this.onFinished,
    required this.onSkipped,
  });

  @override
  State<CutscenePlayer> createState() => _CutscenePlayerState();
}

class _CutscenePlayerState extends State<CutscenePlayer>
    with SingleTickerProviderStateMixin {
  int _currentPanelIndex = 0;
  late AnimationController _panZoomController;
  Timer? _panelTimer;

  bool _isGlitching = false;
  double _titleOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _panZoomController = AnimationController(vsync: this);
    _playPanel(0);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _titleOpacity = 0.0);
    });
  }

  void _playPanel(int index) {
    if (index >= widget.scene.panels.length) {
      widget.onFinished();
      return;
    }

    final panel = widget.scene.panels[index];
    setState(() {
      _currentPanelIndex = index;
      _isGlitching = panel.transition == TransitionType.glitch;
    });

    if (_isGlitching) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _isGlitching = false);
      });
    }

    _panZoomController.duration = Duration(milliseconds: (panel.duration * 1000).toInt());
    _panZoomController.forward(from: 0.0);

    _panelTimer?.cancel();
    _panelTimer = Timer(Duration(milliseconds: (panel.duration * 1000).toInt()), () {
      _advancePanel();
    });
  }

  void _advancePanel() {
    if (_currentPanelIndex + 1 < widget.scene.panels.length) {
      _playPanel(_currentPanelIndex + 1);
    } else {
      widget.onFinished();
    }
  }

  @override
  void dispose() {
    _panelTimer?.cancel();
    _panZoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final panel = widget.scene.panels[_currentPanelIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _advancePanel,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            _buildAnimatedImage(panel),
            TitleCardWidget(
              episodeNumber: widget.scene.episodeNumber,
              title: widget.scene.title,
              opacity: _titleOpacity,
            ),
            if (panel.subtitle != null)
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SubtitleWidget(text: panel.subtitle!),
                  ),
                ),
              ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: widget.onSkipped,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black45,
                      side: const BorderSide(color: Colors.white54),
                    ),
                    child: const Text('SKIP', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedImage(CutscenePanel panel) {
    return AnimatedBuilder(
      animation: _panZoomController,
      builder: (context, child) {
        final progress = _panZoomController.value;
        final scale = Tween<double>(begin: panel.startScale, end: panel.endScale).transform(progress);
        final offset = Offset.lerp(panel.startOffset, panel.endOffset, progress) ?? Offset.zero;

        return GlitchTransitionWidget(
          isGlitching: _isGlitching,
          child: Transform.translate(
            offset: offset,
            child: Transform.scale(
              scale: scale,
              child: Image.asset(
                'assets/images/${panel.imageAsset}',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFF181824)),
              ),
            ),
          ),
        );
      },
    );
  }
}
