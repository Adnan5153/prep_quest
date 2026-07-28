import '../../domain/entities/quiz_report_entity.dart';

class QuizReportModel {
  const QuizReportModel({
    required this.id,
    required this.questionId,
    required this.quizId,
    required this.reasonId,
    required this.note,
    required this.createdAtIso,
    this.resolved = false,
  });

  final String id;
  final String questionId;
  final String quizId;
  final String reasonId;
  final String note;
  final String createdAtIso;
  final bool resolved;

  QuizReportEntity toEntity() {
    return QuizReportEntity(
      id: id,
      questionId: questionId,
      quizId: quizId,
      reason: _reasonFromId(reasonId),
      note: note,
      createdAt: DateTime.parse(createdAtIso),
      resolved: resolved,
    );
  }

  static QuizReportReason _reasonFromId(String id) {
    for (final QuizReportReason r in QuizReportReason.values) {
      if (r.name == id) return r;
    }
    return QuizReportReason.other;
  }
}
