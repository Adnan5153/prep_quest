import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';
import 'premium_badge.dart';

/// A production-ready responsive profile avatar component.
///
/// Features:
/// • Supports network, asset images, and initials fallback
/// • Online/Offline status indicator
/// • Premium and Verification badges
/// • Integrated edit button
/// • Responsive sizing and Hero animation support
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.assetImage,
    this.initials,
    this.name,
    this.size = 80.0,
    this.radius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.showBorder = true,
    this.showShadow = true,
    this.showOnlineIndicator = false,
    this.isOnline = false,
    this.showPremiumBadge = false,
    this.showVerifiedBadge = false,
    this.showEditButton = false,
    this.loading = false,
    this.onTap,
    this.onEdit,
    this.heroTag,
    this.fit = BoxFit.cover,
  });

  final String? imageUrl;
  final String? assetImage;
  final String? initials;
  final String? name;
  final double size;
  final double? radius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final bool showBorder;
  final bool showShadow;
  final bool showOnlineIndicator;
  final bool isOnline;
  final bool showPremiumBadge;
  final bool showVerifiedBadge;
  final bool showEditButton;
  final bool loading;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final String? heroTag;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double effectiveRadius = radius ?? size / 2;
    final double effectiveBorderWidth = borderWidth ?? AppSizes.borderThick;

    final Color effectiveBorderColor =
        borderColor ?? (isDark ? theme.colorScheme.surface : Colors.white);

    final Color effectiveBgColor =
        backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);

    Widget avatarContent = _buildAvatarImage(theme, effectiveBgColor);

    if (heroTag != null) {
      avatarContent = Hero(tag: heroTag!, child: avatarContent);
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildAvatarSurface(
            effectiveRadius,
            effectiveBorderColor,
            effectiveBorderWidth,
            avatarContent,
          ),
          if (showOnlineIndicator) _buildOnlineIndicator(effectiveRadius),
          if (showPremiumBadge) _buildPremiumBadge(effectiveRadius),
          if (showVerifiedBadge && !showPremiumBadge)
            _buildVerifiedBadge(effectiveRadius),
          if (showEditButton) _buildEditButton(effectiveRadius),
        ],
      ),
    );
  }

  Widget _buildAvatarSurface(
    double radius,
    Color borderColor,
    double borderWidth,
    Widget content,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
        border: showBorder
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
      ),
      child: ClipOval(child: content),
    );
  }

  Widget _buildAvatarImage(ThemeData theme, Color bgColor) {
    if (loading) {
      return Container(
        color: bgColor,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildInitials(theme, bgColor);
        },
        errorBuilder: (context, error, stackTrace) =>
            _buildInitials(theme, bgColor),
      );
    }

    if (assetImage != null && assetImage!.isNotEmpty) {
      return Image.asset(
        assetImage!,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            _buildInitials(theme, bgColor),
      );
    }

    return _buildInitials(theme, bgColor);
  }

  Widget _buildInitials(ThemeData theme, Color bgColor) {
    String displayInitials = initials ?? '';
    if (displayInitials.isEmpty && name != null && name!.isNotEmpty) {
      final names = name!.trim().split(' ');
      if (names.length > 1) {
        displayInitials = '${names[0][0]}${names[1][0]}'.toUpperCase();
      } else {
        displayInitials = names[0][0].toUpperCase();
      }
    }

    return Container(
      color: bgColor,
      alignment: Alignment.center,
      child: Text(
        displayInitials,
        style: theme.textTheme.titleMedium?.copyWith(
          fontSize: size * 0.35,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildOnlineIndicator(double radius) {
    return Positioned(
      bottom: size * 0.05,
      right: size * 0.05,
      child: Container(
        width: size * 0.2,
        height: size * 0.2,
        decoration: BoxDecoration(
          color: isOnline ? AppColors.success : AppColors.error,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildPremiumBadge(double radius) {
    return const Positioned(
      top: -4,
      right: -4,
      child: PremiumBadge(
        style: PremiumBadgeStyle.compact,
        label: 'PRO',
        animate: false,
      ),
    );
  }

  Widget _buildVerifiedBadge(double radius) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: AppColors.info,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, color: Colors.white, size: size * 0.15),
      ),
    );
  }

  Widget _buildEditButton(double radius) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: onEdit,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(
            Icons.edit_rounded,
            color: Colors.white,
            size: size * 0.18,
          ),
        ),
      ),
    );
  }
}
