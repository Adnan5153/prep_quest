import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../../../router.dart';
import '../../providers/auth_providers.dart';
import '../../states/auth_state.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/auth_primary_button.dart';
import '../../widgets/otp_input_field.dart';
import '../../widgets/phone_text_field.dart';
import '../../widgets/resend_timer.dart';
import '../../constants/auth_strings.dart';
import '../../validators/auth_validators.dart';

/// Phone-OTP screen.
///
/// Two phases:
/// 1. The user enters their phone number and taps "Send code" — the
///    screen records the [OtpRequestEntity] in [AuthState].
/// 2. The OTP pad appears, the user enters the code, and the
///    controller verifies it.
class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  String _code = '';
  bool _codeHasError = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return Future<void>.value();
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _code = '';
      _codeHasError = false;
    });
    return ref
        .read(authStateProvider.notifier)
        .sendPhoneOtp(phoneNumber: _phoneController.text.trim());
  }

  Future<void> _verifyCode() {
    final AuthState state = ref.read(authStateProvider);
    final String verificationId = state.pendingPhoneOtp?.verificationId ?? '';
    if (verificationId.isEmpty) {
      AppSnackBar.showError(
        context,
        'Please request a verification code first.',
      );
      return Future<void>.value();
    }
    if (_code.length < 6) {
      setState(() => _codeHasError = true);
      return Future<void>.value();
    }
    FocusScope.of(context).unfocus();
    return ref.read(authStateProvider.notifier).verifyPhoneOtp(
          verificationId: verificationId,
          otp: _code,
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
      if (previous?.pendingPhoneOtp != null) {
        setState(() => _codeHasError = true);
      }
    }
    if (previous?.status != next.status) {
      switch (next.status) {
        case AuthStatus.profileIncomplete:
          context.go(AppRoutes.completeProfile);
        case AuthStatus.authenticated:
          context.go(AppRoutes.playground);
        case AuthStatus.unknown:
        case AuthStatus.unauthenticated:
        case AuthStatus.emailVerificationRequired:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authStateProvider, _onAuthStateChanged);
    final AuthState state = ref.watch(authStateProvider);
    final bool awaitingCode = state.pendingPhoneOtp != null;

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
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        AuthHeader(
                          title: AuthStrings.phoneOtpTitle,
                          subtitle: awaitingCode
                              ? AuthStrings.phoneOtpSubtitle
                              : AuthStrings.phoneOtpSubtitle,
                          icon: Icons.sms_rounded,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        PhoneTextField(
                          controller: _phoneController,
                          label: 'Phone number',
                          hintText: AuthStrings.phoneOtpChangeNumber,
                          validator: AuthFormValidators.phone,
                          enabled: !awaitingCode,
                        ),
                        if (awaitingCode) ...<Widget>[
                          const SizedBox(height: AppSpacing.xl),
                          OtpInputField(
                            length: 6,
                            hasError: _codeHasError,
                            onChanged: (String value) {
                              setState(() {
                                _code = value;
                                _codeHasError = false;
                              });
                            },
                            onCompleted: () {
                              _verifyCode();
                            },
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xl),
                        if (awaitingCode) ...<Widget>[
                          AuthPrimaryButton(
                            label: AuthStrings.phoneOtpPrimaryCta,
                            onPressed: state.isWorking ||
                                    _code.length != 6
                                ? null
                                : _verifyCode,
                            isLoading: state.isWorking,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextButton.icon(
                                onPressed: () {
                                  ref
                                      .read(authStateProvider.notifier)
                                      .clearMessages();
                                  setState(() {
                                    _code = '';
                                    _codeHasError = false;
                                  });
                                  context.go(AppRoutes.phoneOtp);
                                },
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text(
                                    AuthStrings.phoneOtpChangeNumber),
                              ),
                              ResendTimer(
                                duration: const Duration(seconds: 30),
                                onResend: _sendCode,
                              ),
                            ],
                          ),
                        ] else ...<Widget>[
                          AuthPrimaryButton(
                            label: 'Send verification code',
                            onPressed: state.isWorking ? null : _sendCode,
                            isLoading: state.isWorking,
                            icon: Icons.send_rounded,
                          ),
                        ],
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