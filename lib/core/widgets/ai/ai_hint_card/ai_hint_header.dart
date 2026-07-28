import 'package:flutter/material.dart';
import 'ai_hint_badge.dart';
import 'ai_hint_constants.dart';

class AiHintHeader extends StatelessWidget {
  const AiHintHeader({
    super.key,
    required this.title,
    required this.type,
    this.badgeText,
    this.showBadge = true,
  });

  final String title;
  final AiHintType type;
  final String? badgeText;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = AiHintConstants.colorForType(type);
    final icon = AiHintConstants.iconForType(type);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: AiHintConstants.iconSize, color: accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  if (showBadge) ...[
                    const SizedBox(width: 8),
                    AiHintBadge(
                      type: type,
                      label: badgeText ?? AiHintConstants.labelForType(type),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'AI Analysis',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.textTheme.labelSmall?.color?.withValues(
                    alpha: 0.5,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
