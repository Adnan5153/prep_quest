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
import '../../constants/auth_strings.dart';
import '../../validators/auth_validators.dart';

/// Email + password registration screen.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    for (final TextEditingController c in <TextEditingController>[
      _nameController,
      _emailController,
      _passwordController,
      _confirmController,
    ]) {
      c.addListener(_onFormChanged);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
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
    if (!_acceptedTerms) {
      AppSnackBar.showWarning(
        context,
        'Please accept the Terms of Service to continue.',
      );
      return Future<void>.value();
    }
    FocusScope.of(context).unfocus();
    return ref.read(authStateProvider.notifier).registerWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
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
        case AuthStatus.emailVerificationRequired:
          context.go(AppRoutes.emailVerification);
        case AuthStatus.profileIncomplete:
          context.go(AppRoutes.completeProfile);
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
    final bool canSubmit = _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmController.text.isNotEmpty &&
        _acceptedTerms;

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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const AuthHeader(
                          title: AuthStrings.registerTitle,
                          subtitle: AuthStrings.registerSubtitle,
                          icon: Icons.person_add_alt_rounded,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AuthFormField(
                          label: AuthStrings.registerNameLabel,
                          controller: _nameController,
                          hintText: AuthStrings.registerNameHint,
                          prefixIcon: Icons.person_outline_rounded,
                          textInputAction: TextInputAction.next,
                          validator: AuthFormValidators.displayName,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AuthFormField(
                          label: AuthStrings.registerEmailLabel,
                          controller: _emailController,
                          hintText: AuthStrings.registerEmailHint,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.alternate_email_rounded,
                          textInputAction: TextInputAction.next,
                          validator: AuthFormValidators.email,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AuthPasswordField(
                          label: AuthStrings.registerPasswordLabel,
                          controller: _passwordController,
                          hintText: AuthStrings.registerPasswordHint,
                          validator: AuthFormValidators.password,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AuthPasswordField(
                          label: AuthStrings.registerConfirmPasswordLabel,
                          controller: _confirmController,
                          hintText: AuthStrings.registerConfirmPasswordHint,
                          textInputAction: TextInputAction.done,
                          validator: (String? value) =>
                              AuthFormValidators.confirmPassword(
                            value,
                            _passwordController.text,
                          ),
                          onSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        CheckboxListTile(
                          value: _acceptedTerms,
                          onChanged: (bool? value) {
                            if (value == null) return;
                            setState(() => _acceptedTerms = value);
                          },
                          title: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall,
                              children: <InlineSpan>[
                                const TextSpan(
                                    text: '${AuthStrings.registerTermsPrefix} '),
                                TextSpan(
                                  text: AuthStrings.registerTermsLink,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const TextSpan(text: ' & '),
                                TextSpan(
                                  text: AuthStrings.registerPrivacyLink,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AuthPrimaryButton(
                          label: AuthStrings.registerPrimaryCta,
                          onPressed:
                              state.isWorking || !canSubmit ? null : _submit,
                          isLoading: state.isWorking,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              AuthStrings.registerHaveAccount,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => context.go(AppRoutes.login),
                              child: Text(
                                AuthStrings.registerSecondaryCta,
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