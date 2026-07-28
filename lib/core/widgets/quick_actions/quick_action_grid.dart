import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../widgets/responsive_builder.dart';
import 'quick_action_tile.dart';

/// Adaptive grid that renders [QuickActionTile]s with the right
/// column count for the active breakpoint.
class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({
    super.key,
    required this.actions,
    this.spacing = AppSpacing.md,
  });

  final List<QuickActionItem> actions;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    final int crossAxisCount = ResponsiveBuilder.value<int>(
      context,
      mobile: 4,
      tablet: 5,
      desktop: 6,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 0.95,
      ),
      itemCount: actions.length,
      itemBuilder: (BuildContext context, int index) {
        return QuickActionTile(action: actions[index]);
      },
    );
  }
}