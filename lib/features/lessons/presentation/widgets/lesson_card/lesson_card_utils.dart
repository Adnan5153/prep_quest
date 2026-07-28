import 'package:flutter/material.dart';

class LessonCardUtils {
  const LessonCardUtils._();

  static Widget subjectAvatar({
    required ThemeData theme,
    required String subject,
  }) {
    final Color color = _subjectColor(subject, theme);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(subject),
        style: theme.textTheme.titleSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  static Color _subjectColor(String subject, ThemeData theme) {
    switch (subject.toLowerCase()) {
      case 'bangladesh affairs':
        return theme.colorScheme.primary;
      case 'english':
        return Colors.indigo;
      case 'mathematics':
      case 'strategy':
        return Colors.deepOrange;
      case 'library':
        return Colors.teal;
      default:
        return theme.colorScheme.secondary;
    }
  }

  static String _initials(String subject) {
    final List<String> parts = subject
        .split(' ')
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}