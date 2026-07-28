import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../domain/entities/user_profile.dart';
import '../../../playground/presentation/widgets/overlays/coin_counter.dart';
import '../../../playground/presentation/widgets/overlays/energy_indicator.dart';
import '../../../playground/presentation/widgets/overlays/profile_summary.dart';
import '../../../playground/presentation/widgets/overlays/streak_card.dart';
import '../../../playground/presentation/widgets/overlays/xp_indicator.dart';

/// Adapters that translate a [UserProfile] into the visual types the
/// Playground HUD already expects.
///
/// Keeps the Playground widgets (which are presentation primitives)
/// decoupled from the Profile feature. New consumers can map
/// [UserProfile] into their own visuals without modifying the entity.
class ProfileVisualMapper {
  const ProfileVisualMapper._();

  static ProfileVisual toProfileVisual(UserProfile profile) {
    return ProfileVisual(
      displayName: profile.displayName,
      level: profile.progression.level,
      imageUrl: profile.photoUrl.isEmpty ? null : profile.photoUrl,
      initials: profile.initials,
      isOnline: profile.lastUpdatedAt
          .isAfter(DateTime.now().subtract(const Duration(minutes: 5))),
      isPremium: profile.role == 'premium',
      leagueName: profile.progression.rank.displayName,
    );
  }

  static XpVisual toXpVisual(UserProfile profile) {
    return XpVisual(
      totalXp: profile.progression.totalXp,
      userLevel: profile.progression.level,
      xpInLevel: profile.progression.xpInLevel,
      xpForNextLevel: profile.progression.xpForNextLevel,
    );
  }

  static CoinVisual toCoinVisual(UserProfile profile) {
    return CoinVisual(balance: profile.progression.coins);
  }

  static EnergyVisual toEnergyVisual(UserProfile profile) {
    return EnergyVisual(
      remaining: profile.progression.energy,
      max: profile.progression.maxEnergy,
      rechargeSecondsRemaining:
          profile.progression.energyRechargeSecondsRemaining,
    );
  }

  static StreakVisual toStreakVisual(UserProfile profile) {
    return StreakVisual(
      days: profile.progression.streakDays,
      isAtRisk: profile.progression.isStreakAtRisk,
    );
  }

  /// Returns the appropriate Material icon for a profile icon-name.
  static IconData iconFor(String name) {
    switch (name) {
      case 'check_circle':
        return Icons.check_circle_rounded;
      case 'local_fire_department':
        return AppIcons.fireFilled;
      case 'military_tech':
        return Icons.military_tech_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      case 'workspace_premium':
        return AppIcons.crown;
      case 'directions_run':
        return Icons.directions_run_rounded;
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'nightlight':
        return Icons.nightlight_round;
      case 'wb_sunny':
        return Icons.wb_sunny_rounded;
      case 'emoji_events':
        return AppIcons.award;
      default:
        return AppIcons.star;
    }
  }
}