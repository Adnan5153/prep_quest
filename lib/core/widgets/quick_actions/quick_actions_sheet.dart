import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import '../../widgets/responsive_builder.dart';
import 'quick_action_grid.dart';
import 'quick_action_tile.dart';
import 'quick_actions_header.dart';

/// Reusable modal sheet that surfaces a grid of [QuickActionItem]s.
///
/// Mirrors the `show()`-style convention used by `StreakRecoveryDialog`:
/// callers invoke [QuickActionsSheet.show] and the sheet handles its
/// own dismissal, animation, and gesture handling. The sheet is fully
/// reusable across features — the default list ships ten shortcuts, but
/// callers can pass a custom list.
class QuickActionsSheet extends StatelessWidget {
  const QuickActionsSheet({
    super.key,
    required this.actions,
    this.title,
    this.subtitle,
  });

  final List<QuickActionItem> actions;
  final String? title;
  final String? subtitle;

  static Future<void> show(
    BuildContext context, {
    required List<QuickActionItem> actions,
    String? title,
    String? subtitle,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) => QuickActionsSheet(
        actions: actions,
        title: title,
        subtitle: subtitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: 560,
      desktop: 640,
    );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Material(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              elevation: 8,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 240),
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const QuickActionsHandle(),
                    QuickActionsHeader(
                      title: title ?? 'Quick Actions',
                      subtitle: subtitle,
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Icon(
                          Icons.bolt_rounded,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      onClose: () => Navigator.of(context).pop(),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.xs,
                          AppSpacing.lg,
                          AppSpacing.lg,
                        ),
                        child: QuickActionGrid(actions: actions),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
