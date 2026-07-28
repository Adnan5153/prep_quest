/// Centralised configuration for the Google Gemini integration.
///
/// The API key is **never** hardcoded. It must be supplied at build
/// time via `--dart-define=GEMINI_API_KEY=...`. In production the
/// intent is to delegate these calls to a server-side proxy
/// (Firebase Cloud Functions / Cloud Run) so the key never ships in
/// the binary — the only change required is to point
/// [GeminiConfig.restBaseUrl] at the proxy and rotate
/// [GeminiConfig.apiKey] to whatever the proxy expects.
///
/// The public surface is intentionally small so the data layer
/// cannot accidentally reach into implementation details.
class GeminiConfig {
  const GeminiConfig._();

  /// Provider id — matches [AiService.providerName].
  static const String providerName = 'gemini';

  /// Default model used when a request does not specify one.
  static const String defaultModel = 'gemini-2.5-flash';

  /// Official Gemini REST base. Override via the constructor when
  /// pointing at a proxy (e.g. `https://us-central1-…cloudfunctions.net`).
  static const String defaultBaseUrl =
      'https://generativelanguage.googleapis.com';

  /// Reads the API key from the build-time environment. The key is
  /// blank when `--dart-define=GEMINI_API_KEY` is not set, which is
  /// the expected state in CI and during local development without
  /// secrets.
  static const String apiKey = String.fromEnvironment('GEMINI_API_KEY');

  /// Resolved REST base URL. Defaults to Google's official endpoint.
  static const String restBaseUrl = String.fromEnvironment(
    'GEMINI_BASE_URL',
    defaultValue: defaultBaseUrl,
  );

  /// `true` when the binary was built without a key — useful for
  /// surfacing a friendly "configure your key" error instead of a
  /// confusing 403 from Gemini.
  static bool get isKeyMissing => apiKey.isEmpty;

  /// Per-request timeout. Tuned for a 2.5-flash class model where
  /// the long tail of structured responses can take a few seconds.
  static const Duration requestTimeout = Duration(seconds: 30);
}
