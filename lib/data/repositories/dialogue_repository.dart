import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/dialogue_models.dart';

class DialogueRepository {
  Future<DialogueSceneModel> loadScene(String sceneId) async {
    final jsonString = await rootBundle.loadString('assets/dialogue/$sceneId.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return DialogueSceneModel.fromJson(jsonMap);
  }
}
