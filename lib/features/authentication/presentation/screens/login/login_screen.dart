import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../../../router.dart';
import '../../providers/auth_providers.dart';
import '../../states/auth_state.dart';
import '../../widgets/auth_form_field.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/auth_primary_button.dart';
import '../../widgets/password_field.dart';
import '../../widgets/auth_social_buttons.dart';
import '../../widgets/auth_divider.dart';
import '../../constants/auth_strings.dart';
import '../../validators/auth_validators.dart';

/// Email + password login screen.
///
/// All business logic lives in [AuthController] (Riverpod). The
/// widget just renders the form, dispatches actions, and reacts to
/// state changes.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFormChanged);
    _passwordController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _submit() {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return Future<void>.value();
    }
    FocusScope.of(context).unfocus();
    return ref.read(authStateProvider.notifier).signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
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
        case AuthStatus.profileIncomplete:
          context.go(AppRoutes.completeProfile);
        case AuthStatus.emailVerificationRequired:
          context.go(AppRoutes.emailVerification);
        case AuthStatus.authenticated:
          context.go(AppRoutes.playground);
        case AuthStatus.unknown:
        case AuthStatus.unauthenticated:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authStateProvider, _onAuthStateChanged);
    final AuthState state = ref.watch(authStateProvider);
    final bool canSubmit = _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty;

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
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const AuthHeader(
                          title: AuthStrings.loginTitle,
                          subtitle: AuthStrings.loginSubtitle,
                          icon: Icons.lock_open_rounded,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AuthFormField(
                          label: AuthStrings.loginEmailLabel,
                          controller: _emailController,
                          hintText: AuthStrings.loginEmailHint,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.alternate_email_rounded,
                          validator: AuthFormValidators.email,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AuthPasswordField(
                          label: AuthStrings.loginPasswordLabel,
                          controller: _passwordController,
                          hintText: AuthStrings.loginPasswordHint,
                          validator: AuthFormValidators.password,
                          onSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: CheckboxListTile(
                                value: _rememberMe,
                                onChanged: (bool? value) {
                                  if (value == null) return;
                                  setState(() => _rememberMe = value);
                                },
                                title: Text(
                                  AuthStrings.loginRememberMe,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go(AppRoutes.forgotPassword),
                              child: Text(
                                AuthStrings.loginForgotPassword,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AuthPrimaryButton(
                          label: AuthStrings.loginPrimaryCta,
                          onPressed:
                              state.isWorking || !canSubmit ? null : _submit,
                          isLoading: state.isWorking,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const AuthDivider(),
                        const SizedBox(height: AppSpacing.lg),
                        AuthSocialButtons(
                          children: <Widget>[
                            AuthSocialButton(
                              label: AuthStrings.loginUsePhone,
                              icon: Icons.phone_iphone_rounded,
                              onPressed: () => context.go(AppRoutes.phoneOtp),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              AuthStrings.loginNoAccount,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => context.go(AppRoutes.register),
                              child: Text(
                                AuthStrings.loginCreateAccount,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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