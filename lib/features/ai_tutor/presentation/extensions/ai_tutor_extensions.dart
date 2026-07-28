import 'package:flutter/material.dart';

import '../../domain/entities/ai_response_entity.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/entities/generated_question.dart';
import '../../domain/entities/study_plan.dart';

/// Maps the AI tutor's metadata enums onto iconography so any widget
/// that needs to render a kind/tone/difficulty glyph can stay
/// presentation-agnostic.
extension AiTutorKindIcons on AiResponseKind {
  IconData get icon {
    switch (this) {
      case AiResponseKind.hint:
        return Icons.lightbulb_outline_rounded;
      case AiResponseKind.explanation:
        return Icons.menu_book_rounded;
      case AiResponseKind.simplification:
        return Icons.compress_rounded;
      case AiResponseKind.summary:
        return Icons.summarize_rounded;
      case AiResponseKind.flashcard:
        return Icons.style_rounded;
      case AiResponseKind.studyPlan:
        return Icons.event_note_rounded;
      case AiResponseKind.generatedQuestion:
        return Icons.quiz_outlined;
      case AiResponseKind.conversation:
        return Icons.chat_bubble_outline_rounded;
      case AiResponseKind.general:
        return Icons.auto_awesome_rounded;
    }
  }

  String get label {
    switch (this) {
      case AiResponseKind.hint:
        return 'Hint';
      case AiResponseKind.explanation:
        return 'Explanation';
      case AiResponseKind.simplification:
        return 'Simplify';
      case AiResponseKind.summary:
        return 'Summary';
      case AiResponseKind.flashcard:
        return 'Flashcards';
      case AiResponseKind.studyPlan:
        return 'Study plan';
      case AiResponseKind.generatedQuestion:
        return 'Practice';
      case AiResponseKind.conversation:
        return 'Chat';
      case AiResponseKind.general:
        return 'Insight';
    }
  }
}

extension AiTutorToneColors on AiResponseTone {
  /// Returns the *primary* tonal accent. Widgets may layer in
  /// additional tints via their own theme.
  Color accent(ColorScheme scheme) {
    switch (this) {
      case AiResponseTone.insight:
        return scheme.primary;
      case AiResponseTone.hint:
        return scheme.tertiary;
      case AiResponseTone.tip:
        return scheme.secondary;
      case AiResponseTone.warning:
        return scheme.error;
      case AiResponseTone.error:
        return scheme.error;
      case AiResponseTone.success:
        return Colors.green.shade600;
      case AiResponseTone.info:
        return scheme.primary;
    }
  }
}

extension FlashcardDifficultyLabels on FlashcardDifficulty {
  String get label {
    switch (this) {
      case FlashcardDifficulty.easy:
        return 'Easy';
      case FlashcardDifficulty.medium:
        return 'Medium';
      case FlashcardDifficulty.hard:
        return 'Hard';
    }
  }
}

extension GeneratedQuestionDifficultyLabels on GeneratedQuestionDifficulty {
  String get label {
    switch (this) {
      case GeneratedQuestionDifficulty.easy:
        return 'Easy';
      case GeneratedQuestionDifficulty.medium:
        return 'Medium';
      case GeneratedQuestionDifficulty.hard:
        return 'Hard';
    }
  }
}

extension StudyTaskKindIcons on StudyTaskKind {
  IconData get icon {
    switch (this) {
      case StudyTaskKind.lesson:
        return Icons.menu_book_rounded;
      case StudyTaskKind.practice:
        return Icons.quiz_outlined;
      case StudyTaskKind.review:
        return Icons.refresh_rounded;
      case StudyTaskKind.mockTest:
        return Icons.assignment_outlined;
      case StudyTaskKind.flashcards:
        return Icons.style_rounded;
      case StudyTaskKind.rest:
        return Icons.self_improvement_rounded;
    }
  }

  String get label {
    switch (this) {
      case StudyTaskKind.lesson:
        return 'Lesson';
      case StudyTaskKind.practice:
        return 'Practice';
      case StudyTaskKind.review:
        return 'Review';
      case StudyTaskKind.mockTest:
        return 'Mock test';
      case StudyTaskKind.flashcards:
        return 'Flashcards';
      case StudyTaskKind.rest:
        return 'Rest';
    }
  }
}

extension ConversationRoleIcons on ConversationRole {
  IconData get icon {
    switch (this) {
      case ConversationRole.user:
        return Icons.person_rounded;
      case ConversationRole.assistant:
        return Icons.auto_awesome_rounded;
      case ConversationRole.system:
        return Icons.settings_suggest_rounded;
    }
  }
}