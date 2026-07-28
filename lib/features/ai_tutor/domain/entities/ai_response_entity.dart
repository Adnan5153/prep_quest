import 'package:flutter/foundation.dart';

/// High-level kind of response the AI tutor can produce.
///
/// Drives downstream widget selection (hints use [AiHintCard],
/// explanations use [AiExplanationCard], etc.) and analytics tagging.
enum AiResponseKind {
  hint,
  explanation,
  simplification,
  summary,
  flashcard,
  studyPlan,
  generatedQuestion,
  conversation,
  general,
}

/// Tone used to tint AI surface accents across the app.
enum AiResponseTone {
  insight,
  hint,
  tip,
  warning,
  error,
  success,
  info,
}

/// Lightweight plain-text response envelope returned by every AI tutor
/// use case. Carries the rendered body and the metadata downstream
/// widgets need to render correct chrome.
@immutable
class AIResponseEntity {
  const AIResponseEntity({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.createdAt,
    this.subtitle,
    this.tone = AiResponseTone.insight,
    this.confidence,
    this.model = 'prep-quest-tutor-v1',
    this.tags = const <String>[],
    this.relatedQuestionId,
    this.relatedLessonId,
    this.relatedTopic,
  });

  /// Stable identifier used by lists and persistence layers.
  final String id;

  /// What kind of response this is — drives the destination widget.
  final AiResponseKind kind;

  /// Headline shown on cards and chat bubbles.
  final String title;

  /// Rendered body text (markdown-light).
  final String body;

  /// Optional single-line support under the title.
  final String? subtitle;

  /// When the response was generated.
  final DateTime createdAt;

  /// Tone — tints cards, badges, and accents.
  final AiResponseTone tone;

  /// Optional confidence score (0..1). `null` when unknown.
  final double? confidence;

  /// Model label shown in metadata.
  final String model;

  /// Free-form tags (BCS, English, Grammar, etc.).
  final List<String> tags;

  /// Optional link back to a quiz question this response was generated for.
  final String? relatedQuestionId;

  /// Optional link back to a lesson.
  final String? relatedLessonId;

  /// Optional topic label (Geography, Tenses, …).
  final String? relatedTopic;

  AIResponseEntity copyWith({
    String? id,
    AiResponseKind? kind,
    String? title,
    String? body,
    String? subtitle,
    DateTime? createdAt,
    AiResponseTone? tone,
    double? confidence,
    String? model,
    List<String>? tags,
    String? relatedQuestionId,
    String? relatedLessonId,
    String? relatedTopic,
  }) {
    return AIResponseEntity(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      body: body ?? this.body,
      subtitle: subtitle ?? this.subtitle,
      createdAt: createdAt ?? this.createdAt,
      tone: tone ?? this.tone,
      confidence: confidence ?? this.confidence,
      model: model ?? this.model,
      tags: tags ?? this.tags,
      relatedQuestionId: relatedQuestionId ?? this.relatedQuestionId,
      relatedLessonId: relatedLessonId ?? this.relatedLessonId,
      relatedTopic: relatedTopic ?? this.relatedTopic,
    );
  }
}