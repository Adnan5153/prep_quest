import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/tag_chip.dart';
import '../../../providers/widget_builder_provider.dart';

class TagChipPreview extends StatelessWidget {
  const TagChipPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TagChip(
              label: provider.tagLabel,
              variant: _mapVariant(provider.tagVariant),
              size: _mapSize(provider.tagSize),
              shape: _mapShape(provider.tagShape),
              selected: provider.isTagSelected,
              enabled: provider.isTagEnabled,
              closable: provider.isTagClosable,
              icon: provider.showTagLeadingIcon ? Icons.tag_rounded : null,
              trailingIcon: provider.showTagTrailingIcon
                  ? Icons.arrow_forward_ios_rounded
                  : null,
              onTap: () {},
              onDeleted: () {},
            ),
            const SizedBox(height: AppSpacing.xxl),
            const Text('Tag Gallery'),
            const SizedBox(height: AppSpacing.md),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  alignment: WrapAlignment.center,
                  children: [
                    TagChip(label: 'BCS', variant: TagChipVariant.soft),
                    TagChip(label: 'Math', variant: TagChipVariant.filled),
                    TagChip(label: 'English', variant: TagChipVariant.outlined),
                    TagChip(label: 'Science', variant: TagChipVariant.tonal),
                    TagChip(
                      label: 'Premium',
                      variant: TagChipVariant.gradient,
                      icon: Icons.workspace_premium,
                    ),
                    TagChip(label: 'Glass', variant: TagChipVariant.glass),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TagChipVariant _mapVariant(String variant) {
    switch (variant) {
      case 'filled':
        return TagChipVariant.filled;
      case 'outlined':
        return TagChipVariant.outlined;
      case 'soft':
        return TagChipVariant.soft;
      case 'gradient':
        return TagChipVariant.gradient;
      case 'glass':
        return TagChipVariant.glass;
      case 'tonal':
        return TagChipVariant.tonal;
      default:
        return TagChipVariant.soft;
    }
  }

  TagChipSize _mapSize(String size) {
    switch (size) {
      case 'small':
        return TagChipSize.small;
      case 'medium':
        return TagChipSize.medium;
      case 'large':
        return TagChipSize.large;
      default:
        return TagChipSize.medium;
    }
  }

  TagChipShape _mapShape(String shape) {
    switch (shape) {
      case 'rounded':
        return TagChipShape.rounded;
      case 'pill':
        return TagChipShape.pill;
      case 'rectangle':
        return TagChipShape.rectangle;
      default:
        return TagChipShape.pill;
    }
  }
}
