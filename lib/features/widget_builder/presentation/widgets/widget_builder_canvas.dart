import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/widget_builder_provider.dart';
import '../canvas/widget_preview_router.dart';

/// Live preview surface that renders the widget selected in
/// [WidgetBuilderPalette]. Pure presentation — no state of its own.
class WidgetBuilderCanvas extends StatelessWidget {
  const WidgetBuilderCanvas({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Preview',
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: Center(
                child: WidgetPreviewRouter.getPreview(provider, theme),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
