import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_constants.dart';
import '../../../../../../core/widgets/ai/shimmer_loading_text.dart';
import '../../../providers/widget_builder_provider.dart';

/// Production-ready preview for [ShimmerLoadingText] covering single
/// lines, paragraphs, AI responses, summary cards, compact and large
/// scales, brand accents, and theme adaptation.
class AiShimmerLoadingTextPreview extends StatelessWidget {
  const AiShimmerLoadingTextPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  static const List<double> _sampleLineWidths = <double>[
    1.00,
    0.92,
    0.84,
    0.96,
    0.72,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth < 480
            ? constraints.maxWidth
            : (constraints.maxWidth < 900 ? 600 : 760);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _SectionLabel(text: 'Single Line'),
                  const ShimmerLoadingText(lineCount: 1),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Two Lines'),
                  const ShimmerLoadingText(
                    lineCount: 2,
                    lineWidths: <double>[0.96, 0.62],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Paragraph'),
                  const ShimmerLoadingText(
                    lineCount: 6,
                    lineSpacing: AppSpacing.sm,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'AI Response Loading'),
                  const ShimmerLoadingText(
                    lineCount: 5,
                    lineHeight: 16,
                    lineSpacing: AppSpacing.sm,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    lineWidths: _sampleLineWidths,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Summary Loading'),
                  Card(
                    elevation: 0,
                    color: AiConstants.aiViolet.withValues(alpha: 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.md),
                      side: BorderSide(
                        color: AiConstants.aiViolet.withValues(alpha: 0.18),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: ShimmerLoadingText(
                        lineCount: 5,
                        lineHeight: 14,
                        lineSpacing: AppSpacing.sm,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        lineWidths: _sampleLineWidths,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Compact'),
                  const ShimmerLoadingText(
                    lineCount: 4,
                    lineHeight: 8,
                    lineSpacing: AppSpacing.xs,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Large'),
                  const ShimmerLoadingText(
                    lineCount: 4,
                    lineHeight: 22,
                    lineSpacing: AppSpacing.md,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Custom Accent — Brand Orange'),
                  ShimmerLoadingText(
                    lineCount: 5,
                    lineHeight: 16,
                    lineSpacing: AppSpacing.sm,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    lineWidths: _sampleLineWidths,
                    accent: AppColors.accent,
                    semanticLabel: 'Brand-orange shimmer loading',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _ThemeTile(
                    brightness: Brightness.dark,
                    label: 'Dark Theme',
                    child: const ShimmerLoadingText(
                      lineCount: 5,
                      lineHeight: 16,
                      lineSpacing: AppSpacing.sm,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      lineWidths: _sampleLineWidths,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _ThemeTile(
                    brightness: Brightness.light,
                    label: 'Light Theme',
                    child: const ShimmerLoadingText(
                      lineCount: 5,
                      lineHeight: 16,
                      lineSpacing: AppSpacing.sm,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      lineWidths: _sampleLineWidths,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.brightness,
    required this.child,
    required this.label,
  });

  final Brightness brightness;
  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _SectionLabel(text: label),
        Theme(
          data: Theme.of(context).copyWith(
            brightness: brightness,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AiConstants.aiViolet,
              brightness: brightness,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: brightness == Brightness.dark
                  ? const Color(0xFF0B0F14)
                  : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(AppSpacing.md),
              border: Border.all(
                color: AiConstants.aiViolet.withValues(alpha: 0.18),
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
