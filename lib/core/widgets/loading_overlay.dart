import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_assets.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';

/// A production-ready responsive loading overlay.
///
/// Wraps a [child] widget and displays a loading layer on top when [isLoading]
/// is true. Blocks user interaction while active.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
    this.subMessage,
    this.progress,
    this.showProgress = false,
    this.loader,
    this.backgroundColor,
    this.overlayOpacity,
    this.blur,
    this.borderRadius,
    this.dismissible = false,
    this.useLottie = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final Widget child;
  final bool isLoading;
  final String? message;
  final String? subMessage;
  final double? progress;
  final bool showProgress;
  final Widget? loader;
  final Color? backgroundColor;
  final double? overlayOpacity;
  final double? blur;
  final BorderRadiusGeometry? borderRadius;
  final bool dismissible;
  final bool useLottie;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double effectiveBlur = blur ?? 6.0;
    final double effectiveOpacity = overlayOpacity ?? (isDark ? 0.4 : 0.2);
    final Color effectiveBg =
        backgroundColor ?? (isDark ? Colors.black : Colors.white);

    final BorderRadiusGeometry effectiveRadius =
        borderRadius ?? BorderRadius.circular(AppRadius.lg);

    return Stack(
      children: [
        // The wrapped child remains in the tree to preserve state.
        child,

        // Overlay layer with fade transition.
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: isLoading ? 1.0 : 0.0,
            duration: animationDuration,
            curve: Curves.easeInOut,
            // IgnorePointer blocks touch events on the child while loading.
            child: IgnorePointer(
              ignoring: !isLoading,
              child: _buildOverlayContent(
                context: context,
                theme: theme,
                isDark: isDark,
                effectiveBlur: effectiveBlur,
                effectiveOpacity: effectiveOpacity,
                effectiveBg: effectiveBg,
                effectiveRadius: effectiveRadius,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayContent({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required double effectiveBlur,
    required double effectiveOpacity,
    required Color effectiveBg,
    required BorderRadiusGeometry effectiveRadius,
  }) {
    return ClipRRect(
      borderRadius: effectiveRadius,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Blurred background.
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: effectiveBlur,
                sigmaY: effectiveBlur,
              ),
              child: Container(
                color: effectiveBg.withValues(alpha: effectiveOpacity),
              ),
            ),
          ),

          // Loading Card / Content.
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: _LoadingCard(
                message: message,
                subMessage: subMessage,
                progress: progress,
                showProgress: showProgress,
                loader: loader,
                useLottie: useLottie,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({
    this.message,
    this.subMessage,
    this.progress,
    required this.showProgress,
    this.loader,
    required this.useLottie,
  });

  final String? message;
  final String? subMessage;
  final double? progress;
  final bool showProgress;
  final Widget? loader;
  final bool useLottie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Loader.
          _LoaderSelector(loader: loader, useLottie: useLottie),

          // Message.
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],

          // Sub message.
          if (subMessage != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subMessage!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              ),
            ),
          ],

          // Progress indicator.
          if (showProgress) ...[
            const SizedBox(height: AppSpacing.lg),
            _ProgressIndicator(progress: progress),
          ],
        ],
      ),
    );
  }
}

class _LoaderSelector extends StatelessWidget {
  const _LoaderSelector({this.loader, required this.useLottie});

  final Widget? loader;
  final bool useLottie;

  @override
  Widget build(BuildContext context) {
    if (loader != null) return loader!;

    if (useLottie) {
      return SizedBox(
        height: 80,
        width: 80,
        child: Lottie.asset(
          AppAssets.loaderLottie,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const _Spinner(),
        ),
      );
    }

    return const _Spinner();
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({this.progress});

  final double? progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final percentage = ((progress ?? 0) * 100).toInt();

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
        const SizedBox(height: AppSpacing.xs),
        Text(
          '$percentage%',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}
