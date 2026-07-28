import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/constants/app_radius.dart';
import '../../../../../../core/widgets/fullscreen_loader.dart';
import '../../../providers/widget_builder_provider.dart';

class FullscreenLoaderPreview extends StatelessWidget {
  const FullscreenLoaderPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        width: double.infinity,
        height: 650,
        child: Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text("${index + 1}")),
                    title: Text("Sample Item ${index + 1}"),
                    subtitle: const Text("Background preview"),
                  ),
                );
              },
            ),

            const FullscreenLoader(
              title: "Loading...",
              subtitle: "Preparing your learning experience",
              showProgress: true,
              progress: .65,
            ),
          ],
        ),
      ),
    );
  }
}
