import 'package:flutter/material.dart';

import '../../../../../../core/widgets/responsive_builder.dart';
import '../../../constants/playground_sizes.dart';
import '../../../constants/playground_strings.dart';

enum PlaygroundSheetSlot {
  handle,
  header,
  hero,
  body,
  footer,
  primary,
  secondary,
}

class PlaygroundSheetLayout {
  const PlaygroundSheetLayout({
    required this.maxWidth,
    required this.idealHeight,
    required this.maxHeight,
    required this.minHeight,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.headerGap,
    required this.sectionGap,
    required this.actionGap,
    required this.actionHeight,
    required this.deviceType,
  });

  final double maxWidth;
  final double idealHeight;
  final double maxHeight;
  final double minHeight;
  final double horizontalPadding;
  final double verticalPadding;
  final double headerGap;
  final double sectionGap;
  final double actionGap;
  final double actionHeight;
  final DeviceType deviceType;

  double resolveIdealHeight(double contentHeight) {
    final clamped = contentHeight.clamp(minHeight, maxHeight);
    return clamped < idealHeight ? clamped : idealHeight;
  }

  EdgeInsets get contentPadding => EdgeInsets.symmetric(
    horizontal: horizontalPadding,
    vertical: verticalPadding,
  );

  static PlaygroundSheetLayout resolve(BuildContext context) {
    final deviceType = ResponsiveBuilder.deviceType(context);
    final maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: PlaygroundSizes.bottomSheetMobileMaxWidth,
      tablet: PlaygroundSizes.bottomSheetTabletMaxWidth,
      desktop: PlaygroundSizes.bottomSheetDesktopMaxWidth,
    );
    return PlaygroundSheetLayout(
      maxWidth: maxWidth,
      idealHeight: PlaygroundSizes.bottomSheetIdealHeight,
      maxHeight: PlaygroundSizes.bottomSheetMaxHeight,
      minHeight: PlaygroundSizes.bottomSheetMinHeight,
      horizontalPadding: PlaygroundSizes.bottomSheetPaddingHorizontal,
      verticalPadding: PlaygroundSizes.bottomSheetPaddingVertical,
      headerGap: PlaygroundSizes.bottomSheetHeaderGap,
      sectionGap: PlaygroundSizes.bottomSheetSectionGap,
      actionGap: PlaygroundSizes.bottomSheetActionGap,
      actionHeight: PlaygroundSizes.bottomSheetActionHeight,
      deviceType: deviceType,
    );
  }

  static double resolveSheetHeight(
    BuildContext context, {
    required double contentHeight,
  }) {
    final layout = resolve(context);
    return layout.resolveIdealHeight(contentHeight);
  }

  String debugLabel() => 'PlaygroundSheet[${deviceType.name}]';
}

class PlaygroundSheetSemantics {
  const PlaygroundSheetSemantics._();

  static String labelFor(String? override) {
    return override ?? PlaygroundStrings.sheetSemantic;
  }
}
