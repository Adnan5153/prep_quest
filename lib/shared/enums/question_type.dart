/// Supported question types used across the quiz engine, question bank,
/// daily quiz, and mock test features.
///
/// The enum lives in `lib/shared/enums/` because question type is a
/// cross-cutting domain concept. Features can map this onto their own
/// rendering widgets without re-declaring it.
enum QuestionType {
  singleChoice,
  multiSelect,
  trueFalse,
  shortAnswer,
  imageChoice;

  String get id {
    switch (this) {
      case QuestionType.singleChoice:
        return 'single_choice';
      case QuestionType.multiSelect:
        return 'multi_select';
      case QuestionType.trueFalse:
        return 'true_false';
      case QuestionType.shortAnswer:
        return 'short_answer';
      case QuestionType.imageChoice:
        return 'image_choice';
    }
  }

  String get displayName {
    switch (this) {
      case QuestionType.singleChoice:
        return 'Single choice';
      case QuestionType.multiSelect:
        return 'Multiple choice';
      case QuestionType.trueFalse:
        return 'True / False';
      case QuestionType.shortAnswer:
        return 'Short answer';
      case QuestionType.imageChoice:
        return 'Image choice';
    }
  }
}