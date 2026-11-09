class SaveGameModel {
  final int chapter;
  final String checkpointName;
  final double checkpointX;
  final double checkpointY;
  final List<String> unlockedPowers;
  final double humanityScore;
  final double corruptionScore;
  final List<String> storyChoices;

  const SaveGameModel({
    required this.chapter,
    required this.checkpointName,
    required this.checkpointX,
    required this.checkpointY,
    required this.unlockedPowers,
    required this.humanityScore,
    required this.corruptionScore,
    required this.storyChoices,
  });

  factory SaveGameModel.initial() {
    return const SaveGameModel(
      chapter: 1,
      checkpointName: 'grave_cp1',
      checkpointX: 100.0,
      checkpointY: 430.0,
      unlockedPowers: ['grave_step'],
      humanityScore: 50.0,
      corruptionScore: 50.0,
      storyChoices: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
      'checkpointName': checkpointName,
      'checkpointX': checkpointX,
      'checkpointY': checkpointY,
      'unlockedPowers': unlockedPowers,
      'humanityScore': humanityScore,
      'corruptionScore': corruptionScore,
      'storyChoices': storyChoices,
    };
  }

  factory SaveGameModel.fromJson(Map<String, dynamic> json) {
    return SaveGameModel(
      chapter: json['chapter'] as int? ?? 1,
      checkpointName: json['checkpointName'] as String? ?? 'grave_cp1',
      checkpointX: (json['checkpointX'] as num?)?.toDouble() ?? 100.0,
      checkpointY: (json['checkpointY'] as num?)?.toDouble() ?? 430.0,
      unlockedPowers: (json['unlockedPowers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['grave_step'],
      humanityScore: (json['humanityScore'] as num?)?.toDouble() ?? 50.0,
      corruptionScore: (json['corruptionScore'] as num?)?.toDouble() ?? 50.0,
      storyChoices: (json['storyChoices'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
