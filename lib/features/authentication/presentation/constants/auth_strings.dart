/// User-visible strings scoped to the authentication feature.
///
/// Mirrors the structure of `lib/core/constants/app_strings.dart` but
/// stays inside the feature so the auth screens can be tweaked
/// without touching the global file. Forms must reference these
/// constants instead of writing inline literals.
class AuthStrings {
  const AuthStrings._();

  // Splash
  static const String splashTitle = 'Preparing your quest';
  static const String splashSubtitle =
      'Booting up the smartest way to prepare for BCS, Bank and Primary Teacher exams.';

  // Welcome
  static const String welcomeTitle = 'Welcome to Prep Quest';
  static const String welcomeSubtitle =
      'Your smart BCS prep companion. Learn, practice, and level up your exam journey.';
  static const String welcomePrimaryCta = 'Get started';
  static const String welcomeSecondaryCta = 'I already have an account';
  static const String welcomeContinueAsGuest = 'Continue as guest';

  // Login
  static const String loginTitle = 'Sign in to Prep Quest';
  static const String loginSubtitle =
      'Enter your email and password to continue your learning streak.';
  static const String loginEmailLabel = 'Email address';
  static const String loginEmailHint = 'you@example.com';
  static const String loginPasswordLabel = 'Password';
  static const String loginPasswordHint = 'Enter your password';
  static const String loginRememberMe = 'Remember me';
  static const String loginForgotPassword = 'Forgot password?';
  static const String loginPrimaryCta = 'Sign in';
  static const String loginUsePhone = 'Sign in with phone';
  static const String loginNoAccount = 'New here?';
  static const String loginCreateAccount = 'Create an account';

  // Register
  static const String registerTitle = 'Create your Prep Quest account';
  static const String registerSubtitle =
      'It only takes a minute. We will email you a verification link to confirm it is really you.';
  static const String registerNameLabel = 'Full name';
  static const String registerNameHint = 'Your name as it should appear on your profile';
  static const String registerEmailLabel = 'Email address';
  static const String registerEmailHint = 'you@example.com';
  static const String registerPasswordLabel = 'Password';
  static const String registerPasswordHint = 'At least 8 characters with a letter and a number';
  static const String registerConfirmPasswordLabel = 'Confirm password';
  static const String registerConfirmPasswordHint = 'Re-enter your password';
  static const String registerTermsPrefix = 'By continuing you agree to our';
  static const String registerTermsLink = 'Terms of Service';
  static const String registerPrivacyLink = 'Privacy Policy';
  static const String registerPrimaryCta = 'Create account';
  static const String registerSecondaryCta = 'Sign in instead';
  static const String registerHaveAccount = 'Already have an account?';

  // Forgot password
  static const String forgotPasswordTitle = 'Forgot your password?';
  static const String forgotPasswordSubtitle =
      'Enter the email you used to sign up. We will send a secure link to reset your password.';
  static const String forgotPasswordEmailLabel = 'Email address';
  static const String forgotPasswordPrimaryCta = 'Send reset link';
  static const String forgotPasswordSecondaryCta = 'Back to sign in';
  static const String forgotPasswordSuccessTitle = 'Check your inbox';
  static const String forgotPasswordSuccessMessage =
      'We sent a password-reset link to your email. Open it on this device to finish the reset.';
  static const String forgotPasswordSuccessCta = 'Got it';

  // Phone OTP
  static const String phoneOtpTitle = 'Verify your phone';
  static const String phoneOtpSubtitle =
      'We sent a 6-digit code to your number. Enter it below to continue.';
  static const String phoneOtpCodeLabel = 'Verification code';
  static const String phoneOtpPrimaryCta = 'Verify and continue';
  static const String phoneOtpResendCta = 'Resend code';
  static const String phoneOtpResendIn = 'Resend available in';
  static const String phoneOtpChangeNumber = 'Use a different number';
  static const String phoneOtpDidNotReceive = 'Didn’t get the code?';

  // Email verification
  static const String emailVerificationTitle = 'Verify your email';
  static const String emailVerificationSubtitle =
      'We sent a verification link to your inbox. Open it, then come back here to continue.';
  static const String emailVerificationRefresh = 'I have verified my email';
  static const String emailVerificationResend = 'Resend verification email';
  static const String emailVerificationSignOut = 'Sign out and use another account';
  static const String emailVerificationAwaiting = 'Waiting for verification…';

  // Complete profile
  static const String completeProfileTitle = 'Tell us about yourself';
  static const String completeProfileSubtitle =
      'We will personalise your quest, daily streaks and recommended study missions.';
  static const String completeProfileNameLabel = 'Display name';
  static const String completeProfileNameHint = 'What should we call you?';
  static const String completeProfileExamTrackLabel = 'Exam track';
  static const String completeProfileDistrictLabel = 'District (optional)';
  static const String completeProfileDistrictHint = 'Where are you preparing from?';
  static const String completeProfilePhoneLabel = 'Phone number (optional)';
  static const String completeProfilePhoneHint = '01XXXXXXXXX';
  static const String completeProfilePrimaryCta = 'Start learning';
  static const String completeProfileSkip = 'Skip for now';

  // Generic
  static const String loading = 'Hang tight…';
  static const String continueLabel = 'Continue';
  static const String back = 'Back';
  static const String cancel = 'Cancel';
  static const String or = 'OR';
  static const String successGeneric = 'All set!';
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';
  static const String emailAlreadyInUse =
      'That email is already registered. Try signing in instead.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String weakPassword =
      'Password must be at least 8 characters and include a letter and a number.';
  static const String passwordMismatch = 'Passwords do not match.';
  static const String invalidCredentials =
      'Email or password is incorrect. Please try again.';
  static const String userNotFound =
      'No account found for that email. Please create an account first.';
  static const String tooManyRequests =
      'Too many attempts. Please wait a moment and try again.';
  static const String networkUnavailable =
      'You appear to be offline. Check your connection and try again.';
  static const String emailNotVerified =
      'Please verify your email address before continuing.';
  static const String requiredField = 'This field is required.';
  static const String invalidPhone =
      'Please enter a valid Bangladeshi phone number.';
  static const String invalidName =
      'Please enter a name between 2 and 50 characters.';
  static const String passwordTooShort =
      'Password must be at least 8 characters.';
  static const String passwordLetterMissing =
      'Password must include at least one letter.';
  static const String passwordNumberMissing =
      'Password must include at least one number.';
}