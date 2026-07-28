import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';

class AppSnackBar extends SnackBar {
  AppSnackBar({
    super.key,
    required this.message,
    this.title,
    this.variant = AppSnackBarVariant.neutral,
    this.leadingIcon,
    this.onClose,
    this.showCloseButton = false,
    this.autofocusAction = false,
    super.action,
    super.duration = const Duration(seconds: 4),
    super.behavior = SnackBarBehavior.floating,
    super.margin,
    super.padding = EdgeInsets.zero,
    super.elevation,
    super.width,
    super.shape,
    super.dismissDirection = DismissDirection.down,
    super.clipBehavior = Clip.hardEdge,
    super.animation,
    super.onVisible,
  }) : super(
         content: _AppSnackBarBody(
           message: message,
           title: title,
           variant: variant,
           leadingIcon: leadingIcon,
           action: action,
           onClose: onClose,
           showCloseButton: showCloseButton,
           autofocusAction: autofocusAction,
           margin: margin,
         ),
       );

  final String message;
  final String? title;
  final AppSnackBarVariant variant;
  final IconData? leadingIcon;
  final VoidCallback? onClose;
  final bool showCloseButton;
  final bool autofocusAction;

  factory AppSnackBar.success(
    BuildContext context,
    String message, {
    Key? key,
    String? title = AppStrings.snackBarSuccessTitle,
    SnackBarAction? action,
    VoidCallback? onClose,
    Duration duration = const Duration(seconds: 3),
    AppSnackBarLocation location = AppSnackBarLocation.bottom,
    double? maxWidth,
  }) => AppSnackBar(
    key: key,
    message: message,
    title: title,
    variant: AppSnackBarVariant.success,
    leadingIcon: AppIcons.success,
    action: action,
    onClose: onClose,
    duration: duration,
    margin: _defaultMargin(context, location),
    width: maxWidth,
  );

  factory AppSnackBar.error(
    BuildContext context,
    String message, {
    Key? key,
    String? title = AppStrings.snackBarErrorTitle,
    SnackBarAction? action,
    VoidCallback? onClose,
    Duration duration = const Duration(seconds: 6),
    bool showCloseButton = true,
    AppSnackBarLocation location = AppSnackBarLocation.bottom,
    double? maxWidth,
  }) => AppSnackBar(
    key: key,
    message: message,
    title: title,
    variant: AppSnackBarVariant.error,
    leadingIcon: AppIcons.error,
    action: action,
    onClose: onClose,
    showCloseButton: showCloseButton,
    duration: duration,
    margin: _defaultMargin(context, location),
    width: maxWidth,
  );

  factory AppSnackBar.warning(
    BuildContext context,
    String message, {
    Key? key,
    String? title = AppStrings.snackBarWarningTitle,
    SnackBarAction? action,
    VoidCallback? onClose,
    Duration duration = const Duration(seconds: 5),
    AppSnackBarLocation location = AppSnackBarLocation.bottom,
    double? maxWidth,
  }) => AppSnackBar(
    key: key,
    message: message,
    title: title,
    variant: AppSnackBarVariant.warning,
    leadingIcon: AppIcons.warning,
    action: action,
    onClose: onClose,
    duration: duration,
    margin: _defaultMargin(context, location),
    width: maxWidth,
  );

  factory AppSnackBar.info(
    BuildContext context,
    String message, {
    Key? key,
    String? title = AppStrings.snackBarInfoTitle,
    SnackBarAction? action,
    VoidCallback? onClose,
    Duration duration = const Duration(seconds: 4),
    AppSnackBarLocation location = AppSnackBarLocation.bottom,
    double? maxWidth,
  }) => AppSnackBar(
    key: key,
    message: message,
    title: title,
    variant: AppSnackBarVariant.info,
    leadingIcon: AppIcons.info,
    action: action,
    onClose: onClose,
    duration: duration,
    margin: _defaultMargin(context, location),
    width: maxWidth,
  );

  factory AppSnackBar.neutral(
    BuildContext context,
    String message, {
    Key? key,
    SnackBarAction? action,
    VoidCallback? onClose,
    Duration duration = const Duration(seconds: 4),
    AppSnackBarLocation location = AppSnackBarLocation.bottom,
    double? maxWidth,
  }) => AppSnackBar(
    key: key,
    message: message,
    variant: AppSnackBarVariant.neutral,
    action: action,
    onClose: onClose,
    duration: duration,
    margin: _defaultMargin(context, location),
    width: maxWidth,
  );

