import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../controllers/auth_controller.dart';
import '../../providers/auth_providers.dart';
import '../../constants/auth_strings.dart';

/// Welcome / landing screen — the single entry point for unauthenticated
/// users. The whole flow collapses to one action: tap "Continue with
/// Google" and let [AuthController.signInWithGoogle] decide whether the
/// visitor is a brand-new user (route to /complete-profile) or a
/// returning user with a completed profile (route straight to the main
/// app).
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _isWorking = false;

  Future<void> _signInWithGoogle() async {
    if (_isWorking) return;
    setState(() => _isWorking = true);
    final AuthController controller =
        ref.read(authStateProvider.notifier);
    try {
      await controller.signInWithGoogle();
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isWide = constraints.maxWidth >= AppSizes.tabletMaxWidth;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? AppSpacing.huge : AppSpacing.xl,
                vertical: AppSpacing.xl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: AppSpacing.huge),
                      Center(
                        child: Container(
                          width: AppSizes.iconXl * 2,
                          height: AppSizes.iconXl * 2,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: <Color>[
                                AppColors.primary,
                                Color(0xFF16A085),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppRadius.xl),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color:
                                    AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 56,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(
                        AuthStrings.welcomeTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        AuthStrings.welcomeSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      const _FeatureHighlights(),
                      const SizedBox(height: AppSpacing.huge),
                      PrimaryButton(
                        text: AuthStrings.welcomePrimaryCta,
                        onPressed: _isWorking ? null : _signInWithGoogle,
                        fullWidth: true,
                        variant: PrimaryButtonVariant.gradient,
                        size: PrimaryButtonSize.large,
                        shape: PrimaryButtonShape.pill,
                        icon: Icons.g_mobiledata_rounded,
                        isLoading: _isWorking,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        AppStrings.appTagline,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureHighlights extends StatelessWidget {
  const _FeatureHighlights();

  @override
  Widget build(BuildContext context) {
    final List<_Feature> features = <_Feature>[
      const _Feature(
        icon: Icons.menu_book_rounded,
        title: 'Guidebook learning',
        description: 'Bangla-first chapters crafted for BCS, Bank, and Primary.',
      ),
      const _Feature(
        icon: Icons.quiz_rounded,
        title: 'Daily quizzes & streaks',
        description: 'Build a learning habit with daily challenges and XP.',
      ),
      const _Feature(
        icon: Icons.auto_awesome_rounded,
        title: 'AI tutor on demand',
        description: 'Ask follow-up questions and get instant explanations.',
      ),
    ];
    return Column(
      children: <Widget>[
        for (final _Feature feature in features) ...<Widget>[
          _FeatureTile(feature: feature),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _Feature {
  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.feature});

  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(feature.icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  feature.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  feature.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}