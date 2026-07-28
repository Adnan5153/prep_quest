import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '_sliver_appbar_animation.dart';

/// Flexible space widget for the CustomSliverAppBar.
class SliverAppBarFlexibleSpace extends StatelessWidget {
  const SliverAppBarFlexibleSpace({
    super.key,
    required this.title,
    this.subtitle,
    this.backgroundImage,
    this.titleColor,
    required this.currentHeight,
    required this.expandedHeight,
    required this.toolbarHeight,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  final String title;
  final String? subtitle;
  final ImageProvider? backgroundImage;
  final Color? titleColor;
  final double currentHeight;
  final double expandedHeight;
  final double toolbarHeight;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.paddingOf(context).top;
    final double toolbarTotalHeight = toolbarHeight + statusBarHeight;

    final double t = SliverAppBarAnimation.calculateCollapsePercentage(
      currentHeight,
      expandedHeight,
      toolbarTotalHeight,
    );

    final double expandedOpacity =
        SliverAppBarAnimation.calculateExpandedOpacity(t);
    final double collapsedOpacity =
        SliverAppBarAnimation.calculateCollapsedOpacity(t);

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackground(),
        _buildOverlays(collapsedOpacity),
        _buildHeroContent(expandedOpacity, t),
        _buildCollapsedTitle(collapsedOpacity),
      ],
    );
  }

  Widget _buildBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (backgroundImage != null)
          Positioned.fill(
            child: Image(image: backgroundImage!, fit: BoxFit.cover),
          ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.secondary],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlays(double collapsedOpacity) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: 0.12)),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: collapsedOpacity,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroContent(double expandedOpacity, double t) {
    final double horizontalPadding = isDesktop
        ? AppSpacing.huge
        : isTablet
        ? AppSpacing.xxxl
        : AppSpacing.xl;

    final double titleFontSize = isDesktop
        ? 34
        : isTablet
        ? 30
        : 26;

    final double subtitleFontSize = isDesktop
        ? 16
        : isTablet
        ? 15
        : 14;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Transform.translate(
              offset: Offset(
                0,
                SliverAppBarAnimation.calculateTitleTranslation(t),
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: expandedOpacity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LargeTitle(
                      title: title,
                      color: titleColor,
                      fontSize: titleFontSize,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _Subtitle(
                        subtitle: subtitle!,
                        fontSize: subtitleFontSize,
                        opacity: expandedOpacity,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedTitle(double collapsedOpacity) {
    return SafeArea(
      bottom: false,
      child: IgnorePointer(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: collapsedOpacity,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: toolbarHeight,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxxl,
                  ),
                  child: Hero(
                    tag: 'app_bar_title_$title',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: titleColor ?? Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LargeTitle extends StatelessWidget {
  const _LargeTitle({required this.title, this.color, required this.fontSize});

  final String title;
  final Color? color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app_bar_title_$title',
      child: Material(
        color: Colors.transparent,
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({
    required this.subtitle,
    required this.fontSize,
    required this.opacity,
  });

  final String subtitle;
  final double fontSize;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: opacity,
      child: Text(
        subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white.withValues(alpha: .9),
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
