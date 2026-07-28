// ignore_for_file: prefer_initializing_formals

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/offline_local_datasource.dart';
import '../../data/models/download_task_model.dart';
import '../../domain/entities/download_task_entity.dart';
import '../../domain/enums/offline_content_type.dart';
import '../../domain/usecases/cancel_download.dart';
import '../../domain/usecases/download_content.dart';
import '../../domain/usecases/get_offline_items.dart';
import '../../domain/usecases/pause_download.dart';
import '../../domain/usecases/resume_download.dart';
import 'offline_provider.dart';

final downloadQueueStreamProvider = StreamProvider<List<DownloadTaskEntity>>(
  (Ref ref) {
    final OfflineLocalDataSource local =
        ref.watch(offlineLocalDataSourceProvider);

    List<DownloadTaskEntity> mapModels(List<DownloadTaskModel> items) =>
        items.map((DownloadTaskModel m) => m.toEntity()).toList(growable: false);

    return local.watchDownloads().map(mapModels);
  },
);

final downloadContentUseCaseProvider = Provider<DownloadContent>(
  (Ref ref) => DownloadContent(ref.watch(offlineRepositoryProvider)),
);

final pauseDownloadUseCaseProvider = Provider<PauseDownload>(
  (Ref ref) => PauseDownload(ref.watch(offlineRepositoryProvider)),
);

final resumeDownloadUseCaseProvider = Provider<ResumeDownload>(
  (Ref ref) => ResumeDownload(ref.watch(offlineRepositoryProvider)),
);

final cancelDownloadUseCaseProvider = Provider<CancelDownload>(
  (Ref ref) => CancelDownload(ref.watch(offlineRepositoryProvider)),
);

final getDownloadQueueUseCaseProvider = Provider<GetDownloadQueue>(
  (Ref ref) => GetDownloadQueue(ref.watch(offlineRepositoryProvider)),
);

/// Drives the download queue lifecycle from the UI layer.
class DownloadQueueController extends StateNotifier<DownloadQueueState> {
  DownloadQueueController({
    required DownloadContent downloadContent,
    required PauseDownload pauseDownload,
    required ResumeDownload resumeDownload,
    required CancelDownload cancelDownload,
  })  : _downloadContent = downloadContent,
        _pauseDownload = pauseDownload,
        _resumeDownload = resumeDownload,
        _cancelDownload = cancelDownload,
        super(const DownloadQueueState.idle());

  final DownloadContent _downloadContent;
  final PauseDownload _pauseDownload;
  final ResumeDownload _resumeDownload;
  final CancelDownload _cancelDownload;

  Future<void> enqueue({
    required String contentId,
    required String title,
    required OfflineContentType contentType,
    required int totalBytes,
  }) async {
    state = state.copyWith(status: DownloadQueueStatus.queued);
    await _downloadContent(
      contentId: contentId,
      title: title,
      contentType: contentType,
      totalBytes: totalBytes,
    );
    state = state.copyWith(status: DownloadQueueStatus.idle);
  }

  Future<void> pause(String taskId) async {
    state = state.copyWith(status: DownloadQueueStatus.working);
    await _pauseDownload(taskId);
    state = state.copyWith(status: DownloadQueueStatus.idle);
  }

  Future<void> resume(String taskId) async {
    state = state.copyWith(status: DownloadQueueStatus.working);
    await _resumeDownload(taskId);
    state = state.copyWith(status: DownloadQueueStatus.idle);
  }

  Future<void> cancel(String taskId) async {
    state = state.copyWith(status: DownloadQueueStatus.working);
    await _cancelDownload(taskId);
    state = state.copyWith(status: DownloadQueueStatus.idle);
  }
}

enum DownloadQueueStatus { idle, queued, working }

class DownloadQueueState {
  const DownloadQueueState({required this.status});
  const DownloadQueueState.idle()
      : status = DownloadQueueStatus.idle;

  final DownloadQueueStatus status;

  DownloadQueueState copyWith({DownloadQueueStatus? status}) =>
      DownloadQueueState(status: status ?? this.status);
}

final downloadQueueControllerProvider =
    StateNotifierProvider<DownloadQueueController, DownloadQueueState>(
  (Ref ref) => DownloadQueueController(
    downloadContent: ref.watch(downloadContentUseCaseProvider),
    pauseDownload: ref.watch(pauseDownloadUseCaseProvider),
    resumeDownload: ref.watch(resumeDownloadUseCaseProvider),
    cancelDownload: ref.watch(cancelDownloadUseCaseProvider),
  ),
);