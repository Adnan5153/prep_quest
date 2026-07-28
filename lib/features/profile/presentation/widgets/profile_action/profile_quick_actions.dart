import 'package:flutter/material.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../../domain/entities/user_profile.dart';
import 'profile_action_tile.dart';
import '../../constants/profile_strings.dart';

/// Grid of quick-action tiles used by the Profile screen.
///
/// The list of actions comes from [UserProfile.quickActions]. Unknown
/// ids fall back to a no-op tile so the layout never breaks.
class ProfileQuickActions extends StatelessWidget {
  const ProfileQuickActions({
    super.key,
    required this.profile,
    required this.onAction,
  });

  final UserProfile profile;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int crossAxisCount = ResponsiveBuilder.value<int>(
      context,
      mobile: 3,
      tablet: 4,
      desktop: 5,
    );

    final List<_ActionDescriptor> descriptors = profile.quickActions
        .map(_descriptorFor)
        .whereType<_ActionDescriptor>()
        .toList(growable: false);

    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            ProfileStrings.quickActionsSectionTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: descriptors.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (BuildContext context, int index) {
              final _ActionDescriptor descriptor = descriptors[index];
              return ProfileActionTile(
                icon: descriptor.icon,
                label: descriptor.label,
                color: descriptor.color,
                onTap: () => onAction(descriptor.id),
              );
            },
          ),
        ],
      ),
    );
  }

  _ActionDescriptor? _descriptorFor(String id) {
    switch (id) {
      case ProfileStrings.resumeActionId:
        return _ActionDescriptor(
          id: id,
          icon: Icons.play_arrow_rounded,
          label: ProfileStrings.resumeAction,
          color: null,
        );
      case ProfileStrings.mockTestActionId:
        return _ActionDescriptor(
          id: id,
          icon: Icons.assignment_rounded,
          label: ProfileStrings.mockTestAction,
          color: null,
        );
      case ProfileStrings.guidebookActionId:
        return _ActionDescriptor(
          id: id,
          icon: AppIcons.book,
          label: ProfileStrings.guidebookAction,
          color: null,
        );
      case ProfileStrings.leaderboardActionId:
        return _ActionDescriptor(
          id: id,
          icon: AppIcons.trophy,
          label: ProfileStrings.leaderboardAction,
          color: null,
        );
      case ProfileStrings.aiTutorActionId:
        return _ActionDescriptor(
          id: id,
          icon: AppIcons.sparkle,
          label: ProfileStrings.aiTutorAction,
          color: null,
        );
      case ProfileStrings.rewardsActionId:
        return _ActionDescriptor(
          id: id,
          icon: AppIcons.gem,
          label: ProfileStrings.rewardsAction,
          color: null,
        );
      case ProfileStrings.missionsActionId:
        return _ActionDescriptor(
          id: id,
          icon: AppIcons.mission,
          label: ProfileStrings.missionsAction,
          color: null,
        );
      case ProfileStrings.streakActionId:
        return _ActionDescriptor(
          id: id,
          icon: AppIcons.streak,
          label: ProfileStrings.streakAction,
          color: null,
        );
      case ProfileStrings.searchActionId:
        return _ActionDescriptor(
          id: id,
          icon: AppIcons.search,
          label: ProfileStrings.searchAction,
          color: null,
        );
      default:
        return null;
    }
  }
}

class _ActionDescriptor {
  const _ActionDescriptor({
    required this.id,
    required this.icon,
    required this.label,
    required this.color,
  });

  final String id;
  final IconData icon;
  final String label;
  final Color? color;
}