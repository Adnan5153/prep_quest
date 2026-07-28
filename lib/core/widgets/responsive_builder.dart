import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

/// Enum defining the supported device types based on screen width.
enum DeviceType { mobile, tablet, desktop, largeDesktop }

/// Data model containing detailed responsiveness information.
class ResponsiveInfo {
  const ResponsiveInfo({
    required this.screenWidth,
    required this.screenHeight,
    required this.orientation,
    required this.deviceType,
    required this.padding,
    required this.viewInsets,
  });

  final double screenWidth;
  final double screenHeight;
  final Orientation orientation;
  final DeviceType deviceType;
  final EdgeInsets padding;
  final EdgeInsets viewInsets;

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
  bool get isLargeDesktop => deviceType == DeviceType.largeDesktop;

  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;
}

/// Signature for the builder function used by [ResponsiveBuilder].
typedef ResponsiveWidgetBuilder =
    Widget Function(BuildContext context, ResponsiveInfo info);

/// A reusable responsive layout builder.
///
/// Automatically provides [ResponsiveInfo] to its builder callback,
/// allowing for adaptive layouts without repeated [MediaQuery] calls.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
    this.fallback,
  });

  final ResponsiveWidgetBuilder builder;

  /// Optional widget overrides for specific breakpoints.
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final media = MediaQuery.of(context);
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final deviceType = _getDeviceType(width);

        if (deviceType == DeviceType.mobile && mobile != null) return mobile!;
        if (deviceType == DeviceType.tablet && tablet != null) return tablet!;
        if (deviceType == DeviceType.desktop && desktop != null)
          return desktop!;
        if (deviceType == DeviceType.largeDesktop && largeDesktop != null) {
          return largeDesktop!;
        }

        if (fallback != null) return fallback!;

        final info = ResponsiveInfo(
          screenWidth: width,
          screenHeight: height,
          orientation: width > height
              ? Orientation.landscape
              : Orientation.portrait,
          deviceType: deviceType,
          padding: media.padding,
          viewInsets: media.viewInsets,
        );

        return builder(context, info);
      },
    );
  }

  static DeviceType _getDeviceType(double width) {
    if (width < AppSizes.mobileMaxWidth) return DeviceType.mobile;
    if (width < AppSizes.tabletMaxWidth) return DeviceType.tablet;
    if (width < AppSizes.desktopMaxWidth) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }

  /// Static helper methods for quick access to device type.
  static DeviceType deviceType(BuildContext context) {
    return _getDeviceType(MediaQuery.sizeOf(context).width);
  }

  static bool isMobile(BuildContext context) =>
      deviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      deviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      deviceType(context) == DeviceType.desktop;

  static bool isLargeDesktop(BuildContext context) =>
      deviceType(context) == DeviceType.largeDesktop;

  /// Returns a value based on the current device type.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }
}
