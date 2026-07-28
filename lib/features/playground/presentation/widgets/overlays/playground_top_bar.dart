import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';
import 'coin_counter.dart';
import 'energy_indicator.dart';
import 'profile_summary.dart';
import 'streak_card.dart';
import 'xp_indicator.dart';

class PlaygroundTopBar extends StatelessWidget {
  const PlaygroundTopBar({
    super.key,
    required this.profile,
    required this.xp,
    required this.coins,
    required this.energy,
    required this.streak,
    this.onProfileTap,
    this.onXpTap,
    this.onCoinsTap,
    this.onEnergyTap,
    this.onStreakTap,
    this.topPadding,
  });

  final ProfileVisual profile;
  final XpVisual xp;
  final CoinVisual coins;
  final EnergyVisual energy;
  final StreakVisual streak;
  final VoidCallback? onProfileTap;
  final VoidCallback? onXpTap;
  final VoidCallback? onCoinsTap;
  final VoidCallback? onEnergyTap;
  final VoidCallback? onStreakTap;
  final double? topPadding;

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveBuilder.value<double>(
      context,
      mobile: 1.0,
      tablet: PlaygroundSizes.hudTabletScale,
      desktop: PlaygroundSizes.hudDesktopScale,
    );

    return Semantics(
      header: true,
      label: PlaygroundStrings.hudTopBarSemantic,
      container: true,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            top: topPadding ?? AppSpacing.xs,
            left: PlaygroundSizes.hudHorizontalPadding,
            right: PlaygroundSizes.hudHorizontalPadding,
            bottom: PlaygroundSizes.hudVerticalPadding,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1024;
              if (wide) {
                return _WideLayout(
                  scale: scale,
                  profile: profile,
                  xp: xp,
                  coins: coins,
                  energy: energy,
                  streak: streak,
                  onProfileTap: onProfileTap,
                  onXpTap: onXpTap,
                  onCoinsTap: onCoinsTap,
                  onEnergyTap: onEnergyTap,
                  onStreakTap: onStreakTap,
                );
              }
              return _NarrowLayout(
                scale: scale,
                profile: profile,
                xp: xp,
                coins: coins,
                energy: energy,
                streak: streak,
                onProfileTap: onProfileTap,
                onXpTap: onXpTap,
                onCoinsTap: onCoinsTap,
                onEnergyTap: onEnergyTap,
                onStreakTap: onStreakTap,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout({
    required this.scale,
    required this.profile,
    required this.xp,
    required this.coins,
    required this.energy,
    required this.streak,
    required this.onProfileTap,
    required this.onXpTap,
    required this.onCoinsTap,
    required this.onEnergyTap,
    required this.onStreakTap,
  });

  final double scale;
  final ProfileVisual profile;
  final XpVisual xp;
  final CoinVisual coins;
  final EnergyVisual energy;
  final StreakVisual streak;
  final VoidCallback? onProfileTap;
  final VoidCallback? onXpTap;
  final VoidCallback? onCoinsTap;
  final VoidCallback? onEnergyTap;
  final VoidCallback? onStreakTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfileSummary(visual: profile, onTap: onProfileTap),
        Flexible(
          child: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.sm * scale,
            runSpacing: AppSpacing.sm * scale,
            children: [
              XpIndicator(visual: xp, onTap: onXpTap),
              CoinCounter(visual: coins, onTap: onCoinsTap),
              EnergyIndicator(visual: energy, onTap: onEnergyTap),
              StreakCard(visual: streak, onTap: onStreakTap),
            ],
          ),
        ),
      ],
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({
    required this.scale,
    required this.profile,
    required this.xp,
    required this.coins,
    required this.energy,
    required this.streak,
    required this.onProfileTap,
    required this.onXpTap,
    required this.onCoinsTap,
    required this.onEnergyTap,
    required this.onStreakTap,
  });

  final double scale;
  final ProfileVisual profile;
  final XpVisual xp;
  final CoinVisual coins;
  final EnergyVisual energy;
  final StreakVisual streak;
  final VoidCallback? onProfileTap;
  final VoidCallback? onXpTap;
  final VoidCallback? onCoinsTap;
  final VoidCallback? onEnergyTap;
  final VoidCallback? onStreakTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ProfileSummary(visual: profile, onTap: onProfileTap),
            ),
            SizedBox(width: AppSpacing.sm * scale),
            Expanded(
              child: XpIndicator(visual: xp, onTap: onXpTap),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm * scale),
        Row(
          children: [
            Expanded(
              child: CoinCounter(visual: coins, onTap: onCoinsTap),
            ),
            SizedBox(width: AppSpacing.sm * scale),
            Expanded(
              child: EnergyIndicator(visual: energy, onTap: onEnergyTap),
            ),
            SizedBox(width: AppSpacing.sm * scale),
            Expanded(
              child: StreakCard(visual: streak, onTap: onStreakTap),
            ),
          ],
        ),
      ],
    );
  }
}
