import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/xp_progress_bar.dart';
import '../../../providers/widget_builder_provider.dart';

class XPProgressBarPreview extends StatelessWidget {
  const XPProgressBarPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    XPProgressBar(
                      currentXP: provider.currentXPValue,
                      requiredXP: provider.requiredXPValue,
                      currentLevel: provider.currentLevelValue,
                      nextLevel: provider.nextLevelValue,
                      title: provider.label,
                      subtitle: provider.subtitle,
                      showPercentage: provider.showXPPercentage,
                      showLevel: provider.showLevelBadge,
                      showXPText: provider.showXPText,
                      showAnimation: provider.showXPBarAnimation,
                      showGlow: provider.showXPBarGlow,
                      showIcon: provider.showXPBarIcon,
                      variant: _mapVariant(provider.xpBarVariant),
                      progress: provider.xpBarProgressValue,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const Text('Variant Gallery'),
            const SizedBox(height: AppSpacing.md),
            const XPProgressBar(
              currentXP: 800,
              requiredXP: 1000,
              title: 'Gradient Style',
              variant: XPProgressBarVariant.gradient,
            ),
            const XPProgressBar(
              currentXP: 600,
              requiredXP: 1000,
              title: 'Glass Style',
              variant: XPProgressBarVariant.glass,
              backgroundColor: Colors.blueGrey,
            ),
            const XPProgressBar(
              currentXP: 900,
              requiredXP: 1000,
              title: 'Minimal Style',
              variant: XPProgressBarVariant.minimal,
            ),
          ],
        ),
      ),
    );
  }

  XPProgressBarVariant _mapVariant(String variant) {
    switch (variant) {
      case 'linear':
        return XPProgressBarVariant.linear;
      case 'rounded':
        return XPProgressBarVariant.rounded;
      case 'gradient':
        return XPProgressBarVariant.gradient;
      case 'glass':
        return XPProgressBarVariant.glass;
      case 'glowing':
        return XPProgressBarVariant.glowing;
      case 'minimal':
        return XPProgressBarVariant.minimal;
      case 'compact':
        return XPProgressBarVariant.compact;
      default:
        return XPProgressBarVariant.rounded;
    }
  }
}
