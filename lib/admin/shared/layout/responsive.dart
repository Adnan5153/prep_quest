import 'package:flutter/widgets.dart';

import '../../core/theme/admin_spacing.dart';

enum AdminBreakpoint {
  compact(0, 640),
  medium(641, 1100),
  expanded(1101, 1440),
  wide(1441, 9999);

  const AdminBreakpoint(this.min, this.max);

  final int min;
  final int max;

  bool contains(double width) => width >= min && width <= max;

  static AdminBreakpoint of(double width) {
    for (final AdminBreakpoint bp in AdminBreakpoint.values) {
      if (bp.contains(width)) return bp;
    }
    return AdminBreakpoint.medium;
  }
}

class AdminLayoutMetrics {
  const AdminLayoutMetrics({
    required this.breakpoint,
    required this.sidebarWidth,
    required this.maxContentWidth,
  });

  final AdminBreakpoint breakpoint;
  final double sidebarWidth;
  final double maxContentWidth;

  static AdminLayoutMetrics of(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final AdminBreakpoint bp = AdminBreakpoint.of(width);
    return AdminLayoutMetrics(
      breakpoint: bp,
      sidebarWidth: bp == AdminBreakpoint.compact
          ? AdminSpacing.sidebarCollapsed
          : AdminSpacing.sidebarExpanded,
      maxContentWidth: width,
    );
  }
}
