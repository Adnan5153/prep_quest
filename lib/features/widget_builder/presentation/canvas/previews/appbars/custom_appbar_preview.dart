import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/constants/app_radius.dart';
import '../../../../../../core/widgets/custom_appbar.dart';
import '../../../providers/widget_builder_provider.dart';

class CustomAppBarPreview extends StatelessWidget {
  const CustomAppBarPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CustomAppBar(
            title: provider.label,
            subtitle: provider.subtitle,
            showAccentStripe: provider.showAccentStripe,
            leading: provider.showLeading
                ? const CircleAvatar(
                    radius: AppSizes.iconMd / 2,
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: AppSizes.iconSm,
                    ),
                  )
                : null,
            actions: <Widget>[
              IconButton(
                tooltip: 'Search',
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
              IconButton(
                tooltip: 'More',
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          const _PreviewBody(),
        ],
      ),
    );
  }
}

class _PreviewBody extends StatelessWidget {
  const _PreviewBody();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.md),
          bottomRight: Radius.circular(AppRadius.md),
        ),
      ),
      alignment: Alignment.center,
      child: Text('Page content area', style: theme.textTheme.bodyMedium),
    );
  }
}
