import 'package:flutter/material.dart';

import 'ai_summary_constants.dart';
import 'ai_summary_models.dart';

class AiSummaryMetadataStrip extends StatelessWidget {
  const AiSummaryMetadataStrip({
    super.key,
    required this.metadata,
    required this.accent,
  });

  final AiSummaryMetadata? metadata;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    if (metadata == null || !metadata!.hasAny) {
      return const SizedBox.shrink();
    }

    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color foreground = isDark ? Colors.white : const Color(0xFF1F2937);
    final Color muted = foreground.withValues(alpha: 0.6);

    final List<Widget> children = <Widget>[];

    if (metadata!.category != null) {
      children.add(
        _MetaIconLabel(
          icon: Icons.local_offer_rounded,
          text: metadata!.category!,
          foreground: muted,
        ),
      );
    }
    if (metadata!.model != null) {
      if (children.isNotEmpty) {
        children.add(_Dot(foreground: muted));
      }
      children.add(
        _MetaIconLabel(
          icon: Icons.bolt_outlined,
          text: metadata!.model!,
          foreground: muted,
        ),
      );
    }
    if (metadata!.timestamp != null) {
      if (children.isNotEmpty) {
        children.add(_Dot(foreground: muted));
      }
      children.add(
        _MetaIconLabel(
          icon: Icons.schedule_rounded,
          text: metadata!.timestamp!,
          foreground: muted,
        ),
      );
    }
    if (metadata!.readingTime != null) {
      if (children.isNotEmpty) {
        children.add(_Dot(foreground: muted));
      }
      children.add(
        _MetaIconLabel(
          icon: Icons.timer_outlined,
          text: metadata!.readingTime!,
          foreground: muted,
        ),
      );
    }
    if (metadata!.wordCount != null) {
      if (children.isNotEmpty) {
        children.add(_Dot(foreground: muted));
      }
      children.add(
        _MetaIconLabel(
          icon: Icons.text_fields_rounded,
          text: metadata!.wordCount!,
          foreground: muted,
        ),
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AiSummaryConstants.gapSm,
      runSpacing: AiSummaryConstants.gapXs,
      children: children,
    );
  }
}

class _MetaIconLabel extends StatelessWidget {
  const _MetaIconLabel({
    required this.icon,
    required this.text,
    required this.foreground,
  });

  final IconData icon;
  final String text;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          icon,
          size: AiSummaryConstants.headerIconSize - 4,
          color: foreground,
        ),
        const SizedBox(width: AiSummaryConstants.gapXxs),
        Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.foreground});

  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3.0,
      height: 3.0,
      margin: const EdgeInsets.symmetric(horizontal: AiSummaryConstants.gapSm),
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
    );
  }
}
