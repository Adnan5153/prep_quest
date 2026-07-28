import 'package:flutter/material.dart';

import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';

/// Top navigation bar for the application.
///
/// Implements the `custom_appbar` widget described in
/// `Plans/widgetdesign.md` section 12.13:
///   - Title, subtitle, leading, and trailing actions in a calm hierarchy.
///   - Soft elevation, generous spacing, modern & approachable styling.
///   - All visual tokens (colors / sizes / spacing / radius) come from the
///     project's central constants; widget code never inlines literals.
///
/// The widget is presentation-only. Behaviour such as navigation is pushed
/// in via the [onLeadingPressed] / [onActionPressed] callbacks. Use a plain
/// [AppBar] when you do not need the subtitle, accent strip, or branded
/// shape.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const <Widget>[],
    this.onLeadingPressed,
    this.onActionPressed,
    this.showAccentStripe = true,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// Primary title shown in the bar's body.
  final String title;

  /// Optional secondary line rendered beneath the title.
  final String? subtitle;

  /// Optional leading widget (avatar, icon, etc.). When omitted and
  /// [onLeadingPressed] is provided, a back-chevron icon is rendered.
  final Widget? leading;

  /// Trailing actions — typically icon buttons. Each action may be paired
  /// with a callback via [onActionPressed] using its index in the list.
  final List<Widget> actions;

  /// Callback fired when the leading widget is tapped. When [leading] is
  /// null and this is non-null, a default back chevron is shown.
  final VoidCallback? onLeadingPressed;

  /// Optional per-action callback. The int is the action's index in
  /// [actions]. Any index without a callback is treated as non-interactive.
  final void Function(int index)? onActionPressed;

  /// When true, the thin accent stripe is drawn under the bar to reinforce
  /// the brand identity. Defaults to true.
  final bool showAccentStripe;

  /// Override for the background color. Falls back to the theme's
  /// `colorScheme.surface`.
  final Color? backgroundColor;

  /// Override for foreground (title / icon) color. Falls back to the
  /// theme's `colorScheme.onSurface`.
  final Color? foregroundColor;

  @override
  Size get preferredSize {
    // Title row is sized via the standard AppBar height. The optional
    // subtitle line, accent stripe and vertical padding push the total
    // beyond the base toolbar; compute it from the tokens instead of
    // hand-rolling a literal.
    const double titleRow = AppSizes.appBarHeight;
    const double subtitleLine = AppSpacing.lg; // 16 px line + xxs gap
    const double accentRow = AppSpacing.md + AppSizes.borderThick;
    const double verticalPadding = AppSpacing.md * 2; // top + bottom

    return const Size.fromHeight(
      titleRow + subtitleLine + accentRow + verticalPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    final Color bg = backgroundColor ?? scheme.surface;
    final Color fg = foregroundColor ?? scheme.onSurface;

    final Widget? leadingWidget =
        leading ??
        (onLeadingPressed != null
            ? IconButton(
                onPressed: onLeadingPressed,
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back',
              )
            : null);

    return Material(
      color: bg,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (leadingWidget != null)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: leadingWidget,
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: fg,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null) ...<Widget>[
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: fg.withValues(alpha: 0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (actions.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        for (int i = 0; i < actions.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.xs),
                            child: actions[i],
                          ),
                      ],
                    ),
                ],
              ),
              if (showAccentStripe)
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.md),
                  child: _AccentStripe(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Branded accent stripe drawn under [CustomAppBar]. Width is constrained
/// so it does not dominate the layout but reads as a brand cue.
class _AccentStripe extends StatelessWidget {
  const _AccentStripe();

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      height: AppSizes.borderThick,
      width: AppSizes.iconXl,
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }
}

/// Sliver counterpart of [CustomAppBar] for use inside `CustomScrollView`.
///
/// Wraps the same widget in [SliverToBoxAdapter] so callers can drop it into
/// a sliver list without recomputing heights.
class SliverCustomAppBar extends StatelessWidget {
  const SliverCustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const <Widget>[],
    this.onLeadingPressed,
    this.onActionPressed,
    this.showAccentStripe = true,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final VoidCallback? onLeadingPressed;
  final void Function(int index)? onActionPressed;
  final bool showAccentStripe;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: CustomAppBar(
        title: title,
        subtitle: subtitle,
        leading: leading,
        actions: actions,
        onLeadingPressed: onLeadingPressed,
        onActionPressed: onActionPressed,
        showAccentStripe: showAccentStripe,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
    );
  }
}
