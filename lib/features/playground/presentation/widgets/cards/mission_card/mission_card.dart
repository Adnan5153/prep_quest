import 'package:flutter/material.dart';

import '../../../../../../core/widgets/responsive_builder.dart';
import '../../../../../../core/widgets/widget_constants.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import 'mission_card_container.dart';
import 'mission_card_visual.dart';
import 'mission_utils.dart';

class MissionCard extends StatelessWidget {
  const MissionCard({
    super.key,
    required this.visual,
    this.onTap,
    this.onClaim,
  });

  final MissionVisual visual;
  final VoidCallback? onTap;
  final VoidCallback? onClaim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scale = ResponsiveBuilder.value<double>(
      context,
      mobile: 1.0,
      tablet: PlaygroundSizes.cardTabletScale,
      desktop: PlaygroundSizes.cardDesktopScale,
    );

    return RepaintBoundary(
      child: Semantics(
        label: MissionSemanticResolver.labelFor(visual.state),
        button: onTap != null && visual.isInteractive,
        enabled: visual.isInteractive,
        container: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: PlaygroundSizes.cardMinWidth * scale,
            maxWidth: PlaygroundSizes.cardMaxWidth * scale,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: visual.isInteractive ? onTap : null,
            child: AnimatedScale(
              scale: 1.0,
              duration: WidgetConstants.pressAnimationDuration,
              curve: PlaygroundCurves.stateEase,
              child: MissionCardContainer(
                visual: visual,
                isDark: isDark,
                scale: scale,
                onClaim: onClaim,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
