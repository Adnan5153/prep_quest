import 'package:flutter/material.dart';

import 'ai_response_constants.dart';
import 'ai_response_models.dart';

/// Inline metadata strip rendered beneath the body of [AiResponseCard].
///
/// Each field is optional. Plain-text fields render as icon + label
/// pairs; enum fields render as compact pills. When [metadata.hasAny]
/// is `false`, the widget collapses to a [SizedBox.shrink] — callers
/// can pass `metadata: null` safely.
class AiResponseMetadataStrip extends StatelessWidget {
  const AiResponseMetadataStrip({super.key, required this.metadata});

  final AiResponseMetadata? metadata;

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

    if (metadata!.model != null) {
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
    if (metadata!.category != null) {
      if (children.isNotEmpty) {
        children.add(_Dot(foreground: muted));
      }
      children.add(
        _MetaIconLabel(
          icon: Icons.local_offer_rounded,
          text: metadata!.category!,
          foreground: muted,
        ),
      );
    }
    if (metadata!.confidence != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(width: AiResponseConstants.gapSm));
      }
      children.add(
        _ConfidencePill(value: metadata!.confidence!, isDark: isDark),
      );
    }
    if (metadata!.status != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(width: AiResponseConstants.gapSm));
      }
      children.add(_StatusPill(value: metadata!.status!, isDark: isDark));
    }
    if (metadata!.extra != null && metadata!.extra!.isNotEmpty) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(width: AiResponseConstants.gapSm));
      }
      children.add(
        Text(
          metadata!.extra!,
          style: theme.textTheme.labelSmall?.copyWith(color: muted),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: AiResponseConstants.gapMd),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AiResponseConstants.gapSm,
        runSpacing: AiResponseConstants.gapXs,
        children: children,
      ),
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
          size: AiResponseConstants.headerIconSize - 4,
          color: foreground,
        ),
        const SizedBox(width: AiResponseConstants.gapXxs),
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
      margin: const EdgeInsets.symmetric(horizontal: AiResponseConstants.gapSm),
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ConfidencePill extends StatelessWidget {
  const _ConfidencePill({required this.value, required this.isDark});

  final AiResponseConfidence value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final _Palette p = _palette();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AiResponseConstants.gapSm,
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        color: p.background,
        borderRadius: BorderRadius.circular(AiResponseConstants.pillRadius),
        border: Border.all(color: p.border, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 6.0,
            height: 6.0,
            decoration: BoxDecoration(
              color: p.foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AiResponseConstants.gapXxs),
          Text(
            p.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: p.foreground,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  _Palette _palette() {
    switch (value) {
      case AiResponseConfidence.high:
        return const _Palette(
          label: 'HIGH CONFIDENCE',
          foreground: Color(0xFF15803D),
          background: Color(0x3322C55E),
          border: Color(0x5522C55E),
        );
      case AiResponseConfidence.medium:
        return const _Palette(
          label: 'MEDIUM CONFIDENCE',
          foreground: Color(0xFFB45309),
          background: Color(0x33F59E0B),
          border: Color(0x55F59E0B),
        );
      case AiResponseConfidence.low:
        return const _Palette(
          label: 'LOW CONFIDENCE',
          foreground: Color(0xFFB91C1C),
          background: Color(0x33EF4444),
          border: Color(0x55EF4444),
        );
      case AiResponseConfidence.unknown:
        return _Palette(
          label: 'CONFIDENCE UNKNOWN',
          foreground: isDark ? Colors.white70 : Colors.black54,
          background: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
          border: isDark
              ? Colors.white.withValues(alpha: 0.18)
              : Colors.black.withValues(alpha: 0.12),
        );
    }
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.value, required this.isDark});

  final AiResponseStatus value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final _Palette p = _palette();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AiResponseConstants.gapSm,
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        color: p.background,
        borderRadius: BorderRadius.circular(AiResponseConstants.pillRadius),
        border: Border.all(color: p.border, width: 1.0),
      ),
      child: Text(
        p.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: p.foreground,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          fontSize: 10,
        ),
      ),
    );
  }

  _Palette _palette() {
    switch (value) {
      case AiResponseStatus.fresh:
        return const _Palette(
          label: 'NEW',
          foreground: Color(0xFF6366F1),
          background: Color(0x336366F1),
          border: Color(0x556366F1),
        );
      case AiResponseStatus.delivered:
        return const _Palette(
          label: 'DELIVERED',
          foreground: Color(0xFF15803D),
          background: Color(0x3322C55E),
          border: Color(0x5522C55E),
        );
      case AiResponseStatus.streaming:
        return const _Palette(
          label: 'STREAMING',
          foreground: Color(0xFF06B6D4),
          background: Color(0x3306B6D4),
          border: Color(0x5506B6D4),
        );
      case AiResponseStatus.failed:
        return const _Palette(
          label: 'FAILED',
          foreground: Color(0xFFB91C1C),
          background: Color(0x33EF4444),
          border: Color(0x55EF4444),
        );
      case AiResponseStatus.archived:
        return _Palette(
          label: 'ARCHIVED',
          foreground: isDark ? Colors.white70 : Colors.black54,
          background: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
          border: isDark
              ? Colors.white.withValues(alpha: 0.18)
              : Colors.black.withValues(alpha: 0.12),
        );
    }
  }
}

class _Palette {
  const _Palette({
    required this.label,
    required this.foreground,
    required this.background,
    required this.border,
  });

  final String label;
  final Color foreground;
  final Color background;
  final Color border;
}
