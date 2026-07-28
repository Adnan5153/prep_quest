import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../../../router.dart';
import '../../../../../shared/enums/exam_track.dart';
import '../../providers/auth_providers.dart';
import '../../states/auth_state.dart';
import '../../widgets/auth_form_field.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/auth_primary_button.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/phone_text_field.dart';
import '../../constants/auth_strings.dart';
import '../../validators/auth_validators.dart';

/// Profile-completion screen.
///
/// Lets the user set a display name, pick an exam track, and add
/// optional district / phone details before entering the main app.
class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends ConsumerState<CompleteProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _districtController;
  late final TextEditingController _phoneController;
  ExamTrack _examTrack = ExamTrack.bcs;

  @override
  void initState() {
    super.initState();
    final AuthState state = ref.read(authStateProvider);
    final String initialName = state.user?.displayName ?? '';
    final String initialDistrict = state.user?.district ?? '';
    final String initialPhone = state.user?.phoneNumber ?? '';
    final ExamTrack initialTrack = state.user?.examTrack ?? ExamTrack.bcs;
    _nameController = TextEditingController(text: initialName);
    _districtController = TextEditingController(text: initialDistrict);
    _phoneController = TextEditingController(text: initialPhone);
    _examTrack = initialTrack == ExamTrack.other ? ExamTrack.bcs : initialTrack;
    for (final TextEditingController c in <TextEditingController>[
      _nameController,
      _districtController,
      _phoneController,
    ]) {
      c.addListener(_onFormChanged);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _districtController.dispose();
    _phoneController.dispose();
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
    return ref.read(authStateProvider.notifier).updateProfile(
          displayName: _nameController.text.trim(),
          examTrack: _examTrack,
          district: _districtController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
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
        case AuthStatus.authenticated:
        case AuthStatus.emailVerificationRequired:
          context.go(AppRoutes.playground);
        case AuthStatus.profileIncomplete:
          break;
        case AuthStatus.unknown:
        case AuthStatus.unauthenticated:
          context.go(AppRoutes.welcome);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authStateProvider, _onAuthStateChanged);
    final AuthState state = ref.watch(authStateProvider);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const AuthHeader(
                          title: AuthStrings.completeProfileTitle,
                          subtitle: AuthStrings.completeProfileSubtitle,
                          icon: Icons.assignment_ind_rounded,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AuthFormField(
                          label: AuthStrings.completeProfileNameLabel,
                          controller: _nameController,
                          hintText: AuthStrings.completeProfileNameHint,
                          prefixIcon: Icons.person_outline_rounded,
                          textInputAction: TextInputAction.next,
                          validator: AuthFormValidators.displayName,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          AuthStrings.completeProfileExamTrackLabel,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: <Widget>[
                            for (final ExamTrack track
                                in <ExamTrack>[ExamTrack.bcs, ExamTrack.bank, ExamTrack.primaryTeacher])
                              CategoryChip(
                                label: track.displayName,
                                selected: _examTrack == track,
                                onTap: () =>
                                    setState(() => _examTrack = track),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AuthFormField(
                          label: AuthStrings.completeProfileDistrictLabel,
                          controller: _districtController,
                          hintText: AuthStrings.completeProfileDistrictHint,
                          prefixIcon: Icons.location_city_rounded,
                          textInputAction: TextInputAction.next,
                          validator: AuthFormValidators.district,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        PhoneTextField(
                          controller: _phoneController,
                          label: AuthStrings.completeProfilePhoneLabel,
                          hintText: AuthStrings.completeProfilePhoneHint,
                          validator: AuthFormValidators.phone,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        AuthPrimaryButton(
                          label: AuthStrings.completeProfilePrimaryCta,
                          onPressed: state.isWorking ? null : _submit,
                          isLoading: state.isWorking,
                          icon: Icons.rocket_launch_rounded,
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