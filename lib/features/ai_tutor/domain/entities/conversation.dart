import 'package:flutter/foundation.dart';

import 'ai_response_entity.dart';

/// A single message inside a [Conversation]. Mirrors the `ChatMessage`
/// shape used by the chat widget family but stays Flutter-independent.
@immutable
class ConversationMessage {
  const ConversationMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.relatedQuestionId,
    this.relatedLessonId,
  });

  final String id;
  final ConversationRole role;
  final String content;
  final DateTime createdAt;
  final String? relatedQuestionId;
  final String? relatedLessonId;

  ConversationMessage copyWith({
    String? id,
    ConversationRole? role,
    String? content,
    DateTime? createdAt,
    String? relatedQuestionId,
    String? relatedLessonId,
  }) {
    return ConversationMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      relatedQuestionId: relatedQuestionId ?? this.relatedQuestionId,
      relatedLessonId: relatedLessonId ?? this.relatedLessonId,
    );
  }
}

enum ConversationRole { user, assistant, system }

/// A multi-turn conversation that can be replayed, persisted, and
/// branched into focused follow-up actions.
@immutable
class Conversation {
  const Conversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
    this.subtitle,
    this.relatedQuestionId,
    this.relatedLessonId,
    this.tags = const <String>[],
  });

  final String id;
  final String title;
  final String? subtitle;
  final List<ConversationMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? relatedQuestionId;
  final String? relatedLessonId;
  final List<String> tags;

  ConversationMessage? get lastMessage =>
      messages.isEmpty ? null : messages.last;

  int get messageCount => messages.length;

  Conversation copyWith({
    String? id,
    String? title,
    String? subtitle,
    List<ConversationMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? relatedQuestionId,
    String? relatedLessonId,
    List<String>? tags,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      relatedQuestionId: relatedQuestionId ?? this.relatedQuestionId,
      relatedLessonId: relatedLessonId ?? this.relatedLessonId,
      tags: tags ?? this.tags,
    );
  }
}

/// A single user-typed prompt and its metadata. Used by the Smart Prompt
/// Studio and the Prompt History screen.
@immutable
class PromptEntry {
  const PromptEntry({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.response,
    this.category,
    this.tags = const <String>[],
    this.isFavorite = false,
  });

  final String id;
  final String text;
  final DateTime createdAt;
  final AIResponseEntity response;
  final String? category;
  final List<String> tags;
  final bool isFavorite;

  PromptEntry copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    AIResponseEntity? response,
    String? category,
    List<String>? tags,
    bool? isFavorite,
  }) {
    return PromptEntry(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      response: response ?? this.response,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}