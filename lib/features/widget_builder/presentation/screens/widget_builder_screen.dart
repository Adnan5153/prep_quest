import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../providers/widget_builder_provider.dart';
import '../widgets/widget_builder_canvas.dart';
import '../widgets/widget_builder_palette.dart';

/// Single-route "widget builder" landing screen.
///
/// The screen is intentionally composition-only: layout and event wiring
/// live here, while every piece of behavior (current selection, label text)
/// lives in [WidgetBuilderProvider].
class WidgetBuilderScreen extends StatefulWidget {
  const WidgetBuilderScreen({super.key});

  @override
  State<WidgetBuilderScreen> createState() => _WidgetBuilderScreenState();
}

class _WidgetBuilderScreenState extends State<WidgetBuilderScreen> {
  late final WidgetBuilderProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = WidgetBuilderProvider();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.widgetBuilderTitle,
        subtitle: AppStrings.widgetBuilderSubtitle,
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool isWide = constraints.maxWidth >= 720;

              Widget buildCanvas() => AnimatedBuilder(
                animation: _provider,
                builder: (BuildContext context, _) =>
                    WidgetBuilderCanvas(provider: _provider),
              );

              Widget buildPalette() => AnimatedBuilder(
                animation: _provider,
                builder: (BuildContext context, _) => WidgetBuilderPalette(
                  provider: _provider,
                  onSelectionChanged: (value) => _provider.selection = value,
                  onLabelChanged: (value) => _provider.label = value,
                  onSubtitleChanged: (value) => _provider.subtitle = value,
                  onShowLeadingChanged: (value) =>
                      _provider.showLeading = value,
                  onShowAccentStripeChanged: (value) =>
                      _provider.showAccentStripe = value,
                ),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppStrings.widgetBuilderSubtitle,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(flex: 2, child: buildCanvas()),
                              const SizedBox(width: AppSpacing.xl),
                              Expanded(flex: 1, child: buildPalette()),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(flex: 1, child: buildCanvas()),
                              const SizedBox(height: AppSpacing.xl),
                              Expanded(flex: 1, child: buildPalette()),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
