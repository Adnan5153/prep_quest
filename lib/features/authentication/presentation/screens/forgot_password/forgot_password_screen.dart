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
import '../../constants/auth_strings.dart';
import '../../validators/auth_validators.dart';

/// Forgot-password screen — sends a reset email via the repository.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _completed = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return Future<void>.value();
    }
    FocusScope.of(context).unfocus();
    return ref
        .read(authStateProvider.notifier)
        .sendPasswordReset(email: _emailController.text.trim())
        .then((_) {
      if (mounted) setState(() => _completed = true);
    });
  }

  void _onAuthStateChanged(AuthState? previous, AuthState next) {
    if (!mounted) return;
    if (next.errorMessage != null &&
        next.errorMessage != previous?.errorMessage) {
      AppSnackBar.showError(context, next.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authStateProvider, _onAuthStateChanged);
    final AuthState state = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppRoutes.login),
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
                  child: _completed ? _buildSuccessView() : _buildForm(state),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(AuthState state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AuthHeader(
            title: AuthStrings.forgotPasswordTitle,
            subtitle: AuthStrings.forgotPasswordSubtitle,
            icon: Icons.lock_reset_rounded,
          ),
          const SizedBox(height: AppSpacing.xl),
          AuthFormField(
            label: AuthStrings.forgotPasswordEmailLabel,
            controller: _emailController,
            hintText: AuthStrings.loginEmailHint,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            prefixIcon: Icons.alternate_email_rounded,
            validator: AuthFormValidators.email,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.xl),
          AuthPrimaryButton(
            label: AuthStrings.forgotPasswordPrimaryCta,
            onPressed: state.isWorking ? null : _submit,
            isLoading: state.isWorking,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            child: Text(
              AuthStrings.forgotPasswordSecondaryCta,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.huge),
        Container(
          alignment: Alignment.center,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_read_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          AuthStrings.forgotPasswordSuccessTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AuthStrings.forgotPasswordSuccessMessage,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        AuthPrimaryButton(
          label: AuthStrings.forgotPasswordSuccessCta,
          onPressed: () => context.go(AppRoutes.login),
          icon: Icons.arrow_forward_rounded,
        ),
      ],
    );
  }
}