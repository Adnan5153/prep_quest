import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/custom_search_field.dart';
import '../../constants/leaderboard_strings.dart' as strings;

/// Search bar used by the detail screen.
class LeaderboardSearchBar extends StatelessWidget {
  const LeaderboardSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: CustomSearchField(
        controller: controller,
        hintText: strings.LeaderboardStrings.searchHint,
        onChanged: onChanged,
      ),
    );
  }
}