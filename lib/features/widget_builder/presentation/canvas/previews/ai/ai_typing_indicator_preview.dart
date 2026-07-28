import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_constants.dart';
import '../../../../../../core/widgets/ai/typing_indicator.dart';
import '../../../providers/widget_builder_provider.dart';

class AiTypingIndicatorPreview extends StatelessWidget {
  const AiTypingIndicatorPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

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
                  const _SectionLabel(text: 'Default'),
                  const TypingIndicator(),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Compact'),
                  const TypingIndicator(
                    dotSize: 6,
                    spacing: 4,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Large'),
                  const TypingIndicator(
                    dotSize: 12,
                    spacing: 10,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'With Avatar'),
                  const TypingIndicator(avatar: _Avatar(size: 32)),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'With Label'),
                  const TypingIndicator(label: 'PrepQuest AI is typing'),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Avatar and Label'),
                  const TypingIndicator(
                    avatar: _Avatar(size: 32),
                    label: 'PrepQuest AI is thinking',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Pulse Animation'),
                  const TypingIndicator(
                    label: 'Generating response',
                    pulse: true,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Custom Accent — Brand Orange'),
                  TypingIndicator(
                    color: const Color(0xFFF5A623),
                    label: 'Custom accent',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _ThemeTile(
                    brightness: Brightness.light,
                    label: 'Light Theme',
                    child: const TypingIndicator(
                      label: 'PrepQuest AI is typing',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _ThemeTile(
                    brightness: Brightness.dark,
                    label: 'Dark Theme',
                    child: const TypingIndicator(
                      label: 'PrepQuest AI is typing',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Chat Conversation'),
                  const _ChatConversationPreview(),
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

class _Avatar extends StatelessWidget {
  const _Avatar({this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AiConstants.aiViolet, AiConstants.aiIndigo],
        ),
      ),
      child: const Icon(
        Icons.auto_awesome_rounded,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.brightness,
    required this.label,
    required this.child,
  });

  final Brightness brightness;
  final String label;
  final Widget child;

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

class _ChatConversationPreview extends StatelessWidget {
  const _ChatConversationPreview();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(color: AiConstants.aiViolet.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Bubble(
            align: AlignmentDirectional.centerEnd,
            color: AiConstants.aiViolet,
            textColor: Colors.white,
            text: 'What is dependency injection?',
          ),
          const SizedBox(height: AppSpacing.md),
          const TypingIndicator(
            avatar: _Avatar(size: 28),
            label: 'PrepQuest AI is typing',
          ),
          const SizedBox(height: AppSpacing.md),
          _Bubble(
            align: AlignmentDirectional.centerStart,
            color: theme.colorScheme.surfaceContainerHigh,
            textColor: theme.colorScheme.onSurface,
            text:
                'Dependency injection decouples how an object is created from how it is used.',
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.align,
    required this.color,
    required this.textColor,
    required this.text,
  });

  final AlignmentDirectional align;
  final Color color;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        child: Text(text, style: TextStyle(color: textColor, fontSize: 13)),
      ),
    );
  }
}
