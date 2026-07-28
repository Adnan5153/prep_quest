import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';

class AiErrorStateMetadata extends StatelessWidget {
  const AiErrorStateMetadata({
    super.key,
    required this.code,
    required this.attempts,
    required this.accent,
    required this.isDark,
  });

  final String? code;
  final int? attempts;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (code == null && attempts == null) {
      return const SizedBox.shrink();
    }

    final List<Widget> chips = <Widget>[];

    if (code != null) {
      chips.add(
        _Chip(
          label: code!.toUpperCase(),
          accent: accent,
          isDark: isDark,
          icon: Icons.tag_rounded,
        ),
      );
    }

    if (attempts != null) {
      chips.add(
        _Chip(
          label: 'Retry $attempts/5',
          accent: accent,
          isDark: isDark,
          icon: Icons.refresh_rounded,
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: chips,
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.accent,
    required this.isDark,
    required this.icon,
  });

  final String label;
  final Color accent;
  final bool isDark;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.18 : 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
