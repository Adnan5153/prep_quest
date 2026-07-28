import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/animated_card.dart';
import '../../../providers/widget_builder_provider.dart';

class AnimatedCardPreview extends StatelessWidget {
  const AnimatedCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            AnimatedCard(
              title: provider.cardTitle,
              subtitle: provider.cardSubtitle,
              variant: _mapVariant(provider.cardVariant),
              animationType: _mapAnimation(provider.cardAnimationType),
              enableHover: provider.enableCardHover,
              enableGlow: provider.enableCardGlow,
              glassEffect: provider.enableCardGlass,
              onTap: () {},
              leading: const Icon(Icons.star_rounded, color: AppColors.accent),
              trailing: const Icon(Icons.chevron_right_rounded),
              child: const Text(
                'This is the main content of the animated card. You can put any widget here.',
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Variant Gallery',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            const AnimatedCard(
              title: 'Gradient Variant',
              variant: CardVariant.gradient,
              child: Text('Modern branded look'),
            ),
            const SizedBox(height: AppSpacing.md),
            const AnimatedCard(
              title: 'Glass Variant',
              variant: CardVariant.glass,
              backgroundColor: Colors.blueGrey,
              child: Text('Frosted glass effect'),
            ),
          ],
        ),
      ),
    );
  }

  CardVariant _mapVariant(String variant) {
    switch (variant) {
      case 'filled':
        return CardVariant.filled;
      case 'outlined':
        return CardVariant.outlined;
      case 'glass':
        return CardVariant.glass;
      case 'gradient':
        return CardVariant.gradient;
      default:
        return CardVariant.filled;
    }
  }

  CardAnimationType _mapAnimation(String animation) {
    switch (animation) {
      case 'fade':
        return CardAnimationType.fade;
      case 'scale':
        return CardAnimationType.scale;
      case 'slide':
        return CardAnimationType.slide;
      case 'none':
        return CardAnimationType.none;
      default:
        return CardAnimationType.scale;
    }
  }
}
