import 'package:flutter/foundation.dart';

/// A single AI-generated flashcard.
@immutable
class Flashcard {
  const Flashcard({
    required this.id,
    required this.front,
    required this.back,
    required this.topic,
    required this.deckId,
    this.hint,
    this.tags = const <String>[],
    this.difficulty = FlashcardDifficulty.medium,
  });

  final String id;
  final String deckId;
  final String front;
  final String back;
  final String topic;
  final String? hint;
  final List<String> tags;
  final FlashcardDifficulty difficulty;

  Flashcard copyWith({
    String? id,
    String? deckId,
    String? front,
    String? back,
    String? topic,
    String? hint,
    List<String>? tags,
    FlashcardDifficulty? difficulty,
  }) {
    return Flashcard(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      front: front ?? this.front,
      back: back ?? this.back,
      topic: topic ?? this.topic,
      hint: hint ?? this.hint,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

enum FlashcardDifficulty { easy, medium, hard }

/// A named collection of [Flashcard]s produced by the AI tutor.
@immutable
class FlashcardDeck {
  const FlashcardDeck({
    required this.id,
    required this.title,
    required this.topic,
    required this.cards,
    required this.createdAt,
    this.description,
    this.subtitle,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final String topic;
  final List<Flashcard> cards;
  final DateTime createdAt;

  int get cardCount => cards.length;
}