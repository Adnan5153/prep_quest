import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/profile_avatar.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../../../../core/widgets/widget_constants.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';

class ProfileVisual {
  const ProfileVisual({
    required this.displayName,
    required this.level,
    this.imageUrl,
    this.assetImage,
    this.initials,
    this.isOnline = false,
    this.isPremium = false,
    this.notificationCount = 0,
    this.leagueName,
  });

  final String displayName;
  final int level;
  final String? imageUrl;
  final String? assetImage;
  final String? initials;
  final String? leagueName;
  final bool isOnline;
  final bool isPremium;
  final int notificationCount;
}

class ProfileSummary extends StatelessWidget {
  const ProfileSummary({
    super.key,
    required this.visual,
    this.onTap,
    this.onNotificationTap,
    this.heroTag = 'hud-profile-summary',
  });

  final ProfileVisual visual;
  final VoidCallback? onTap;
  final VoidCallback? onNotificationTap;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scale = ResponsiveBuilder.value<double>(
      context,
      mobile: 1.0,
      tablet: PlaygroundSizes.hudTabletScale,
      desktop: PlaygroundSizes.hudDesktopScale,
    );

    return RepaintBoundary(
      child: Semantics(
        label: PlaygroundStrings.profileSemantic,
        button: onTap != null,
        enabled: true,
        container: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: AppSizes.minTapTarget * scale,
            minHeight: AppSizes.minTapTarget * scale,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: AnimatedScale(
              scale: 1.0,
              duration: WidgetConstants.pressAnimationDuration,
              curve: PlaygroundCurves.hudEase,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _HudSurface(
                    isDark: isDark,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ProfileAvatar(
                            size: PlaygroundSizes.hudAvatarSize * scale,
                            imageUrl: visual.imageUrl,
                            assetImage: visual.assetImage,
                            initials: visual.initials,
                            name: visual.displayName,
                            showOnlineIndicator: visual.isOnline,
                            isOnline: visual.isOnline,
                            showPremiumBadge: visual.isPremium,
                            heroTag: heroTag,
                          ),
                          SizedBox(width: PlaygroundSizes.hudInnerGap * scale),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  visual.displayName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: isDark
                                        ? AppColors.darkOnSurface
                                        : AppColors.lightOnSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xxs),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _LevelChip(
                                      level: visual.level,
                                      isDark: isDark,
                                      scale: scale,
                                    ),
                                  ],
                                ),
                                if (visual.leagueName != null &&
                                    visual.leagueName!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: AppSpacing.xxs,
                                    ),
                                    child: Text(
                                      visual.leagueName!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: isDark
                                                ? AppColors.darkMuted
                                                : AppColors.lightMuted,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (visual.notificationCount > 0)
                    Positioned(
                      top: -PlaygroundSizes.hudNotificationDotSize / 2,
                      right: -PlaygroundSizes.hudNotificationDotSize / 2,
                      child: _NotificationBadge(
                        count: visual.notificationCount,
                        onTap: onNotificationTap,
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

class _HudSurface extends StatelessWidget {
  const _HudSurface({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = isDark
        ? AppColors.darkSurface.withValues(
            alpha: PlaygroundSizes.hudGlassDarkAlpha,
          )
        : AppColors.lightSurface.withValues(
            alpha: PlaygroundSizes.hudGlassLightAlpha,
          );
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.black.withValues(alpha: 0.06);

    return ClipRRect(
      borderRadius: BorderRadius.circular(PlaygroundSizes.hudBorderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: PlaygroundSizes.hudBlurSigma,
          sigmaY: PlaygroundSizes.hudBlurSigma,
        ),
        child: Container(
          padding: PlaygroundSizes.hudSurfacePadding,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              PlaygroundSizes.hudBorderRadius,
            ),
            border: Border.all(
              color: borderColor,
              width: WidgetConstants.outlineThickness,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkBackground.withValues(alpha: 0.10),
                blurRadius: PlaygroundSizes.hudBottomShadowBlur,
                offset: PlaygroundSizes.hudBottomShadowOffset,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.level,
    required this.isDark,
    required this.scale,
  });

  final int level;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs * scale,
        vertical: AppSpacing.xxs * scale,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.10)
            : Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        '${PlaygroundStrings.xpLevelLabel} $level',
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  const _NotificationBadge({required this.count, required this.onTap});

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final clamped = count.clamp(1, 99);
    final theme = Theme.of(context);
    return Semantics(
      label: PlaygroundStrings.profileSemantic,
      button: onTap != null,
      enabled: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: PlaygroundSizes.hudNotificationDotSize * 2,
            minHeight: PlaygroundSizes.hudNotificationDotSize * 2,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: AppColors.lightBackground,
              width: WidgetConstants.outlineThickness,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            clamped > 9 ? '9+' : '$clamped',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.darkOnSurface,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}
