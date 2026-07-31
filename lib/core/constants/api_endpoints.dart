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

  /// Quiz Hub REST base. Override at compile time via
  /// `--dart-define=QUIZ_API_BASE_URL=...` to point at a staging /
  /// mock backend. Production default is the public Lovable-hosted
  /// Quiz Hub endpoint documented in `docs/apidoc/api`.
  static const String quizApiBaseUrl = String.fromEnvironment(
    'QUIZ_API_BASE_URL',
    defaultValue: 'https://sadiks-quiz-apihub.lovable.app/api/v1',
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

  // ----- Quiz Hub REST (Phase 35 + Phase 38) -----

  /// `GET /categories` — paginated list.
  static String get quizCategories => '$quizApiBaseUrl/categories';

  /// `GET /categories/{id}` — single category lookup.
  static String quizCategoryById(String id) =>
      '$quizApiBaseUrl/categories/$id';

  /// `GET /categories/{id}/questions` — paginated question bank.
  static String quizQuestions(String categoryId) =>
      '$quizApiBaseUrl/categories/$categoryId/questions';

  /// `GET /categories/{id}/questions/random` — random sampling.
  static String quizRandomQuestions(String categoryId) =>
      '$quizApiBaseUrl/categories/$categoryId/questions/random';

  /// `GET /questions/{id}` — single question lookup.
  static String quizQuestionById(String id) =>
      '$quizApiBaseUrl/questions/$id';

  /// `POST /categories/{id}/questions/bulk-delete` — bulk delete.
  static String quizBulkDelete(String categoryId) =>
      '$quizApiBaseUrl/categories/$categoryId/questions/bulk-delete';

  /// `POST /categories/{id}/questions/import` — bulk import.
  static String quizImportQuestions(String categoryId) =>
      '$quizApiBaseUrl/categories/$categoryId/questions/import';

  /// `GET /categories/{id}/questions/export` — bulk export.
  static String quizExportQuestions(String categoryId) =>
      '$quizApiBaseUrl/categories/$categoryId/questions/export';
}
