import 'package:flutter/foundation.dart';

/// Category the user can pick when reporting a question.
enum QuizReportReason {
  incorrectAnswer,
  unclearQuestion,
  typo,
  duplicateQuestion,
  inappropriateContent,
  other,
}

/// Domain entity representing a single question report.
///
/// Reports are persisted through the repository contract once wired
/// to Firebase; the local mock implementation logs them in memory.
@immutable
class QuizReportEntity {
  const QuizReportEntity({
    required this.id,
    required this.questionId,
    required this.quizId,
    required this.reason,
    required this.note,
    required this.createdAt,
    this.resolved = false,
  });

  final String id;
  final String questionId;
  final String quizId;
  final QuizReportReason reason;
  final String note;
  final DateTime createdAt;
  final bool resolved;
}
