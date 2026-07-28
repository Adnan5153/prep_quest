import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// Immutable configuration for one shortcut displayed in a quick-actions grid.
@immutable
class QuickActionItem {
  const QuickActionItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.onTap,
    this.badgeCount = 0,
    this.semanticLabel,
    this.enabled = true,
  });

  final String id;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final int badgeCount;
  final String? semanticLabel;
  final bool enabled;
}

/// Responsive pressable tile used by [QuickActionsSheet].
class QuickActionTile extends StatefulWidget {
  const QuickActionTile({
    super.key,
    required this.action,
  });

  final QuickActionItem action;

  @override
  State<QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<QuickActionTile> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value || !widget.action.enabled) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final QuickActionItem action = widget.action;
    final Color foreground = action.enabled
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return Semantics(
      button: true,
      enabled: action.enabled,
      label: action.semanticLabel ?? action.label,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Material(
          color: action.enabled
              ? theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.65)
              : theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: InkWell(
            onTap: action.enabled ? action.onTap : null,
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Container(
                        width: AppSizes.minTapTarget,
                        height: AppSizes.minTapTarget,
                        decoration: BoxDecoration(
                          color: foreground.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          action.icon,
                          color: foreground,
                          size: AppSizes.iconMd,
                        ),
                      ),
                      if (action.badgeCount > 0)
                        Positioned(
                          right: -AppSpacing.sm,
                          top: -AppSpacing.sm,
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: AppSizes.iconSm,
                              minHeight: AppSizes.iconSm,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              action.badgeCount > 99
                                  ? '99+'
                                  : '${action.badgeCount}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onError,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    action.label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: action.enabled
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
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