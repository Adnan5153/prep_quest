import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/constants/app_radius.dart';
import '../../../../../../core/widgets/responsive_layout.dart';
import '../../../providers/widget_builder_provider.dart';

class ResponsiveLayoutPreview extends StatelessWidget {
  const ResponsiveLayoutPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Size simulatedSize = _getSimulatedSize();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Container(
              width: simulatedSize.width,
              height: simulatedSize.height,
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md - 1),
                child: ResponsiveLayout(
                  mobile: _buildDemoLayout('Mobile Layout', Colors.blue),
                  tablet: _buildDemoLayout('Tablet Layout', Colors.green),
                  desktop: _buildDemoLayout('Desktop Layout', Colors.orange),
                  largeDesktop: _buildDemoLayout(
                    'Large Desktop Layout',
                    Colors.purple,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Simulation: ${provider.simulatedDevice} (${provider.isSimulatedLandscape ? "Landscape" : "Portrait"})',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoLayout(String label, Color color) {
    return Container(
      color: color.withValues(alpha: 0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(
                Icons.layers_outlined,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Switch device size in palette to see this layout change.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Size _getSimulatedSize() {
    double w, h;
    switch (provider.simulatedDevice) {
      case 'mobile':
        w = 360;
        h = 640;
      case 'tablet':
        w = 768;
        h = 1024;
      case 'desktop':
        w = 1200;
        h = 800;
      case 'largeDesktop':
        w = 1600;
        h = 900;
      default:
        w = 360;
        h = 640;
    }

    if (provider.isSimulatedLandscape) {
      return Size(h, w);
    }
    return Size(w, h);
  }
}
