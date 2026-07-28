import 'package:flutter/material.dart';
import 'responsive_builder.dart';

/// A reusable responsive layout switcher.
///
/// Automatically displays different widget trees based on the current
/// device breakpoint (Mobile, Tablet, Desktop, or Large Desktop).
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
    this.fallback,
    this.padding,
    this.margin,
    this.alignment = Alignment.center,
    this.safeArea = true,
  });

  /// Widget to display for mobile screens (< 600px).
  final Widget mobile;

  /// Optional widget for tablet screens (600px - 1024px).
  final Widget? tablet;

  /// Optional widget for desktop screens (1024px - 1440px).
  final Widget? desktop;

  /// Optional widget for large desktop screens (>= 1440px).
  final Widget? largeDesktop;

  /// Optional fallback widget if no matching breakpoint is provided.
  /// If null, it follows the fallback order: Large -> Desktop -> Tablet -> Mobile.
  final Widget? fallback;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry alignment;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    Widget content = ResponsiveBuilder(
      builder: (context, info) {
        // Breakpoint matching logic with fallback chain.
        if (info.isLargeDesktop && largeDesktop != null) return largeDesktop!;
        if (info.isDesktop && (desktop != null || largeDesktop != null)) {
          return desktop ?? largeDesktop!;
        }
        if (info.isTablet &&
            (tablet != null || desktop != null || largeDesktop != null)) {
          return tablet ?? desktop ?? largeDesktop!;
        }

        // Final fallback to mobile if nothing else matches.
        return fallback ?? mobile;
      },
    );

    if (padding != null || margin != null) {
      content = Container(
        padding: padding,
        margin: margin,
        alignment: alignment,
        child: content,
      );
    }

    if (safeArea) {
      content = SafeArea(child: content);
    }

    return content;
  }

  /// Static helper for quick device type detection.
  static DeviceType deviceType(BuildContext context) {
    return ResponsiveBuilder.deviceType(context);
  }

  static bool isMobile(BuildContext context) =>
      ResponsiveBuilder.isMobile(context);

  static bool isTablet(BuildContext context) =>
      ResponsiveBuilder.isTablet(context);

  static bool isDesktop(BuildContext context) =>
      ResponsiveBuilder.isDesktop(context);

  static bool isLargeDesktop(BuildContext context) =>
      ResponsiveBuilder.isLargeDesktop(context);
}