  factory AppSnackBar.custom(
    BuildContext context, {
    Key? key,
    required String message,
    String? title,
    required Color backgroundColor,
    required Color foregroundColor,
    IconData? leadingIcon,
    SnackBarAction? action,
    VoidCallback? onClose,
    bool showCloseButton = false,
    Duration duration = const Duration(seconds: 4),
    AppSnackBarLocation location = AppSnackBarLocation.bottom,
    double? maxWidth,
    BorderRadius? borderRadius,
    double? elevation,
  }) => AppSnackBar(
    key: key,
    message: message,
    title: title,
    variant: AppSnackBarVariant.custom,
    leadingIcon: leadingIcon,
    action: action,
    onClose: onClose,
    showCloseButton: showCloseButton,
    duration: duration,
    margin: _defaultMargin(context, location),
    width: maxWidth,
    shape: borderRadius != null
        ? RoundedRectangleBorder(borderRadius: borderRadius)
        : null,
    elevation: elevation,
  );

  static void show(
    BuildContext context,
    AppSnackBar snackBar, {
    bool clearStack = false,
  }) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    if (clearStack) {
      messenger.clearSnackBars();
    }
    messenger.showSnackBar(snackBar);
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    double? maxWidth,
  }) {
    show(
      context,
      AppSnackBar.success(
        context,
        message,
        title: title,
        action: action,
        duration: duration,
        maxWidth: maxWidth,
      ),
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    String? title,
    SnackBarAction? action,
    VoidCallback? onClose,
    Duration duration = const Duration(seconds: 6),
    bool showCloseButton = true,
    double? maxWidth,
  }) {
    show(
      context,
      AppSnackBar.error(
        context,
        message,
        title: title,
        action: action,
        onClose: onClose,
        showCloseButton: showCloseButton,
        duration: duration,
        maxWidth: maxWidth,
      ),
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    String? title,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 5),
    double? maxWidth,
  }) {
    show(
      context,
      AppSnackBar.warning(
        context,
        message,
        title: title,
        action: action,
        duration: duration,
        maxWidth: maxWidth,
      ),
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    String? title,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 4),
    double? maxWidth,
  }) {
    show(
      context,
      AppSnackBar.info(
        context,
        message,
        title: title,
        action: action,
        duration: duration,
        maxWidth: maxWidth,
      ),
    );
  }

  static EdgeInsetsGeometry _defaultMargin(
    BuildContext context,
    AppSnackBarLocation location,
  ) {
    final double width = MediaQuery.sizeOf(context).width;
    final double horizontal = width >= AppSizes.tabletMaxWidth
        ? AppSpacing.xxl
        : width >= AppSizes.mobileMaxWidth
        ? AppSpacing.xl
        : AppSpacing.md;
    final double bottom = location == AppSnackBarLocation.top
        ? AppSpacing.md
        : AppSpacing.md;
    final double top = location == AppSnackBarLocation.top ? AppSpacing.lg : 0;
    return EdgeInsets.fromLTRB(horizontal, top, horizontal, bottom);
  }
}

enum AppSnackBarVariant { success, error, warning, info, neutral, custom }

enum AppSnackBarLocation { top, bottom }

class _AppSnackBarBody extends StatelessWidget {
  const _AppSnackBarBody({
    required this.message,
    required this.title,
    required this.variant,
    required this.leadingIcon,
    required this.action,
    required this.onClose,
    required this.showCloseButton,
    required this.autofocusAction,
    required this.margin,
  });

  final String message;
  final String? title;
  final AppSnackBarVariant variant;
  final IconData? leadingIcon;
  final SnackBarAction? action;
  final VoidCallback? onClose;
  final bool showCloseButton;
  final bool autofocusAction;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final _SnackPalette palette = _resolvePalette(isDark);

    final IconData? effectiveIcon = leadingIcon ?? palette.defaultIcon;
    final TextScaler clampedScaler = MediaQuery.textScalerOf(
      context,
    ).clamp(minScaleFactor: 0.85, maxScaleFactor: 1.4);

