import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import 'sliver_appbar/_sliver_appbar_actions.dart';
import 'sliver_appbar/_sliver_appbar_flexible_space.dart';
import 'sliver_appbar/_sliver_appbar_profile.dart';

/// A reusable responsive SliverAppBar used throughout Prep Quest.
class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    // Content
    required this.title,
    this.subtitle,
    this.backgroundImage,
    // Actions & Leading
    this.leading,
    this.actions,
    this.showBackButton = false,
    this.showNotification = false,
    this.showSearch = false,
    this.showProfile = false,
    // Layout
    this.expandedHeight,
    this.collapsedHeight,
    this.toolbarHeight,
    this.bottom,
    // Behavior
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.stretch = true,
    // Appearance
    this.backgroundColor,
    this.titleColor,
    this.elevation = AppSizes.cardElevation,
    this.centerTitle = false,
    this.flexibleSpace,
  });

  final String title;
  final String? subtitle;
  final ImageProvider? backgroundImage;

  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showNotification;
  final bool showSearch;
  final bool showProfile;

  final double? expandedHeight;
  final double? collapsedHeight;
  final double? toolbarHeight;
  final PreferredSizeWidget? bottom;

  final bool pinned;
  final bool floating;
  final bool snap;
  final bool stretch;

  final Color? backgroundColor;
  final Color? titleColor;
  final double elevation;
  final bool centerTitle;
  final Widget? flexibleSpace;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final width = media.width;

    final bool isMobile = width < AppSizes.mobileMaxWidth;
    final bool isTablet =
        width >= AppSizes.mobileMaxWidth && width < AppSizes.tabletMaxWidth;
    final bool isDesktop = width >= AppSizes.tabletMaxWidth;

    final double resolvedToolbarHeight = toolbarHeight ?? AppSizes.appBarHeight;
    final double resolvedCollapsedHeight =
        collapsedHeight ?? resolvedToolbarHeight;
    final double resolvedExpandedHeight =
        expandedHeight ??
        (isDesktop
            ? 280
            : isTablet
            ? 240
            : 210);

    return SliverAppBar(
      pinned: pinned,
      floating: floating,
      snap: floating ? snap : false,
      stretch: stretch,
      elevation: elevation,
      scrolledUnderElevation: elevation,
      backgroundColor: backgroundColor ?? AppColors.primary,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      toolbarHeight: resolvedToolbarHeight,
      collapsedHeight: resolvedCollapsedHeight,
      expandedHeight: resolvedExpandedHeight,
      leading: leading ?? (showBackButton ? const BackButton() : null),
      actions: actions ?? _buildDefaultActions(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.xl),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      bottom: bottom,
      flexibleSpace:
          flexibleSpace ??
          LayoutBuilder(
            builder: (context, constraints) {
              return SliverAppBarFlexibleSpace(
                title: title,
                subtitle: subtitle,
                backgroundImage: backgroundImage,
                titleColor: titleColor,
                currentHeight: constraints.biggest.height,
                expandedHeight: resolvedExpandedHeight,
                toolbarHeight: resolvedToolbarHeight,
                isMobile: isMobile,
                isTablet: isTablet,
                isDesktop: isDesktop,
              );
            },
          ),
    );
  }

  List<Widget> _buildDefaultActions() {
    return [
      SliverAppBarActions(
        showSearch: showSearch,
        showNotification: showNotification,
      ),
      if (showProfile) const SliverAppBarProfile(),
    ];
  }
}
