/// Re-export of the canonical auth form widgets.
///
/// The implementation lives in this folder. The original stub files
/// remain thin aliases so existing imports (`import 'login_button.dart'`)
/// keep working without forcing the rest of the app onto the new
/// names.
library;

export 'auth_primary_button.dart' show AuthPrimaryButton;
export 'otp_input_field.dart' show OtpInputField;
export 'phone_text_field.dart' show PhoneTextField;
export 'resend_timer.dart' show ResendTimer;
export 'auth_form_field.dart' show AuthFormField;
export 'password_field.dart' show AuthPasswordField;
export 'auth_header.dart' show AuthHeader;
export 'auth_social_buttons.dart' show AuthSocialButtons;
export 'auth_divider.dart' show AuthDivider;
