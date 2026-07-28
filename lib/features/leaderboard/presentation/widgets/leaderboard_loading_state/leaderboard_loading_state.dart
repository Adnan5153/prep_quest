import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../constants/leaderboard_strings.dart' as strings;

/// Loading state used by the leaderboard screen.
class LeaderboardLoadingState extends StatelessWidget {
  const LeaderboardLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: LoadingWidget(
          title: strings.LeaderboardStrings.loadingTitle,
          subtitle: strings.LeaderboardStrings.loadingSubtitle,
          loaderType: LoaderType.lottie,
        ),
      ),
    );
  }
}