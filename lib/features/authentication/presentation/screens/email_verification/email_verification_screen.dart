import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../../../core/widgets/secondary_button.dart';
import '../../../../../router.dart';
import '../../providers/auth_providers.dart';
import '../../states/auth_state.dart';
import '../../widgets/auth_primary_button.dart';
import '../../constants/auth_strings.dart';

/// Email verification screen.
///
/// Surfaces the user's email and offers two actions:
/// 1. **Refresh** — poll the repository for the latest verification
///    state.
/// 2. **Resend** — issue a fresh verification email.
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  bool _autoPolling = false;

  @override
  void initState() {
    super.initState();
    _autoPolling = true;
  }

  @override
  void dispose() {
    _autoPolling = false;
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref.read(authStateProvider.notifier).reloadCurrentUser();
  }

  Future<void> _resend() async {
    await ref.read(authStateProvider.notifier).resendEmailVerification();
  }

  Future<void> _signOut() async {
    await ref.read(authStateProvider.notifier).signOut();
  }

  void _onAuthStateChanged(AuthState? previous, AuthState next) {
    if (!mounted) return;
    if (next.lastSuccessMessage != null &&
        next.lastSuccessMessage != previous?.lastSuccessMessage) {
      AppSnackBar.showSuccess(context, next.lastSuccessMessage!);
    }
    if (next.errorMessage != null &&
        next.errorMessage != previous?.errorMessage) {
      AppSnackBar.showError(context, next.errorMessage!);
    }
    if (previous?.status != next.status) {
      switch (next.status) {
        case AuthStatus.authenticated:
        case AuthStatus.profileIncomplete:
          context.go(AppRoutes.completeProfile);
        case AuthStatus.unauthenticated:
          context.go(AppRoutes.welcome);
        case AuthStatus.unknown:
        case AuthStatus.emailVerificationRequired:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authStateProvider, _onAuthStateChanged);
    final AuthState state = ref.watch(authStateProvider);
    final String email = state.user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppRoutes.welcome),
          tooltip: AuthStrings.back,
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isWide =
                constraints.maxWidth >= AppSizes.tabletMaxWidth;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? AppSpacing.huge : AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: AppSpacing.huge),
                      Container(
                        alignment: Alignment.center,
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                          ),
                          child: const Icon(
                            Icons.mark_email_unread_rounded,
                            color: AppColors.accent,
                            size: 48,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        AuthStrings.emailVerificationTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        AuthStrings.emailVerificationSubtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              height: 1.5,
                            ),
                      ),
                      if (email.isNotEmpty) ...<Widget>[
                        const SizedBox(height: AppSpacing.lg),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            border: Border.all(
                              color:
                                  AppColors.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.alternate_email_rounded,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  email,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      if (state.isWorking && _autoPolling) ...<Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              AuthStrings.emailVerificationAwaiting,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      AuthPrimaryButton(
                        label: AuthStrings.emailVerificationRefresh,
                        onPressed: state.isWorking ? null : _refresh,
                        isLoading: state.isWorking && !_autoPolling,
                        icon: Icons.refresh_rounded,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SecondaryButton(
                        text: AuthStrings.emailVerificationResend,
                        onPressed: state.isWorking ? null : _resend,
                        fullWidth: true,
                        size: SecondaryButtonSize.large,
                        shape: SecondaryButtonShape.pill,
                        variant: SecondaryButtonVariant.outlined,
                        icon: Icons.outgoing_mail,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextButton(
                        onPressed: state.isWorking ? null : _signOut,
                        child: Text(
                          AuthStrings.emailVerificationSignOut,
                          style: Theme.of(context).textTheme.labelLarge,
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