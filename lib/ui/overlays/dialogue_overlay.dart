import 'dart:async';
import 'package:flutter/material.dart';

import '../../data/models/dialogue_models.dart';
import '../../domain/controllers/dialogue_controller.dart';

class DialogueOverlay extends StatefulWidget {
  final DialogueController controller;

  const DialogueOverlay({super.key, required this.controller});

  @override
  State<DialogueOverlay> createState() => _DialogueOverlayState();
}

class _DialogueOverlayState extends State<DialogueOverlay> {
  String _displayedText = '';
  Timer? _typewriterTimer;
  int _charIndex = 0;
  bool _isTextComplete = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onLineChanged);
    _startTypewriter();
  }

  void _onLineChanged() {
    if (mounted) {
      _startTypewriter();
    }
  }

  void _startTypewriter() {
    final line = widget.controller.currentLine;
    _typewriterTimer?.cancel();
    if (line == null) return;

    setState(() {
      _displayedText = '';
      _charIndex = 0;
      _isTextComplete = false;
    });

    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      if (_charIndex < line.text.length) {
        _charIndex++;
        if (mounted) {
          setState(() {
            _displayedText = line.text.substring(0, _charIndex);
          });
        }
      } else {
        timer.cancel();
        if (mounted) {
          setState(() {
            _isTextComplete = true;
          });
        }
      }
    });
  }

  void _onTapOverlay() {
    final line = widget.controller.currentLine;
    if (line == null) return;

    if (!_isTextComplete) {
      _typewriterTimer?.cancel();
      setState(() {
        _displayedText = line.text;
        _isTextComplete = true;
      });
    } else {
      widget.controller.advanceLine();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onLineChanged);
    _typewriterTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        if (!widget.controller.isActive || widget.controller.currentLine == null) {
          return const SizedBox.shrink();
        }

        final line = widget.controller.currentLine!;

        return GestureDetector(
          onTap: _onTapOverlay,
          behavior: HitTestBehavior.opaque,
          child: Container(
            color: Colors.black.withValues(alpha: 0.65),
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 620),
                decoration: BoxDecoration(
                  color: const Color(0xFF161622),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.6), width: 1.5),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPortrait(line.portraitKey),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                line.speakerName,
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _displayedText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (line.choices.isNotEmpty && _isTextComplete) ...[
                      const SizedBox(height: 14),
                      _buildChoicesList(line.choices),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortrait(String key) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'assets/images/$key.png',
        width: 52,
        height: 52,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 52,
          height: 52,
          color: Colors.purple.withValues(alpha: 0.4),
          child: const Icon(Icons.person, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildChoicesList(List<DialogueChoiceModel> choices) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: choices.map((choice) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan.withValues(alpha: 0.2),
            side: const BorderSide(color: Colors.cyanAccent),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
          onPressed: () => widget.controller.selectChoice(choice),
          child: Text(
            choice.text,
            style: const TextStyle(color: Colors.white, fontSize: 12.5),
          ),
        );
      }).toList(),
    );
  }
}
