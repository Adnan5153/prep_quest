import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';
import 'primary_button.dart';
import 'widget_constants.dart';

/// Predefined error types for [NetworkErrorWidget].
enum NetworkErrorType {
  noInternet,
  connectionTimeout,
  serverUnavailable,
  requestFailed,
  apiError,
  offlineMode,
  unknownError,
}

/// A highly reusable and responsive network error widget.
///
/// Gracefully informs users when data cannot be loaded and provides
/// retry functionality.
class NetworkErrorWidget extends StatelessWidget {
  const NetworkErrorWidget({
    super.key,
    required this.onRetry,
    this.title,
    this.message,
    this.retryText = 'Retry',
    this.illustration,
    this.icon,
    this.showIcon = true,
    this.showIllustration = true,
    this.showRetryButton = true,
    this.isLoading = false,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.width,
    this.height,
    this.semanticLabel,
    this.errorType = NetworkErrorType.unknownError,
  });

  final VoidCallback onRetry;
  final String? title;
  final String? message;
  final String retryText;
  final Widget? illustration;
  final IconData? icon;
  final bool showIcon;
  final bool showIllustration;
  final bool showRetryButton;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? width;
  final double? height;
  final String? semanticLabel;
  final NetworkErrorType errorType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final config = _getErrorConfig(theme, isDark);

    return Semantics(
      label: semanticLabel ?? title ?? config.title,
      child: Center(
        child: Container(
          width: width,
          height: height,
          margin: margin,
          child: SingleChildScrollView(
            padding: padding ?? const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showIllustration && illustration != null) ...[
                  Flexible(child: illustration!),
                  const SizedBox(height: AppSpacing.xxl),
                ],
                if (showIcon && icon == null) ...[
                  Icon(
                    config.icon,
                    size: AppSizes.iconXl,
                    color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ] else if (showIcon && icon != null) ...[
                  Icon(
                    icon,
                    size: AppSizes.iconXl,
                    color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                Text(
                  title ?? config.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkOnSurface
                        : AppColors.lightOnSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: Text(
                    message ?? config.message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkMuted
                          : AppColors.lightMuted,
                    ),
                  ),
                ),
                if (showRetryButton) ...[
                  const SizedBox(height: AppSpacing.xxxl),
                  PrimaryButton(
                    text: retryText,
                    onPressed: onRetry,
                    isLoading: isLoading,
                    width: WidgetConstants.buttonMinWidth * 2.5,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  _ErrorConfig _getErrorConfig(ThemeData theme, bool isDark) {
    switch (errorType) {
      case NetworkErrorType.noInternet:
        return const _ErrorConfig(
          title: 'No Connection',
          message:
              'It looks like you\'re offline. Please check your internet connection and try again.',
          icon: Icons.wifi_off_rounded,
        );
      case NetworkErrorType.connectionTimeout:
        return const _ErrorConfig(
          title: 'Connection Timeout',
          message:
              'The server is taking too long to respond. Please try again later.',
          icon: Icons.timer_off_rounded,
        );
      case NetworkErrorType.serverUnavailable:
        return const _ErrorConfig(
          title: 'Server Unavailable',
          message:
              'We\'re experiencing some issues on our end. We\'ll be back soon!',
          icon: Icons.dns_rounded,
        );
      case NetworkErrorType.apiError:
      case NetworkErrorType.requestFailed:
        return const _ErrorConfig(
          title: 'Oops! Something went wrong',
          message:
              'We couldn\'t load the data. This might be a temporary issue.',
          icon: Icons.error_outline_rounded,
        );
      case NetworkErrorType.offlineMode:
        return const _ErrorConfig(
          title: 'Offline Mode',
          message: 'You are currently browsing offline content.',
          icon: Icons.cloud_off_rounded,
        );
      case NetworkErrorType.unknownError:
        return const _ErrorConfig(
          title: 'Unexpected Error',
          message: 'An unknown error occurred. Please try again.',
          icon: Icons.warning_amber_rounded,
        );
    }
  }
}

class _ErrorConfig {
  const _ErrorConfig({
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;
}