    final Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (effectiveIcon != null) ...<Widget>[
          Icon(effectiveIcon, size: AppSizes.iconMd, color: palette.foreground),
          const SizedBox(width: AppSpacing.md),
        ],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (title != null && title!.isNotEmpty)
                Text(
                  title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textScaler: clampedScaler,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: palette.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (title != null && title!.isNotEmpty)
                const SizedBox(height: AppSpacing.xxs),
              Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textScaler: clampedScaler,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: palette.foreground.withValues(alpha: 0.92),
                ),
              ),
            ],
          ),
        ),
        if (action != null) ...<Widget>[
          const SizedBox(width: AppSpacing.sm),
          _SnackBarActionChip(
            action: action!,
            foreground: palette.foreground,
            autofocus: autofocusAction,
          ),
        ],
        if (showCloseButton && onClose != null) ...<Widget>[
          const SizedBox(width: AppSpacing.xs),
          _SnackBarCloseButton(
            onClose: onClose!,
            foreground: palette.foreground,
          ),
        ],
      ],
    );

    return Semantics(
      label: AppStrings.snackBarSemanticLabel,
      liveRegion: true,
      container: true,
      child: content,
    );
  }

  _SnackPalette _resolvePalette(bool isDark) {
    switch (variant) {
      case AppSnackBarVariant.success:
        return _SnackPalette(
          background: isDark
              ? AppColors.success.withValues(alpha: 0.22)
              : AppColors.success,
          foreground: isDark ? AppColors.success : Colors.white,
          defaultIcon: AppIcons.success,
        );
      case AppSnackBarVariant.error:
        return _SnackPalette(
          background: isDark
              ? AppColors.error.withValues(alpha: 0.22)
              : AppColors.error,
          foreground: isDark ? AppColors.error : Colors.white,
          defaultIcon: AppIcons.error,
        );
      case AppSnackBarVariant.warning:
        return _SnackPalette(
          background: isDark
              ? AppColors.warning.withValues(alpha: 0.22)
              : AppColors.warning,
          foreground: isDark ? AppColors.warning : Colors.white,
          defaultIcon: AppIcons.warning,
        );
      case AppSnackBarVariant.info:
        return _SnackPalette(
          background: isDark
              ? AppColors.info.withValues(alpha: 0.22)
              : AppColors.info,
          foreground: isDark ? AppColors.info : Colors.white,
          defaultIcon: AppIcons.info,
        );
      case AppSnackBarVariant.neutral:
        return _SnackPalette(
          background: isDark
              ? const Color(0xFF1F2233)
              : const Color(0xFF2A2D3A),
          foreground: isDark ? const Color(0xFFE4E7EB) : Colors.white,
          defaultIcon: null,
        );
      case AppSnackBarVariant.custom:
        return const _SnackPalette(
          background: Color(0xFF2A2D3A),
          foreground: Colors.white,
          defaultIcon: null,
        );
    }
  }
}

class _SnackPalette {
  const _SnackPalette({
    required this.background,
    required this.foreground,
    required this.defaultIcon,
  });

  final Color background;
  final Color foreground;
  final IconData? defaultIcon;
}

class _SnackBarActionChip extends StatelessWidget {
  const _SnackBarActionChip({
    required this.action,
    required this.foreground,
    required this.autofocus,
  });

  final SnackBarAction action;
  final Color foreground;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      autofocus: autofocus,
      onPressed: () {
        HapticFeedback.selectionClick();
        action.onPressed();
      },
      style: TextButton.styleFrom(
        foregroundColor: foreground,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        minimumSize: const Size(0, AppSizes.minTapTarget * 0.6),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
      child: Text(action.label),
    );
  }
}

class _SnackBarCloseButton extends StatelessWidget {
  const _SnackBarCloseButton({required this.onClose, required this.foreground});

  final VoidCallback onClose;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onClose();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      icon: Icon(AppIcons.close, color: foreground, size: AppSizes.iconSm),
      tooltip: AppStrings.snackBarCloseTooltip,
      splashRadius: AppSizes.iconMd,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: AppSizes.minTapTarget * 0.6,
        minHeight: AppSizes.minTapTarget * 0.6,
      ),
    );
  }
}
