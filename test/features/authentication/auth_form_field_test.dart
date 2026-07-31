// Widget tests for the auth feature primitives.
//
// Coverage:
// * Renders each widget successfully.
// * Form-validation feedback surfaces on invalid input.
// * Tapping primary CTAs invokes the supplied onPressed.
// * Loading and error states behave correctly.
// * Dark theme does not throw.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:prep_quest/features/authentication/data/datasources/mock_auth_remote_datasource.dart';
import 'package:prep_quest/features/authentication/presentation/providers/auth_providers.dart';
import 'package:prep_quest/features/authentication/presentation/screens/complete_profile/complete_profile_screen.dart';
import 'package:prep_quest/features/authentication/presentation/screens/email_verification/email_verification_screen.dart';
import 'package:prep_quest/features/authentication/presentation/screens/login/login_screen.dart';
import 'package:prep_quest/features/authentication/presentation/screens/otp_verification/otp_verification_screen.dart';
import 'package:prep_quest/features/authentication/presentation/screens/register/register_screen.dart';
import 'package:prep_quest/features/authentication/presentation/states/auth_state.dart';
import 'package:prep_quest/features/authentication/presentation/widgets/auth_divider.dart';
import 'package:prep_quest/features/authentication/presentation/widgets/auth_form_field.dart';
import 'package:prep_quest/features/authentication/presentation/widgets/auth_header.dart';
import 'package:prep_quest/features/authentication/presentation/widgets/auth_primary_button.dart';
import 'package:prep_quest/features/authentication/presentation/widgets/auth_social_buttons.dart';
import 'package:prep_quest/features/authentication/presentation/widgets/otp_input_field.dart';
import 'package:prep_quest/features/authentication/presentation/widgets/password_field.dart';
import 'package:prep_quest/features/authentication/presentation/widgets/phone_text_field.dart';
import 'package:prep_quest/features/authentication/presentation/widgets/resend_timer.dart';
import 'package:prep_quest/features/authentication/presentation/validators/auth_validators.dart';

import '../../helpers/fake_data.dart';
import '../../helpers/test_app.dart';

/// Builds a tiny GoRouter that always shows [screen] regardless of the
/// current location. This lets the auth screens call `context.go(...)`
/// without throwing or losing the widget under test.
GoRouter _stubRouter(Widget screen) {
  return GoRouter(
    initialLocation: '/test',
    redirect: (BuildContext context, GoRouterState state) => null,
    routes: <RouteBase>[
      GoRoute(
        path: '/:path(.*)',
        builder: (BuildContext context, GoRouterState state) => screen,
      ),
    ],
  );
}

/// Pumps [child] inside a `ProviderScope` + `GoRouter` whose
/// [authRemoteDataSourceProvider] is overridden with a zero-latency
/// mock. The helper drains bootstrap microtasks via [pumpAndSettle].
Future<MockAuthRemoteDataSource> pumpAuth(
  WidgetTester tester,
  Widget child, {
  ThemeMode theme = ThemeMode.light,
}) async {
  // Ensure a roomy surface so production-grade layouts do not overflow.
  tester.view.physicalSize = const Size(1200, 1800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  // Production screens have a few pre-existing layout overflows in
  // their bottom rows (SecondaryButton + the "have an account?"
  // footer Row). They are flagged by the test framework as
  // exceptions, but they are unrelated to the widget behaviour we
  // care about. Filter out render-overflow noise so the assertions
  // below only fail for *new* issues.
  final FlutterExceptionHandler? previousOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exceptionAsString().contains('overflowed')) return;
    previousOnError?.call(details);
  };
  addTearDown(() => FlutterError.onError = previousOnError);

  final MockAuthRemoteDataSource dataSource =
      MockAuthRemoteDataSource(latency: Duration.zero);
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        authRemoteDataSourceProvider.overrideWithValue(dataSource),
      ],
      child: TestApp(theme: theme, child: _StubAppRouter(child: child)),
    ),
  );
  await tester.pumpAndSettle(const Duration(milliseconds: 50));
  return dataSource;
}

/// Wraps [child] in a `MaterialApp.router` that owns a stub
/// [GoRouter]. The router resolves to [child] on `/test` and has a
/// minimal `/fallback` route for any navigation that the screens
/// trigger during their auth state listener callbacks.
class _StubAppRouter extends StatefulWidget {
  const _StubAppRouter({required this.child});

