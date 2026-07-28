import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_action_button.dart';
import '../../../../../../core/widgets/ai/ai_button_variants.dart';
import '../../../providers/widget_builder_provider.dart';

class AiActionButtonPreview extends StatelessWidget {
  const AiActionButtonPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.maxWidth < 480
            ? constraints.maxWidth
            : (constraints.maxWidth < 900 ? 560 : 720);

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AiActionButton(
                    text: provider.state.label,
                    onPressed: () {},
                    variant: _mapVariant(provider.state.aiButtonVariant),
                    size: _mapSize(provider.state.aiButtonSize),
                    state: _mapState(provider.state.aiButtonState),
                    animationType: _mapAnimation(
                      provider.state.aiButtonAnimation,
                    ),
                    icon: provider.state.showAiIcon
                        ? Icons.auto_awesome_rounded
                        : null,
                    fullWidth: provider.state.isButtonFullWidth,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const Text('AI Interface Context'),
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          const Text(
                            'AI actions are used for intelligent tasks like summarizing or explaining.',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AiActionButton(
                            text: 'Quick Summary',
                            onPressed: () {},
                            variant: AiButtonVariant.glass,
                            size: AiButtonSize.small,
                            icon: Icons.summarize_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AiButtonVariant _mapVariant(String variant) {
    return AiButtonVariant.values.firstWhere(
      (e) => e.name == variant,
      orElse: () => AiButtonVariant.filled,
    );
  }

  AiButtonSize _mapSize(String size) {
    return AiButtonSize.values.firstWhere(
      (e) => e.name == size,
      orElse: () => AiButtonSize.medium,
    );
  }

  AiButtonState _mapState(String state) {
    return AiButtonState.values.firstWhere(
      (e) => e.name == state,
      orElse: () => AiButtonState.enabled,
    );
  }

  AiButtonAnimationType _mapAnimation(String animation) {
    return AiButtonAnimationType.values.firstWhere(
      (e) => e.name == animation,
      orElse: () => AiButtonAnimationType.none,
    );
  }
}
