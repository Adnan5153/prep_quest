import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/constants/app_radius.dart';
import '../../../../../../core/widgets/responsive_builder.dart';
import '../../../providers/widget_builder_provider.dart';

class ResponsiveBuilderPreview extends StatelessWidget {
  const ResponsiveBuilderPreview({super.key, required this.provider});

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
                child: ResponsiveBuilder(
                  builder: (context, info) {
                    return Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getDeviceIcon(info.deviceType),
                            size: 48,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            info.deviceType.name.toUpperCase(),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${info.screenWidth.toInt()} x ${info.screenHeight.toInt()}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            info.orientation.name,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return Icons.phone_android_rounded;
      case DeviceType.tablet:
        return Icons.tablet_android_rounded;
      case DeviceType.desktop:
        return Icons.desktop_windows_rounded;
      case DeviceType.largeDesktop:
        return Icons.monitor_rounded;
    }
  }
}
