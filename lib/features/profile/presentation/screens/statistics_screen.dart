import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../statistics/presentation/screens/statistics_screen.dart'
    as phase_eighteen;
import '../../domain/entities/user_profile.dart';
import '../providers/profile_providers.dart';
import '../states/profile_state.dart';

/// Profile-flavoured wrapper around the Phase 18 statistics screen.
///
/// Reads the active profile so the screen can adapt its tone based on
/// whether the user is new, returning, or premium.
class ProfileStatisticsScreen extends ConsumerWidget {
  const ProfileStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<ProfileState>(profileControllerProvider, (_, _) {});
    final ProfileState state = ref.watch(profileControllerProvider);
    final UserProfile? profile = state.profile;
    return phase_eighteen.StatisticsScreen(
      key: ValueKey<String>(
        profile?.id ?? 'guest',
      ),
    );
  }
}