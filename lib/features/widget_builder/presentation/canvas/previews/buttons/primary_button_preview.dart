import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/primary_button.dart';
import '../../../providers/widget_builder_provider.dart';

class PrimaryButtonPreview extends StatelessWidget {
  const PrimaryButtonPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              text: provider.buttonText,
              onPressed: provider.isButtonEnabled ? () {} : null,
              isLoading: provider.isButtonLoading,
              variant: _mapVariant(provider.buttonVariant),
              size: _mapSize(provider.buttonSize),
              shape: _mapShape(provider.buttonShape),
              icon: provider.showButtonLeadingIcon ? Icons.send_rounded : null,
              trailingIcon: provider.showButtonTrailingIcon
                  ? Icons.arrow_forward_rounded
                  : null,
              fullWidth: provider.isButtonFullWidth,
            ),
            const SizedBox(height: AppSpacing.xxl),
            const Text('Demo Context'),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    const Text(
                      'Buttons are used for primary actions like submitting forms or starting tasks.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PrimaryButton(
                      text: 'Cancel',
                      onPressed: () {},
                      variant: PrimaryButtonVariant.tonal,
                      size: PrimaryButtonSize.small,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PrimaryButtonVariant _mapVariant(String variant) {
    switch (variant) {
      case 'filled':
        return PrimaryButtonVariant.filled;
      case 'gradient':
        return PrimaryButtonVariant.gradient;
      case 'outlined':
        return PrimaryButtonVariant.outlined;
      case 'tonal':
        return PrimaryButtonVariant.tonal;
      default:
        return PrimaryButtonVariant.filled;
    }
  }

  PrimaryButtonSize _mapSize(String size) {
    switch (size) {
      case 'small':
        return PrimaryButtonSize.small;
      case 'medium':
        return PrimaryButtonSize.medium;
      case 'large':
        return PrimaryButtonSize.large;
      default:
        return PrimaryButtonSize.medium;
    }
  }

  PrimaryButtonShape _mapShape(String shape) {
    switch (shape) {
      case 'rounded':
        return PrimaryButtonShape.rounded;
      case 'pill':
        return PrimaryButtonShape.pill;
      case 'rectangle':
        return PrimaryButtonShape.rectangle;
      default:
        return PrimaryButtonShape.rounded;
    }
  }
}