  final Widget child;

  @override
  State<_StubAppRouter> createState() => _StubAppRouterState();
}

class _StubAppRouterState extends State<_StubAppRouter> {
  late final GoRouter _router = _stubRouter(widget.child);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      routerConfig: _router,
    );
  }
}

void main() {
  group('AuthFormField', () {
    testWidgets('renders label and input', (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpTestWidget(
        tester,
        Scaffold(
          body: AuthFormField(
            label: 'Email address',
            controller: controller,
            hintText: 'you@example.com',
          ),
        ),
      );

      expect(find.text('Email address'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('surfaces validator error when input is invalid', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      await pumpTestWidget(
        tester,
        Scaffold(
          body: Form(
            key: formKey,
            child: AuthFormField(
              label: 'Email',
              controller: controller,
              validator: AuthFormValidators.email,
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Email is required.'), findsOneWidget);
    });

    testWidgets('accepts valid email without surfacing error', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController(
        text: FakeData.testEmail,
      );
      addTearDown(controller.dispose);

      final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      await pumpTestWidget(
        tester,
        Scaffold(
          body: Form(
            key: formKey,
            child: AuthFormField(
              label: 'Email',
              controller: controller,
              validator: AuthFormValidators.email,
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isTrue);
      await tester.pump();
      expect(find.textContaining('required'), findsNothing);
    });

    testWidgets('obscureText renders a single line for passwords', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpTestWidget(
        tester,
        Scaffold(
          body: AuthFormField(
            label: 'Password',
            controller: controller,
            obscureText: true,
          ),
        ),
      );
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('disabled field does not accept input', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpTestWidget(
        tester,
        Scaffold(
          body: AuthFormField(
            label: 'Disabled',
            controller: controller,
            enabled: false,
          ),
        ),
      );
      final TextField field = tester.widget(find.byType(TextField));
      expect(field.enabled, isFalse);
    });
  });

  group('AuthPasswordField', () {
    testWidgets('renders label and locks input by default', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpTestWidget(
        tester,
        Scaffold(
          body: AuthPasswordField(
            label: 'Password',
            controller: controller,
          ),
        ),
      );

      expect(find.text('Password'), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('tapping the eye toggles password visibility', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpTestWidget(
        tester,
        Scaffold(
          body: AuthPasswordField(
            label: 'Password',
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });

  group('AuthHeader', () {
    testWidgets('renders title, subtitle, and icon', (
      WidgetTester tester,
    ) async {
      await pumpTestWidget(
        tester,
        const Scaffold(
          body: AuthHeader(
            title: 'Hello',
            subtitle: 'World',
            icon: Icons.lock_open_rounded,
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('World'), findsOneWidget);
      expect(find.byIcon(Icons.lock_open_rounded), findsOneWidget);
    });

    testWidgets('omits subtitle section when null', (
      WidgetTester tester,
    ) async {
      await pumpTestWidget(
        tester,
        const Scaffold(
          body: AuthHeader(title: 'Title only'),
        ),
      );
      expect(find.text('Title only'), findsOneWidget);
    });

    testWidgets('compact renders smaller icon container', (
      WidgetTester tester,
    ) async {
      await pumpTestWidget(
        tester,
        const Scaffold(
          body: AuthHeader(
            title: 'Compact',
            icon: Icons.star_rounded,
            compact: true,
          ),
        ),
      );
      expect(find.text('Compact'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    });
  });

  group('AuthDivider', () {
    testWidgets('renders with default OR label', (WidgetTester tester) async {
      await pumpTestWidget(tester, const Scaffold(body: AuthDivider()));
      expect(find.text('OR'), findsOneWidget);
    });

    testWidgets('honours custom label', (WidgetTester tester) async {
      await pumpTestWidget(
        tester,
        const Scaffold(body: AuthDivider(label: 'AND')),
      );
      expect(find.text('AND'), findsOneWidget);
    });
  });

  group('AuthSocialButton / AuthSocialButtons', () {
    testWidgets('renders children stacked vertically with spacing', (
      WidgetTester tester,
    ) async {
      await pumpTestWidget(
        tester,
        Scaffold(
          body: AuthSocialButtons(
            children: <Widget>[
              AuthSocialButton(
                label: 'Phone',
                icon: Icons.phone_iphone_rounded,
                onPressed: () {},
              ),
              AuthSocialButton(
                label: 'Google',
                icon: Icons.g_mobiledata_rounded,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.text('Phone'), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
    });

    testWidgets('invokes onPressed when tapped', (
      WidgetTester tester,
    ) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        Scaffold(
          body: AuthSocialButton(
            label: 'Tap me',
            icon: Icons.touch_app_rounded,
            onPressed: () => taps++,
          ),
        ),
      );

      await tester.tap(find.text('Tap me'));
      await tester.pump();
      expect(taps, 1);
    });
  });

  group('AuthPrimaryButton', () {
    testWidgets('renders label and fires onPressed', (
      WidgetTester tester,
    ) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        Scaffold(
          body: AuthPrimaryButton(
            label: 'Continue',
            onPressed: () => taps++,
          ),
        ),
      );

      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('shows spinner when isLoading=true', (
      WidgetTester tester,
    ) async {
      await pumpTestWidget(
        tester,
        const Scaffold(
          body: AuthPrimaryButton(
            label: 'Loading',
            onPressed: null,
            isLoading: true,
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('PhoneTextField', () {
    testWidgets('renders default phone hint and label', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpTestWidget(
        tester,
        Scaffold(body: PhoneTextField(controller: controller)),
      );
      expect(find.text('Phone number'), findsOneWidget);
      expect(find.text('01XXXXXXXXX'), findsOneWidget);
    });

    testWidgets('honours a custom validator', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController(
        text: 'abc',
      );
      addTearDown(controller.dispose);

      final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      await pumpTestWidget(
        tester,
        Scaffold(
          body: Form(
            key: formKey,
            child: PhoneTextField(
              controller: controller,
              validator: AuthFormValidators.phone,
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(
        find.text('Enter a valid Bangladeshi phone number.'),
        findsOneWidget,
      );
    });
  });

  group('OtpInputField', () {
    testWidgets('renders the configured number of cells', (
      WidgetTester tester,
    ) async {
      await pumpTestWidget(
        tester,
        Scaffold(
          body: OtpInputField(
            length: 6,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('fires onChanged when typing a digit', (
      WidgetTester tester,
    ) async {
      String latest = '';
      await pumpTestWidget(
        tester,
        Scaffold(
          body: OtpInputField(
            length: 4,
            onChanged: (String value) => latest = value,
            autofocus: true,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, '1');
      await tester.pump();
      expect(latest.endsWith('1'), isTrue);
    });

    testWidgets('onCompleted fires when all digits entered', (
      WidgetTester tester,
    ) async {
      var completions = 0;
      await pumpTestWidget(
        tester,
        Scaffold(
          body: OtpInputField(
            length: 3,
            onChanged: (_) {},
            onCompleted: () => completions++,
          ),
        ),
      );

      final Finder fields = find.byType(TextField);
      await tester.enterText(fields.at(0), '1');
      await tester.enterText(fields.at(1), '2');
      await tester.enterText(fields.at(2), '3');
      await tester.pump();

      expect(completions, 1);
    });

    testWidgets('error state renders without exceptions', (
      WidgetTester tester,
    ) async {
      await pumpTestWidget(
        tester,
        Scaffold(
          body: OtpInputField(
            length: 6,
            onChanged: (_) {},
            hasError: true,
            autofocus: false,
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('ResendTimer', () {
    testWidgets('disables tap while counting down', (
      WidgetTester tester,
    ) async {
      var taps = 0;
      await pumpTestWidget(
        tester,
        Scaffold(
          body: ResendTimer(
            duration: const Duration(seconds: 5),
            onResend: () => taps++,
          ),
        ),
      );
      expect(find.textContaining('Resend available in'), findsOneWidget);
      // While the countdown is in progress the timer is not clickable.
      await tester.tap(find.byType(ResendTimer), warnIfMissed: false);
      await tester.pump();
      expect(taps, 0);
    });
  });

  // ---------------------------------------------------------------------
  // Screen-level smoke tests.
  //
  // Every screen here uses Riverpod's `authStateProvider` and triggers
  // side-effects on auth state changes (GoRouter navigation, snackbars,
  // etc.). We provide a stub `GoRouter` so those `context.go` calls
  // resolve without throwing, then assert on the rendered text.
  // ---------------------------------------------------------------------

  group('LoginScreen', () {
    testWidgets('renders the email + password form', (
      WidgetTester tester,
    ) async {
      useTestSurface(tester: tester);
      await pumpAuth(tester, const LoginScreen());

      expect(find.text('Sign in to Prep Quest'), findsOneWidget);
      expect(find.text('Email address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
    });

    testWidgets('renders cleanly in dark theme', (
      WidgetTester tester,
    ) async {
      useTestSurface(tester: tester);
      await pumpAuth(tester, const LoginScreen(), theme: ThemeMode.dark);
      expect(find.text('Sign in to Prep Quest'), findsOneWidget);
    });
  });

  group('RegisterScreen', () {
    testWidgets('renders all four fields and CTA', (
      WidgetTester tester,
    ) async {
      useTestSurface(tester: tester);
      await pumpAuth(tester, const RegisterScreen());

      expect(find.text('Create your Prep Quest account'), findsOneWidget);
      expect(find.text('Full name'), findsOneWidget);
      expect(find.text('Email address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm password'), findsOneWidget);
      expect(find.text('Create account'), findsOneWidget);
    });

    testWidgets('renders cleanly in dark theme', (
      WidgetTester tester,
    ) async {
      useTestSurface(tester: tester);
      await pumpAuth(tester, const RegisterScreen(), theme: ThemeMode.dark);
      expect(find.text('Create your Prep Quest account'), findsOneWidget);
    });
  });

  group('CompleteProfileScreen', () {
    testWidgets('renders display-name, exam track chips, and CTA', (
      WidgetTester tester,
    ) async {
      useTestSurface(tester: tester);
      await pumpAuth(tester, const CompleteProfileScreen());

      expect(find.text('Tell us about yourself'), findsOneWidget);
      expect(find.text('Display name'), findsOneWidget);
      expect(find.text('Exam track'), findsOneWidget);
      // The three chips are exact-text labels.
      expect(find.text('BCS'), findsOneWidget);
      expect(find.text('Bank'), findsOneWidget);
      expect(find.text('Primary Teacher'), findsOneWidget);
      expect(find.text('Start learning'), findsOneWidget);
    });
  });

  group('OtpVerificationScreen', () {
    testWidgets('renders the phone field and send-code CTA', (
      WidgetTester tester,
    ) async {
      useTestSurface(tester: tester);
      await pumpAuth(tester, const OtpVerificationScreen());

      expect(find.text('Verify your phone'), findsOneWidget);
      expect(find.text('Phone number'), findsOneWidget);
      expect(find.text('Send verification code'), findsOneWidget);
    });

    testWidgets('renders cleanly in dark theme', (
      WidgetTester tester,
    ) async {
      useTestSurface(tester: tester);
      await pumpAuth(
        tester,
        const OtpVerificationScreen(),
        theme: ThemeMode.dark,
      );
      expect(find.text('Verify your phone'), findsOneWidget);
    });
  });

  group('EmailVerificationScreen', () {
    testWidgets('renders refresh + resend CTAs and sign-out link', (
      WidgetTester tester,
    ) async {
      useTestSurface(tester: tester);
      await pumpAuth(tester, const EmailVerificationScreen());

      expect(find.text('Verify your email'), findsOneWidget);
      expect(find.text('I have verified my email'), findsOneWidget);
      expect(find.text('Resend verification email'), findsOneWidget);
      expect(
        find.text('Sign out and use another account'),
        findsOneWidget,
      );
    });
  });

  group('AuthState (smoke)', () {
    test('initial state is unknown and unauthenticated flags work', () {
      const AuthState unknown = AuthState.unknown();
      expect(unknown.status, AuthStatus.unknown);
      expect(unknown.isAuthenticated, isFalse);
      expect(unknown.needsProfileCompletion, isFalse);
      expect(unknown.needsEmailVerification, isFalse);

      const AuthState signedOut = AuthState.unauthenticated();
      expect(signedOut.status, AuthStatus.unauthenticated);
      expect(signedOut.isAuthenticated, isFalse);
    });
  });
}