import '../../domain/entities/ai_response_entity.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/study_plan.dart';
import '../extensions/ai_tutor_extensions.dart';

/// Lightweight, presentation-only helpers for the AI tutor screens.
/// Pure functions; no Riverpod, no Flutter widget imports.
class AiTutorFormatters {
  const AiTutorFormatters._();

  /// Renders a confidence score (0..1) as a friendly percentage.
  static String formatConfidence(double? value) {
    if (value == null) return '—';
    final int pct = (value * 100).round();
    return '$pct%';
  }

  /// Title-cases an arbitrary user prompt for list display.
  static String prettifyTitle(String text) {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) return 'Untitled';
    if (trimmed.length <= 40) return trimmed;
    return '${trimmed.substring(0, 40)}…';
  }

  /// Returns a stable badge label for a response kind.
  static String badgeForKind(AiResponseKind kind) => kind.label;

  /// Returns a stable badge label for a tone.
  static String badgeForTone(AiResponseTone tone) {
    switch (tone) {
      case AiResponseTone.insight:
        return 'INSIGHT';
      case AiResponseTone.hint:
        return 'HINT';
      case AiResponseTone.tip:
        return 'TIP';
      case AiResponseTone.warning:
        return 'WARNING';
      case AiResponseTone.error:
        return 'ERROR';
      case AiResponseTone.success:
        return 'SUCCESS';
      case AiResponseTone.info:
        return 'INFO';
    }
  }

  /// Renders a duration in minutes as "1h 30m" or "20m".
  static String formatMinutes(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final int hours = minutes ~/ 60;
    final int rem = minutes % 60;
    if (rem == 0) return '${hours}h';
    return '${hours}h ${rem}m';
  }

  /// Renders a relative time (e.g. "2h ago", "Yesterday").
  static String formatRelative(DateTime when, {DateTime? now}) {
    final DateTime reference = now ?? DateTime.now();
    final Duration diff = reference.difference(when);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${when.year}-${when.month.toString().padLeft(2, '0')}-${when.day.toString().padLeft(2, '0')}';
  }

  /// Summarises a conversation's last message for list rows.
  static String conversationPreview(Conversation conversation) {
    final ConversationMessage? last = conversation.lastMessage;
    if (last == null) return 'No messages yet';
    final String body = last.content.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (body.length <= 80) return body;
    return '${body.substring(0, 80)}…';
  }

  /// Sums the estimated minutes across a study plan.
  static String formatPlanTotal(StudyPlan plan) {
    return formatMinutes(plan.totalMinutes);
  }
}