import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_avatar_animation.dart';
import '../../../../../../core/widgets/ai/ai_avatar_constants.dart';
import '../../../../../../core/widgets/ai/ai_avatar_extensions.dart';
import '../../../../../../core/widgets/ai/ai_avatar_status.dart';
import '../../../providers/widget_builder_provider.dart';

/// Live preview for the [AiAvatarAnimation] widget inside the Widget Builder.
///
/// Reads its knobs from [WidgetBuilderProvider.state] so palette edits
/// propagate immediately, and clamps the requested diameter against
/// [AiAvatarConstants.minSize] / [AiAvatarConstants.maxSize] so the widget's
/// own assertions can never fire during preview.
class AiAvatarAnimationPreview extends StatelessWidget {
  const AiAvatarAnimationPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color surface = theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.surfaceContainerHighest;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Reserve room for the orb's halo extension so the canvas never
        // clips the glow on narrow screens.
        final double maxDiameter = (constraints.maxHeight - AppSpacing.xxl * 4)
            .clamp(AiAvatarConstants.minSize, AiAvatarConstants.maxSize)
            .toDouble();
        final double requested = provider.state.aiAvatarSize
            .clamp(0.0, double.infinity)
            .toDouble();
        final double diameter = requested <= maxDiameter
            ? requested.clamp(
                AiAvatarConstants.minSize,
                AiAvatarConstants.maxSize,
              )
            : maxDiameter;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - AppSpacing.xxl * 2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: AppSizes.mobileMaxWidth,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xxl,
                      horizontal: AppSpacing.lg,
                    ),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: AiAvatarAnimation(
                        status: _resolveStatus(provider.state.aiAvatarStatus),
                        size: diameter,
                        animationSpeed: _resolveSpeed(
                          provider.state.aiAvatarSpeed,
                        ),
                        animationIntensity: _resolveIntensity(
                          provider.state.aiAvatarIntensity,
                        ),
                        glowEnabled: provider.state.aiAvatarGlowEnabled,
                        haloEnabled: provider.state.aiAvatarHaloEnabled,
                        particlesEnabled:
                            provider.state.aiAvatarParticlesEnabled,
                        shadowEnabled: provider.state.aiAvatarShadowEnabled,
                        borderWidth: provider.state.aiAvatarBorderWidth > 0
                            ? provider.state.aiAvatarBorderWidth
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    _resolveStatus(provider.state.aiAvatarStatus).caption,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${diameter.toStringAsFixed(0)} px · '
                    '${_resolveSpeed(provider.state.aiAvatarSpeed).name} · '
                    '${_resolveIntensity(provider.state.aiAvatarIntensity).name}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AiAvatarStatus _resolveStatus(String value) {
    switch (value) {
      case 'listening':
        return AiAvatarStatus.listening;
      case 'thinking':
        return AiAvatarStatus.thinking;
      case 'generating':
        return AiAvatarStatus.generating;
      case 'typing':
        return AiAvatarStatus.typing;
      case 'speaking':
        return AiAvatarStatus.speaking;
      case 'success':
        return AiAvatarStatus.success;
      case 'warning':
        return AiAvatarStatus.warning;
      case 'error':
        return AiAvatarStatus.error;
      case 'offline':
        return AiAvatarStatus.offline;
      case 'idle':
      default:
        return AiAvatarStatus.idle;
    }
  }

  AiAvatarAnimationSpeed _resolveSpeed(String value) {
    switch (value) {
      case 'none':
        return AiAvatarAnimationSpeed.none;
      case 'slow':
        return AiAvatarAnimationSpeed.slow;
      case 'fast':
        return AiAvatarAnimationSpeed.fast;
      case 'normal':
      default:
        return AiAvatarAnimationSpeed.normal;
    }
  }

  AiAvatarAnimationIntensity _resolveIntensity(String value) {
    switch (value) {
      case 'subtle':
        return AiAvatarAnimationIntensity.subtle;
      case 'bold':
        return AiAvatarAnimationIntensity.bold;
      case 'normal':
      default:
        return AiAvatarAnimationIntensity.normal;
    }
  }
}
