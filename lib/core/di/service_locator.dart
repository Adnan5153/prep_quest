import '../../features/ai_tutor/data/datasources/gemini_remote_datasource.dart';
import '../../features/ai_tutor/data/repositories/ai_tutor_repository_impl.dart';
import '../../features/ai_tutor/domain/repositories/ai_tutor_repository.dart';
import '../services/ai/ai_prompt_builder.dart';
import '../services/ai/ai_response_parser.dart';
import '../services/ai/ai_service.dart';
import '../services/ai/gemini_ai_service.dart';

/// Lightweight service locator for dependencies that live outside the
/// Riverpod container — primarily bootstrap code, integration tests,
/// and the eventual Firebase Cloud Functions migration path.
///
/// Riverpod remains the primary DI mechanism for the runtime app.
/// Anything that owns `Ref` should depend on providers, not on this
/// registry. Callers that don't have a `Ref` (background workers,
/// platform channels, integration tests) reach for the static
/// accessors below.
class ServiceLocator {
  const ServiceLocator._();

  static AiService _aiService = GeminiAiService();
  static AiPromptBuilder _promptBuilder = const AiPromptBuilder();
  static AiResponseParser _responseParser = const AiResponseParser();
  static AiTutorRepository _aiTutorRepository = AiTutorRepositoryImpl(
    remote: GeminiRemoteDataSource(
      service: _aiService,
      promptBuilder: _promptBuilder,
      responseParser: _responseParser,
    ),
  );

  /// Currently bound AI service.
  static AiService get aiService => _aiService;

  /// Currently bound AI tutor repository.
  static AiTutorRepository get aiTutorRepository => _aiTutorRepository;

  /// Replaces every binding in one call. Intended for test setup.
  static void bootstrap({
    required AiService aiService,
    AiPromptBuilder? promptBuilder,
    AiResponseParser? responseParser,
    AiTutorRepository? aiTutorRepository,
  }) {
    _aiService = aiService;
    _promptBuilder = promptBuilder ?? const AiPromptBuilder();
    _responseParser = responseParser ?? const AiResponseParser();
    _aiTutorRepository = aiTutorRepository ??
        AiTutorRepositoryImpl(
          remote: GeminiRemoteDataSource(
            service: _aiService,
            promptBuilder: _promptBuilder,
            responseParser: _responseParser,
          ),
        );
  }
}