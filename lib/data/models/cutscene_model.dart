import 'package:flutter/material.dart';

enum TransitionType { fade, glitch, none }

class CutscenePanel {
  final String imageAsset;
  final double duration;
  final String? subtitle;
  final TransitionType transition;
  final double startScale;
  final double endScale;
  final Offset startOffset;
  final Offset endOffset;

  const CutscenePanel({
    required this.imageAsset,
    required this.duration,
    this.subtitle,
    this.transition = TransitionType.fade,
    this.startScale = 1.0,
    this.endScale = 1.1,
    this.startOffset = Offset.zero,
    this.endOffset = Offset.zero,
  });

  factory CutscenePanel.fromJson(Map<String, dynamic> json) {
    return CutscenePanel(
      imageAsset: json['imageAsset'] as String,
      duration: (json['duration'] as num?)?.toDouble() ?? 4.0,
      subtitle: json['subtitle'] as String?,
      transition: TransitionType.values.firstWhere(
        (e) => e.name == json['transition'],
        orElse: () => TransitionType.fade,
      ),
      startScale: (json['startScale'] as num?)?.toDouble() ?? 1.0,
      endScale: (json['endScale'] as num?)?.toDouble() ?? 1.1,
      startOffset: Offset(
        (json['startX'] as num?)?.toDouble() ?? 0.0,
        (json['startY'] as num?)?.toDouble() ?? 0.0,
      ),
      endOffset: Offset(
        (json['endX'] as num?)?.toDouble() ?? 0.0,
        (json['endY'] as num?)?.toDouble() ?? 0.0,
      ),
    );
  }
}

class CutsceneScene {
  final String id;
  final String title;
  final String episodeNumber;
  final List<CutscenePanel> panels;

  const CutsceneScene({
    required this.id,
    required this.title,
    required this.episodeNumber,
    required this.panels,
  });

  factory CutsceneScene.fromJson(Map<String, dynamic> json) {
    final panelList = (json['panels'] as List<dynamic>?)
            ?.map((p) => CutscenePanel.fromJson(p as Map<String, dynamic>))
            .toList() ??
        [];

    return CutsceneScene(
      id: json['id'] as String,
      title: json['title'] as String,
      episodeNumber: json['episodeNumber'] as String,
      panels: panelList,
    );
  }
}
