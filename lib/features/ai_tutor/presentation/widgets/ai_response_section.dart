import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/ai/ai_response_card.dart';
import '../../domain/entities/ai_response_entity.dart';
import '../extensions/ai_tutor_extensions.dart';
import '../utils/ai_tutor_formatters.dart';

/// Wraps a generic [AiResponseCard] with AI Tutor-specific defaults
/// (badge labels, metadata). Reused across every generator screen so
/// the visual language stays consistent.
class AiTutorResponseSection extends StatelessWidget {
  const AiTutorResponseSection({
    super.key,
    required this.response,
    this.onRegenerate,
    this.onFavorite,
    this.isFavorite = false,
    this.expanded = true,
  });

  final AIResponseEntity response;
  final VoidCallback? onRegenerate;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return AiResponseCard(
      title: response.title,
      body: response.body,
      subtitle: response.subtitle,
      badgeLabel: AiTutorFormatters.badgeForTone(response.tone),
      icon: response.kind.icon,
      metadata: AiResponseMetadata(
        model: response.model,
        category: response.relatedTopic,
        extra: response.confidence == null
            ? null
            : 'Confidence ${AiTutorFormatters.formatConfidence(response.confidence)}',
      ),
      actions: AiResponseActions(
        onRegenerate: onRegenerate,
        onFavorite: onFavorite,
        isFavorite: isFavorite,
        canExpand: false,
      ),
      expanded: expanded,
    );
  }
}

/// Lightweight loading placeholder for the response area while the
/// tutor is working.
class AiTutorResponseLoading extends StatelessWidget {
  const AiTutorResponseLoading({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                message ?? 'Crafting your response…',
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _Bar(widthFactor: 0.95, theme: theme),
          const SizedBox(height: AppSpacing.xs),
          _Bar(widthFactor: 0.85, theme: theme),
          const SizedBox(height: AppSpacing.xs),
          _Bar(widthFactor: 0.6, theme: theme),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.widthFactor, required this.theme});

  final double widthFactor;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

/// Error placeholder used when a generator fails. Surfaces the
/// failure message and a retry button.
class AiTutorResponseError extends StatelessWidget {
  const AiTutorResponseError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.error_outline, color: theme.colorScheme.error),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Could not generate',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message ?? 'The tutor could not respond right now.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }
}