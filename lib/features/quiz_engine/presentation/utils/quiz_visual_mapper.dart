import '../../../../shared/enums/question_type.dart';
import '../../domain/entities/answer_entity.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/entities/quiz_result_entity.dart';

/// Maps domain entities onto pure-data visual descriptors consumed by
/// presentation widgets. Keeps widgets free of business logic.
class QuizVisualMapper {
  const QuizVisualMapper._();

  static QuizCardVisual toQuizCardVisual(QuizEntity quiz) {
    final int total = quiz.questions.length;
    final int points = quiz.totalPoints;
    return QuizCardVisual(
      id: quiz.id,
      title: quiz.title,
      subject: quiz.subject,
      kindId: quiz.kind.name,
      difficultyId: quiz.difficulty.name,
      questionCount: total,
      totalPoints: points,
      rewardXp: quiz.rewardXp,
      rewardCoins: quiz.rewardCoins,
      durationLabel: quiz.isTimed
          ? '${(quiz.timeLimitSeconds! / 60).round()} min'
          : 'Self-paced',
      tagList: List<String>.unmodifiable(quiz.tags),
      isPremium: quiz.isPremium,
      isTimed: quiz.isTimed,
    );
  }

  static QuizOptionVisual toQuizOptionVisual(
    AnswerEntity answer, {
    required int index,
    required bool isSelected,
    required bool revealCorrectness,
    required bool isCorrectAnswer,
  }) {
    return QuizOptionVisual(
      id: answer.id,
      index: index,
      letter: _letterLabel(index),
      text: answer.text,
      isSelected: isSelected,
      revealCorrectness: revealCorrectness,
      isCorrectAnswer: isCorrectAnswer,
    );
  }

  static QuizResultVisual toQuizResultVisual(QuizResultEntity result) {
    return QuizResultVisual(
      scorePercent: result.scorePercent,
      correctCount: result.correctCount,
      incorrectCount: result.incorrectCount,
      skippedCount: result.skippedCount,
      timeSpentSeconds: result.timeSpentSeconds,
      totalQuestions: result.questionResults.length,
      passed: result.passed,
      rewardXp: result.rewardXp,
      rewardCoins: result.rewardCoins,
    );
  }

  static String _letterLabel(int index) {
    const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (index < 0 || index >= alphabet.length) return '?';
    return alphabet[index];
  }

  static QuestionTypeVisual toQuestionTypeVisual(QuestionType type) {
    switch (type) {
      case QuestionType.singleChoice:
        return const QuestionTypeVisual(
          label: 'Single choice',
          iconKey: 'radio',
        );
      case QuestionType.multiSelect:
        return const QuestionTypeVisual(
          label: 'Multiple choice',
          iconKey: 'checkbox',
        );
      case QuestionType.trueFalse:
        return const QuestionTypeVisual(
          label: 'True / False',
          iconKey: 'toggle',
        );
      case QuestionType.shortAnswer:
        return const QuestionTypeVisual(
          label: 'Short answer',
          iconKey: 'edit',
        );
      case QuestionType.imageChoice:
        return const QuestionTypeVisual(
          label: 'Image choice',
          iconKey: 'image',
        );
    }
  }
}

class QuizCardVisual {
  const QuizCardVisual({
    required this.id,
    required this.title,
    required this.subject,
    required this.kindId,
    required this.difficultyId,
    required this.questionCount,
    required this.totalPoints,
    required this.rewardXp,
    required this.rewardCoins,
    required this.durationLabel,
    required this.tagList,
    required this.isPremium,
    required this.isTimed,
  });

  final String id;
  final String title;
  final String subject;
  final String kindId;
  final String difficultyId;
  final int questionCount;
  final int totalPoints;
  final int rewardXp;
  final int rewardCoins;
  final String durationLabel;
  final List<String> tagList;
  final bool isPremium;
  final bool isTimed;
}

class QuizOptionVisual {
  const QuizOptionVisual({
    required this.id,
    required this.index,
    required this.letter,
    required this.text,
    required this.isSelected,
    required this.revealCorrectness,
    required this.isCorrectAnswer,
  });

  final String id;
  final int index;
  final String letter;
  final String text;
  final bool isSelected;
  final bool revealCorrectness;
  final bool isCorrectAnswer;
}

class QuizResultVisual {
  const QuizResultVisual({
    required this.scorePercent,
    required this.correctCount,
    required this.incorrectCount,
    required this.skippedCount,
    required this.timeSpentSeconds,
    required this.totalQuestions,
    required this.passed,
    required this.rewardXp,
    required this.rewardCoins,
  });

  final int scorePercent;
  final int correctCount;
  final int incorrectCount;
  final int skippedCount;
  final int timeSpentSeconds;
  final int totalQuestions;
  final bool passed;
  final int rewardXp;
  final int rewardCoins;
}

class QuestionTypeVisual {
  const QuestionTypeVisual({required this.label, required this.iconKey});

  final String label;
  final String iconKey;
}