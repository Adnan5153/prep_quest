import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/constants/app_radius.dart';
import '../../../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../providers/widget_builder_provider.dart';

class CustomSliverAppBarPreview extends StatelessWidget {
  const CustomSliverAppBarPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 420,
      height: 650,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Material(
          elevation: AppSizes.cardElevation,
          child: CustomScrollView(
            slivers: [
              CustomSliverAppBar(
                title: provider.label,
                subtitle: provider.subtitle,

                showBackButton: provider.showLeading,

                showSearch: true,

                showNotification: true,

                showProfile: true,

                pinned: true,

                floating: false,

                stretch: true,
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text("${index + 1}")),
                      title: Text("Sample Lesson ${index + 1}"),
                      subtitle: const Text(
                        "Scroll to preview the collapsing app bar.",
                      ),
                    ),
                  );
                }, childCount: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
