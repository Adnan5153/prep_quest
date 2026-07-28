import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/secondary_button.dart';
import '../../../../../../core/widgets/primary_button.dart';
import '../../../providers/widget_builder_provider.dart';

class SecondaryButtonPreview extends StatelessWidget {
  const SecondaryButtonPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SecondaryButton(
              text: provider.secButtonText,
              onPressed: provider.isSecButtonEnabled ? () {} : null,
              isLoading: provider.isSecButtonLoading,
              variant: _mapVariant(provider.secButtonVariant),
              size: _mapSize(provider.secButtonSize),
              shape: _mapShape(provider.secButtonShape),
              icon: provider.showSecButtonLeadingIcon
                  ? Icons.close_rounded
                  : null,
              trailingIcon: provider.showSecButtonTrailingIcon
                  ? Icons.chevron_right_rounded
                  : null,
              fullWidth: provider.isSecButtonFullWidth,
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
                      'Secondary buttons are used for supporting actions that provide alternatives.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SecondaryButton(
                          text: 'Cancel',
                          onPressed: () {},
                          variant: SecondaryButtonVariant.text,
                          size: SecondaryButtonSize.small,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        PrimaryButton(
                          text: 'Continue',
                          onPressed: () {},
                          size: PrimaryButtonSize.small,
                        ),
                      ],
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

  SecondaryButtonVariant _mapVariant(String variant) {
    switch (variant) {
      case 'outlined':
        return SecondaryButtonVariant.outlined;
      case 'tonal':
        return SecondaryButtonVariant.tonal;
      case 'text':
        return SecondaryButtonVariant.text;
      case 'glass':
        return SecondaryButtonVariant.glass;
      default:
        return SecondaryButtonVariant.outlined;
    }
  }

  SecondaryButtonSize _mapSize(String size) {
    switch (size) {
      case 'small':
        return SecondaryButtonSize.small;
      case 'medium':
        return SecondaryButtonSize.medium;
      case 'large':
        return SecondaryButtonSize.large;
      default:
        return SecondaryButtonSize.medium;
    }
  }

  SecondaryButtonShape _mapShape(String shape) {
    switch (shape) {
      case 'rounded':
        return SecondaryButtonShape.rounded;
      case 'pill':
        return SecondaryButtonShape.pill;
      case 'rectangle':
        return SecondaryButtonShape.rectangle;
      default:
        return SecondaryButtonShape.rounded;
    }
  }
}
