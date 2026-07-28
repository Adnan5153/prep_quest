import '../models/review_session_model.dart';

/// Remote data source contract for the Review feature.
///
/// The current production app has no backend wired for review, so the
/// mock implementation in [ReviewLocalDataSource] implements this
/// interface as well. When a real backend lands, add a Firebase /
/// network-backed implementation here.
abstract class ReviewRemoteDataSource {
  Future<List<ReviewSessionModel>> fetchAllSessions();

  Future<ReviewSessionModel?> fetchSessionById(String sessionId);

  Future<String> fetchAiExplanation(String questionId);

  Future<void> persistSession(ReviewSessionModel session);
}
