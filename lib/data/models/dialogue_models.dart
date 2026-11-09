class DialogueChoiceModel {
  final String text;
  final double humanityImpact;

  const DialogueChoiceModel({
    required this.text,
    required this.humanityImpact,
  });

  factory DialogueChoiceModel.fromJson(Map<String, dynamic> json) {
    return DialogueChoiceModel(
      text: json['text'] as String,
      humanityImpact: (json['humanityImpact'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class DialogueLineModel {
  final String speakerId;
  final String speakerName;
  final String text;
  final String portraitKey;
  final List<DialogueChoiceModel> choices;

  const DialogueLineModel({
    required this.speakerId,
    required this.speakerName,
    required this.text,
    required this.portraitKey,
    this.choices = const [],
  });

  factory DialogueLineModel.fromJson(Map<String, dynamic> json) {
    final choicesList = (json['choices'] as List<dynamic>?)
            ?.map((c) => DialogueChoiceModel.fromJson(c as Map<String, dynamic>))
            .toList() ??
        [];

    return DialogueLineModel(
      speakerId: json['speakerId'] as String,
      speakerName: json['speakerName'] as String,
      text: json['text'] as String,
      portraitKey: json['portraitKey'] as String,
      choices: choicesList,
    );
  }
}

class DialogueSceneModel {
  final String id;
  final String title;
  final List<DialogueLineModel> lines;

  const DialogueSceneModel({
    required this.id,
    required this.title,
    required this.lines,
  });

  factory DialogueSceneModel.fromJson(Map<String, dynamic> json) {
    final linesList = (json['lines'] as List<dynamic>?)
            ?.map((l) => DialogueLineModel.fromJson(l as Map<String, dynamic>))
            .toList() ??
        [];

    return DialogueSceneModel(
      id: json['id'] as String,
      title: json['title'] as String,
      lines: linesList,
    );
  }
}
