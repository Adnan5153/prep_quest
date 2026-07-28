import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../constants/mission_strings.dart';

/// Centered spinner with descriptive label.
class MissionLoadingState extends StatelessWidget {
  const MissionLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.md),
          Text(
            MissionStrings.loadingLabel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}