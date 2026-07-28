import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import 'ai_response_constants.dart';

/// Single icon-label tile used inside [AiResponseFooter].
///
/// Renders an icon, an optional label, and an optional spinner when
/// [pending] is `true`. Tap target matches [AppSizes.minTapTarget] so
/// it satisfies accessibility guidelines.
class AiResponseActionTile extends StatelessWidget {
  const AiResponseActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.foreground,
    required this.muted,
    this.emphasised = false,
    this.pending = false,
    this.semanticsLabel,
  });

  /// Icon shown when [pending] is `false`.
  final IconData icon;

  /// Visible label rendered next to the icon.
  final String label;

  /// Tap handler. Called with no arguments.
  final VoidCallback onTap;

  /// Foreground colour used when the tile is in its default or
  /// emphasised state.
  final Color foreground;

  /// Foreground colour used when the tile is in its resting state.
  final Color muted;

  /// When `true`, the tile uses [foreground] for the label colour and a
  /// bolder weight. Used by the "saved" and "liked" affordances.
  final bool emphasised;

  /// When `true`, the icon is replaced by a small [CircularProgressIndicator]
  /// sized to match the icon.
  final bool pending;

  /// Optional override for the semantics label. Defaults to [label].
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color activeColor = emphasised ? foreground : muted;

    return Semantics(
      button: true,
      label: semanticsLabel ?? label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: pending ? null : onTap,
          borderRadius: BorderRadius.circular(AiResponseConstants.pillRadius),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSizes.minTapTarget - 12,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AiResponseConstants.gapSm,
                vertical: AiResponseConstants.gapXs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (pending)
                    SizedBox(
                      width: AiResponseConstants.footerIconSize,
                      height: AiResponseConstants.footerIconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.6,
                        valueColor: AlwaysStoppedAnimation<Color>(activeColor),
                      ),
                    )
                  else
                    Icon(
                      icon,
                      size: AiResponseConstants.footerIconSize,
                      color: activeColor,
                    ),
                  const SizedBox(width: AiResponseConstants.gapXxs),
                  Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: activeColor,
                      fontWeight: emphasised
                          ? FontWeight.w700
                          : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
