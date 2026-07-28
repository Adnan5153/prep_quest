import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/loading/ai_loading_avatar.dart';
import '../../../../../../core/widgets/ai/loading/ai_loading_card.dart';
import '../../../../../../core/widgets/ai/loading/ai_loading_section.dart';
import '../../../../../../core/widgets/ai/loading/ai_loading_text.dart';
import '../../../providers/widget_builder_provider.dart';

class AiLoadingCardPreview extends StatelessWidget {
  const AiLoadingCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth < 480
            ? constraints.maxWidth
            : (constraints.maxWidth < 900 ? 600 : 720);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _SectionLabel(text: 'Configured via controls'),
                  _buildControlled(context),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'Compact — title + subtitle only'),
                  AiLoadingCard(
                    isDark: _resolveBrightness(
                      provider.aiLoadingCardBrightness,
                    ),
                    showAvatar: false,
                    showBody: false,
                    semanticLabel: 'Compact loading card',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const _SectionLabel(
                    text: 'Avatar block — primitive showcase',
                  ),
                  AiLoadingAvatar(),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'Single shimmer bar — primitive'),
                  const AiLoadingText(width: 240, height: 12),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'Expanded — full card with footer'),
                  AiLoadingCard(
                    isDark: _resolveBrightness(
                      provider.aiLoadingCardBrightness,
                    ),
                    showAvatar: true,
                    showTitle: true,
                    showSubtitle: true,
                    showBody: true,
                    showFooter: true,
                    bodyLineCount: 5,
                    semanticLabel: 'Expanded loading card',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'Header-only — no body, no footer'),
                  AiLoadingCard(
                    isDark: _resolveBrightness(
                      provider.aiLoadingCardBrightness,
                    ),
                    showAvatar: true,
                    showTitle: true,
                    showSubtitle: true,
                    showBody: false,
                    showFooter: false,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(
                    text: 'Without animation (reduced-motion fallback)',
                  ),
                  AiLoadingCard(
                    isDark: _resolveBrightness(
                      provider.aiLoadingCardBrightness,
                    ),
                    animationEnabled: false,
                    showAvatar: true,
                    showTitle: true,
                    showSubtitle: true,
                    showBody: true,
                    showFooter: false,
                    bodyLineCount: 3,
                    semanticLabel: 'Static loading card',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'Elevated card with soft shadow'),
                  AiLoadingCard(
                    isDark: _resolveBrightness(
                      provider.aiLoadingCardBrightness,
                    ),
                    elevation: 2,
                    showAvatar: true,
                    showTitle: true,
                    showSubtitle: true,
                    showBody: true,
                    showFooter: false,
                    bodyLineCount: 3,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(
                    text: 'Section — 4 stacked skeleton cards',
                  ),
                  AiLoadingSection(
                    isDark: _resolveBrightness(
                      provider.aiLoadingCardBrightness,
                    ),
                    itemCount: 4,
                    showAvatar: true,
                    showTitle: true,
                    showSubtitle: true,
                    showBody: true,
                    showFooter: false,
                    bodyLineCount: 3,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(
                    text: 'Section without avatar — pure list',
                  ),
                  AiLoadingSection(
                    isDark: _resolveBrightness(
                      provider.aiLoadingCardBrightness,
                    ),
                    itemCount: 5,
                    showAvatar: false,
                    showTitle: true,
                    showSubtitle: true,
                    showBody: true,
                    showFooter: false,
                    bodyLineCount: 2,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(
                    text: 'Full-bleed card — implicit parent width',
                  ),
                  AiLoadingCard(
                    isDark: _resolveBrightness(
                      provider.aiLoadingCardBrightness,
                    ),
                    showAvatar: true,
                    showTitle: true,
                    showSubtitle: false,
                    showBody: true,
                    showFooter: true,
                    bodyLineCount: 4,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlled(BuildContext context) {
    return AiLoadingCard(
      isDark: _resolveBrightness(provider.aiLoadingCardBrightness),
      showAvatar: provider.aiLoadingCardShowAvatar,
      showTitle: provider.aiLoadingCardShowTitle,
      showSubtitle: provider.aiLoadingCardShowSubtitle,
      showBody: provider.aiLoadingCardShowBody,
      showFooter: provider.aiLoadingCardShowFooter,
      bodyLineCount: provider.aiLoadingCardBodyLineCount,
      elevation: provider.aiLoadingCardElevation,
      animationEnabled: provider.aiLoadingCardAnimationEnabled,
      semanticLabel: provider.aiLoadingCardSemanticLabel,
    );
  }

  bool? _resolveBrightness(String value) {
    switch (value) {
      case 'light':
        return false;
      case 'dark':
        return true;
      default:
        return null;
    }
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
