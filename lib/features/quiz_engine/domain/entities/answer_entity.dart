import 'package:flutter/foundation.dart';

/// Domain entity for a single answer option attached to a question.
///
/// Pure data; the [QuizOption] widget maps this onto a tappable tile
/// during a quiz session.
@immutable
class AnswerEntity {
  const AnswerEntity({
    required this.id,
    required this.text,
    this.imageUrl,
    this.isCorrect = false,
  });

  final String id;
  final String text;
  final String? imageUrl;
  final bool isCorrect;
}
