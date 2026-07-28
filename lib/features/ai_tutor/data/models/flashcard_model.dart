import '../../domain/entities/flashcard.dart';

class FlashcardModel {
  const FlashcardModel({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    required this.topic,
    required this.difficultyId,
    this.hint,
    this.tags = const <String>[],
  });

  final String id;
  final String deckId;
  final String front;
  final String back;
  final String topic;
  final String? hint;
  final List<String> tags;
  final String difficultyId;

  Flashcard toEntity() {
    return Flashcard(
      id: id,
      deckId: deckId,
      front: front,
      back: back,
      topic: topic,
      hint: hint,
      tags: List<String>.unmodifiable(tags),
      difficulty: _difficultyFromId(difficultyId),
    );
  }

  static FlashcardDifficulty _difficultyFromId(String id) {
    for (final FlashcardDifficulty d in FlashcardDifficulty.values) {
      if (d.name == id) return d;
    }
    return FlashcardDifficulty.medium;
  }
}

class FlashcardDeckModel {
  const FlashcardDeckModel({
    required this.id,
    required this.title,
    required this.topic,
    required this.cards,
    required this.createdAtIso,
    this.subtitle,
    this.description,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final String topic;
  final List<FlashcardModel> cards;
  final String createdAtIso;

  FlashcardDeck toEntity() {
    return FlashcardDeck(
      id: id,
      title: title,
      subtitle: subtitle,
      description: description,
      topic: topic,
      cards: cards
          .map((FlashcardModel c) => c.toEntity())
          .toList(growable: false),
      createdAt: DateTime.parse(createdAtIso),
    );
  }
}