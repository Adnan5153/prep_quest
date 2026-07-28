import 'package:flutter/foundation.dart';

/// Tier of a quiz hint.
enum QuizHintTier { free, premium }

/// Domain entity for a single hint attached to a question.
///
/// Each hint has a cost (in coins) and a tier (free vs premium). The
/// presentation layer renders the appropriate badge and disclosure
/// pattern based on tier.
@immutable
class HintEntity {
  const HintEntity({
    required this.id,
    required this.text,
    this.tier = QuizHintTier.free,
    this.costCoins = 0,
  });

  final String id;
  final String text;
  final QuizHintTier tier;
  final int costCoins;

  bool get isPremium => tier == QuizHintTier.premium;
}
