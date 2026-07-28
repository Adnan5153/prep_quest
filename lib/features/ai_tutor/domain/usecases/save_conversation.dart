import '../../../../shared/typedefs/result.dart';
import '../entities/conversation.dart';
import '../repositories/ai_tutor_repository.dart';

/// Persists a [Conversation] and returns the canonical copy.
class SaveConversation {
  const SaveConversation(this._repository);

  final AiTutorRepository _repository;

  Future<Result<Conversation>> call(Conversation conversation) {
    return _repository.saveConversation(conversation);
  }
}

/// Loads every persisted conversation, newest first.
class LoadConversationHistory {
  const LoadConversationHistory(this._repository);

  final AiTutorRepository _repository;

  Future<Result<List<Conversation>>> call() {
    return _repository.loadConversationHistory();
  }
}

/// Loads a single conversation by id.
class LoadConversationById {
  const LoadConversationById(this._repository);

  final AiTutorRepository _repository;

  Future<Result<Conversation>> call(String conversationId) {
    return _repository.loadConversationById(conversationId);
  }
}

/// Loads the most recent N conversation sessions (for a sidebar preview).
class LoadRecentSessions {
  const LoadRecentSessions(this._repository, {this.defaultLimit = 8});

  final AiTutorRepository _repository;
  final int defaultLimit;

  Future<Result<List<Conversation>>> call({int? limit}) {
    return _repository.loadRecentSessions(limit: limit ?? defaultLimit);
  }
}

/// Loads the history of one-shot prompt entries.
class LoadPromptHistory {
  const LoadPromptHistory(this._repository);

  final AiTutorRepository _repository;

  Future<Result<List<PromptEntry>>> call() {
    return _repository.loadPromptHistory();
  }
}

/// Persists a new [PromptEntry] (used by the Smart Prompt Studio).
class SavePromptEntry {
  const SavePromptEntry(this._repository);

  final AiTutorRepository _repository;

  Future<Result<PromptEntry>> call(PromptEntry entry) {
    return _repository.savePromptEntry(entry);
  }
}

class TogglePromptFavorite {
  const TogglePromptFavorite(this._repository);

  final AiTutorRepository _repository;

  Future<Result<bool>> call(String promptId) {
    return _repository.togglePromptFavorite(promptId);
  }
}

class DeleteConversation {
  const DeleteConversation(this._repository);

  final AiTutorRepository _repository;

  Future<Result<bool>> call(String conversationId) {
    return _repository.deleteConversation(conversationId);
  }
}