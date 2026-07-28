import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/admin_exception.dart';
import '../../../../core/validators/validators.dart';
import '../../data/repositories/world_repository_impl.dart';
import '../entities/world_draft_entity.dart';
import '../entities/world_entity.dart';
import '../entities/world_version_entity.dart';
import '../repositories/world_repository.dart';

class CreateWorldParams {
  const CreateWorldParams({
    required this.slug,
    required this.displayName,
    required this.examVerticalCode,
    required this.description,
    required this.ownerId,
  });

  final String slug;
  final String displayName;
  final String examVerticalCode;
  final String description;
  final String ownerId;
}

class CreateWorldUseCase {
  const CreateWorldUseCase(this._repository);

  final WorldRepository _repository;

  Future<WorldEntity> call(CreateWorldParams params) async {
    final String? slugError = SlugValidator.validate(params.slug);
    if (slugError != null) {
      throw AdminValidationException(slugError, field: 'slug');
    }
    if (params.displayName.trim().isEmpty) {
      throw const AdminValidationException('Display name is required',
          field: 'displayName');
    }
    return _repository.createWorld(
      slug: params.slug.trim(),
      displayName: params.displayName.trim(),
      examVertical: params.examVerticalCode,
      description: params.description.trim(),
      ownerId: params.ownerId,
    );
  }
}

class OpenDraftParams {
  const OpenDraftParams({
    required this.worldId,
    required this.branchName,
    required this.ownerId,
    this.baseVersionId,
  });

  final String worldId;
  final String branchName;
  final String ownerId;
  final String? baseVersionId;
}

class OpenDraftUseCase {
  const OpenDraftUseCase(this._repository);

  final WorldRepository _repository;

  Future<WorldDraftEntity> call(OpenDraftParams params) {
    if (params.branchName.trim().isEmpty) {
      throw const AdminValidationException('Branch name is required',
          field: 'branchName');
    }
    return _repository.openDraft(
      worldId: params.worldId,
      branchName: params.branchName.trim(),
      ownerId: params.ownerId,
      baseVersionId: params.baseVersionId,
    );
  }
}

class SaveDraftParams {
  const SaveDraftParams({required this.draft, required this.expectedVersion});

  final WorldDraftEntity draft;
  final int expectedVersion;
}

class SaveDraftUseCase {
  const SaveDraftUseCase(this._repository);

  final WorldRepository _repository;

  Future<WorldDraftEntity> call(SaveDraftParams params) async {
    if (params.draft.lockHolderId != null &&
        params.draft.lockHolderId != params.draft.ownerId &&
        params.draft.lockExpiresAt != null &&
        params.draft.lockExpiresAt!.isAfter(DateTime.now())) {
      throw AdminConflictException(
          'Draft is locked by another author',
          currentVersion: params.draft.versionCounter);
    }
    return _repository.saveDraft(
      params.draft,
      expectedVersionCounter: params.expectedVersion,
    );
  }
}

class PublishDraftParams {
  const PublishDraftParams({
    required this.draftId,
    required this.actorId,
    required this.releaseNotes,
  });

  final String draftId;
  final String actorId;
  final String releaseNotes;
}

class PublishDraftUseCase {
  const PublishDraftUseCase(this._repository);

  final WorldRepository _repository;

  Future<WorldVersionEntity> call(PublishDraftParams params) {
    if (params.releaseNotes.trim().isEmpty) {
      throw const AdminValidationException('Release notes are required',
          field: 'releaseNotes');
    }
    return _repository.publishDraft(
      draftId: params.draftId,
      actorId: params.actorId,
      releaseNotes: params.releaseNotes.trim(),
    );
  }
}

class RollbackParams {
  const RollbackParams({
    required this.worldId,
    required this.targetVersionId,
    required this.actorId,
    required this.reason,
  });

  final String worldId;
  final String targetVersionId;
  final String actorId;
  final String reason;
}

class RollbackUseCase {
  const RollbackUseCase(this._repository);

  final WorldRepository _repository;

  Future<WorldVersionEntity> call(RollbackParams params) {
    if (params.reason.trim().isEmpty) {
      throw const AdminValidationException('Reason is required',
          field: 'reason');
    }
    return _repository.rollback(
      worldId: params.worldId,
      targetVersionId: params.targetVersionId,
      actorId: params.actorId,
      reason: params.reason.trim(),
    );
  }
}

final createWorldUseCaseProvider =
    Provider<CreateWorldUseCase>((Ref ref) {
  return CreateWorldUseCase(ref.watch(worldRepositoryProvider));
});

final openDraftUseCaseProvider = Provider<OpenDraftUseCase>((Ref ref) {
  return OpenDraftUseCase(ref.watch(worldRepositoryProvider));
});

final saveDraftUseCaseProvider = Provider<SaveDraftUseCase>((Ref ref) {
  return SaveDraftUseCase(ref.watch(worldRepositoryProvider));
});

final publishDraftUseCaseProvider =
    Provider<PublishDraftUseCase>((Ref ref) {
  return PublishDraftUseCase(ref.watch(worldRepositoryProvider));
});

final rollbackUseCaseProvider = Provider<RollbackUseCase>((Ref ref) {
  return RollbackUseCase(ref.watch(worldRepositoryProvider));
});
