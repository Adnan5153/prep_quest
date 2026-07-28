import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/image_placeholder.dart';
import '../../../providers/widget_builder_provider.dart';

class ImagePlaceholderPreview extends StatelessWidget {
  const ImagePlaceholderPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 650,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ImagePlaceholder(
            width: 320,
            height: 240,
            title: provider.label,
            subtitle: provider.subtitle,
            showRetryButton: true,
            onRetry: () {},
          ),
        ),
      ),
    );
  }
}
