import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/loading_overlay.dart';
import '../../../providers/widget_builder_provider.dart';

class LoadingOverlayPreview extends StatelessWidget {
  const LoadingOverlayPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 650,
      child: LoadingOverlay(
        isLoading: true,
        message: provider.label,
        subMessage: provider.subtitle,
        child: ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: 12,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text('Lesson ${index + 1}'),
                subtitle: const Text('Preview background content'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            );
          },
        ),
      ),
    );
  }
}
