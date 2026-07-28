import '../../domain/entities/ai_response_entity.dart';

class AIResponseModel {
  const AIResponseModel({
    required this.id,
    required this.kindId,
    required this.title,
    required this.body,
    required this.createdAtIso,
    required this.toneId,
    this.subtitle,
    this.confidence,
    this.model = 'prep-quest-tutor-v1',
    this.tags = const <String>[],
    this.relatedQuestionId,
    this.relatedLessonId,
    this.relatedTopic,
  });

  final String id;
  final String kindId;
  final String title;
  final String body;
  final String createdAtIso;
  final String toneId;
  final String? subtitle;
  final double? confidence;
  final String model;
  final List<String> tags;
  final String? relatedQuestionId;
  final String? relatedLessonId;
  final String? relatedTopic;

  AIResponseEntity toEntity() {
    return AIResponseEntity(
      id: id,
      kind: _kindFromId(kindId),
      title: title,
      body: body,
      createdAt: DateTime.parse(createdAtIso),
      tone: _toneFromId(toneId),
      subtitle: subtitle,
      confidence: confidence,
      model: model,
      tags: List<String>.unmodifiable(tags),
      relatedQuestionId: relatedQuestionId,
      relatedLessonId: relatedLessonId,
      relatedTopic: relatedTopic,
    );
  }

  static AiResponseKind _kindFromId(String id) {
    for (final AiResponseKind k in AiResponseKind.values) {
      if (k.name == id) return k;
    }
    return AiResponseKind.general;
  }

  static AiResponseTone _toneFromId(String id) {
    for (final AiResponseTone t in AiResponseTone.values) {
      if (t.name == id) return t;
    }
    return AiResponseTone.insight;
  }
}