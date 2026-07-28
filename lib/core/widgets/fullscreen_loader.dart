import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_assets.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';

/// A production-ready responsive fullscreen loading overlay.
///
/// Features:
/// • Blurred background with animated opacity
/// • Responsive card layout (Mobile/Tablet/Desktop)
/// • Lottie animation support with fallback to CircularProgressIndicator
/// • Progress percentage indicator
/// • Static helper methods for showing and hiding
class FullscreenLoader extends StatelessWidget {
  const FullscreenLoader({
    super.key,
    this.title,
    this.subtitle,
    this.progress,
    this.showProgress = false,
    this.showCancelButton = false,
    this.dismissible = true,
    this.backgroundColor,
    this.cardColor,
    this.loaderColor,
    this.lottieAsset,
    this.onCancel,
  });

  final String? title;
  final String? subtitle;
  final double? progress;
  final bool showProgress;
  final bool showCancelButton;
  final bool dismissible;
  final Color? backgroundColor;
  final Color? cardColor;
  final Color? loaderColor;
  final String? lottieAsset;
  final VoidCallback? onCancel;

  /// Shows the fullscreen loader as a general dialog.
  static Future<void> show(
    BuildContext context, {
    String? title,
    String? subtitle,
    double? progress,
    bool showProgress = false,
    bool showCancelButton = false,
    bool dismissible = true,
    Color? backgroundColor,
    Color? cardColor,
    Color? loaderColor,
    String? lottieAsset,
    VoidCallback? onCancel,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'FullscreenLoader',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FullscreenLoader(
          title: title,
          subtitle: subtitle,
          progress: progress,
          showProgress: showProgress,
          showCancelButton: showCancelButton,
          dismissible: dismissible,
          backgroundColor: backgroundColor,
          cardColor: cardColor,
          loaderColor: loaderColor,
          lottieAsset: lottieAsset,
          onCancel: onCancel,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Hides the currently shown fullscreen loader.
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;

    final bool isDesktop = width >= AppSizes.tabletMaxWidth;
    final bool isTablet =
        width >= AppSizes.mobileMaxWidth && width < AppSizes.tabletMaxWidth;

    final double cardWidth = isDesktop
        ? 560
        : isTablet
        ? 480
        : width * 0.9;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _BlurredBackground(
            backgroundColor: backgroundColor,
            onTap: dismissible ? () => hide(context) : null,
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: cardWidth,
                    maxHeight: size.height * 0.8,
                  ),
                  child: _LoaderCard(
                    title: title,
                    subtitle: subtitle,
                    progress: progress,
                    showProgress: showProgress,
                    showCancelButton: showCancelButton,
                    cardColor: cardColor,
                    loaderColor: loaderColor,
                    lottieAsset: lottieAsset,
                    onCancel: onCancel,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurredBackground extends StatelessWidget {
  const _BlurredBackground({this.backgroundColor, this.onTap});

  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: backgroundColor ?? Colors.black.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _LoaderCard extends StatelessWidget {
  const _LoaderCard({
    this.title,
    this.subtitle,
    this.progress,
    required this.showProgress,
    required this.showCancelButton,
    this.cardColor,
    this.loaderColor,
    this.lottieAsset,
    this.onCancel,
  });

  final String? title;
  final String? subtitle;
  final double? progress;
  final bool showProgress;
  final bool showCancelButton;
  final Color? cardColor;
  final Color? loaderColor;
  final String? lottieAsset;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: cardColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AnimationSelector(
              lottieAsset: lottieAsset,
              loaderColor: loaderColor,
            ),
            if (title != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                title!,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
            if (showProgress) ...[
              const SizedBox(height: AppSpacing.xl),
              _ProgressIndicator(progress: progress, color: loaderColor),
            ],
            if (showCancelButton) ...[
              const SizedBox(height: AppSpacing.xl),
              TextButton(
                onPressed: onCancel,
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnimationSelector extends StatelessWidget {
  const _AnimationSelector({this.lottieAsset, this.loaderColor});

  final String? lottieAsset;
  final Color? loaderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asset = lottieAsset ?? AppAssets.loaderLottie;

    return SizedBox(
      height: 120,
      width: 120,
      child: Lottie.asset(
        asset,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                loaderColor ?? theme.colorScheme.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({this.progress, this.color});

  final double? progress;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = ((progress ?? 0) * 100).toInt();
    final primaryColor = color ?? theme.colorScheme.primary;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: AppSizes.borderThin,
            backgroundColor: primaryColor.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '$percentage%',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}
