import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/fullscreen_loader.dart';
import '../../../../../router.dart';
import '../../providers/auth_providers.dart';
import '../../states/auth_state.dart';
import '../../constants/auth_strings.dart';

/// Splash screen — boots the app and decides where to route the
/// user based on the auth state discovered by [AuthController].
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasRouted = false;

  void _maybeRoute(AuthState state) {
    if (_hasRouted) return;
    if (state.status == AuthStatus.unknown) return;
    _hasRouted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      switch (state.status) {
        case AuthStatus.unknown:
          return;
        case AuthStatus.unauthenticated:
          context.go(AppRoutes.welcome);
        case AuthStatus.profileIncomplete:
          context.go(AppRoutes.completeProfile);
        case AuthStatus.emailVerificationRequired:
          // Google sign-in always returns a verified email, so this
          // branch is unreachable in practice. Treat it the same as
          // profile-incomplete since the email-verification screen
          // has been removed.
          context.go(AppRoutes.completeProfile);
        case AuthStatus.authenticated:
          context.go(AppRoutes.playground);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authStateProvider, (_, AuthState next) {
      _maybeRoute(next);
    });

    final AuthState state = ref.watch(authStateProvider);
    _maybeRoute(state);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              AppColors.primary,
              Color(0xFF16A085),
              AppColors.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxl,
                  vertical: AppSpacing.xxxl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _SplashBrand(),
                    const SizedBox(height: AppSpacing.huge),
                    Text(
                      AuthStrings.splashTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      AuthStrings.splashSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                    ),
                    const SizedBox(height: AppSpacing.huge),
                    const Center(child: _LoadingPulse()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: AppSizes.iconXl * 2,
          height: AppSizes.iconXl * 2,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: const Center(
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 56,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          AppStrings.appName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppStrings.appTagline,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
        ),
      ],
    );
  }
}

class _LoadingPulse extends StatefulWidget {
  const _LoadingPulse();

  @override
  State<_LoadingPulse> createState() => _LoadingPulseState();
}

class _LoadingPulseState extends State<_LoadingPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? _) {
        return Container(
          width: 56 + 18 * _controller.value,
          height: 56 + 18 * _controller.value,
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.10 + 0.10 * _controller.value,
            ),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      },
    );
  }
}

/// Convenience hook used in tests and the rest of the splash plumbing
/// when callers need to show the global loader overlay.
typedef SplashLoader = FullscreenLoader;