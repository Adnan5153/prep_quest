/// Central registry of API endpoints used across the application.
///
/// Build flavors override these via the
/// `--dart-define=API_BASE_URL=...` flag — production builds should never
/// point at localhost.
class ApiEndpoints {
  const ApiEndpoints._();

  /// Root URL for the REST / GraphQL API.
  ///
  /// Override at compile time:
  /// ```
  /// flutter build apk --dart-define=API_BASE_URL=https://api.prepquest.app
  /// ```
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.dev.prepquest.app',
  );

  /// Cloud Functions emulator host (used in dev / staging only).
  static const String functionsEmulator = String.fromEnvironment(
    'FUNCTIONS_EMULATOR_HOST',
    defaultValue: '',
  );

  /// AI Tutor proxy endpoint, always routed through a backend function so the
  /// LLM key never ships in the client.
  static String get aiTutor => '$baseUrl/ai/tutor';

  /// AI Exam Simulator endpoint.
  static String get aiExamSimulator => '$baseUrl/ai/exam-simulator';

  /// Smart Prompt assistant endpoint.
  static String get smartPrompt => '$baseUrl/ai/smart-prompt';
}
