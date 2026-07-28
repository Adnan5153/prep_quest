import '../../domain/entities/conversation.dart';

class ConversationMessageModel {
  const ConversationMessageModel({
    required this.id,
    required this.roleId,
    required this.content,
    required this.createdAtIso,
    this.relatedQuestionId,
    this.relatedLessonId,
  });

  final String id;
  final String roleId;
  final String content;
  final String createdAtIso;
  final String? relatedQuestionId;
  final String? relatedLessonId;

  ConversationMessage toEntity() {
    return ConversationMessage(
      id: id,
      role: _roleFromId(roleId),
      content: content,
      createdAt: DateTime.parse(createdAtIso),
      relatedQuestionId: relatedQuestionId,
      relatedLessonId: relatedLessonId,
    );
  }

  static ConversationRole _roleFromId(String id) {
    for (final ConversationRole r in ConversationRole.values) {
      if (r.name == id) return r;
    }
    return ConversationRole.assistant;
  }
}

class ConversationModel {
  const ConversationModel({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAtIso,
    required this.updatedAtIso,
    this.subtitle,
    this.relatedQuestionId,
    this.relatedLessonId,
    this.tags = const <String>[],
  });

  final String id;
  final String title;
  final String? subtitle;
  final List<ConversationMessageModel> messages;
  final String createdAtIso;
  final String updatedAtIso;
  final String? relatedQuestionId;
  final String? relatedLessonId;
  final List<String> tags;

  Conversation toEntity() {
    return Conversation(
      id: id,
      title: title,
      subtitle: subtitle,
      messages: messages
          .map((ConversationMessageModel m) => m.toEntity())
          .toList(growable: false),
      createdAt: DateTime.parse(createdAtIso),
      updatedAt: DateTime.parse(updatedAtIso),
      relatedQuestionId: relatedQuestionId,
      relatedLessonId: relatedLessonId,
      tags: List<String>.unmodifiable(tags),
    );
  }

  ConversationModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    List<ConversationMessageModel>? messages,
    String? createdAtIso,
    String? updatedAtIso,
    String? relatedQuestionId,
    String? relatedLessonId,
    List<String>? tags,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      messages: messages ?? this.messages,
      createdAtIso: createdAtIso ?? this.createdAtIso,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
      relatedQuestionId: relatedQuestionId ?? this.relatedQuestionId,
      relatedLessonId: relatedLessonId ?? this.relatedLessonId,
      tags: tags ?? this.tags,
    );
  }
}