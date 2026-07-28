import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../constants/mission_strings.dart';

/// Inline error placeholder used when the missions pipeline fails to
/// load or to apply a mutation.
class MissionErrorState extends StatelessWidget {
  const MissionErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(AppIcons.error, size: AppSizes.iconXl),
            const SizedBox(height: AppSpacing.md),
            Text(
              MissionStrings.errorTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(
              text: MissionStrings.errorRetry,
              icon: AppIcons.refresh,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}