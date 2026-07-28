import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/glass_card.dart';
import '../../../providers/widget_builder_provider.dart';

class GlassCardPreview extends StatelessWidget {
  const GlassCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: 600,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: GlassCard(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome,
                size: AppSizes.iconXl,
                color: Colors.white,
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                provider.label,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                provider.subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow),
                label: const Text("Start"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
