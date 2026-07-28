// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../data/datasources/offline_local_datasource.dart';
import '../../data/models/sync_task_model.dart';
import '../../domain/entities/sync_task_entity.dart';
import '../../domain/usecases/sync_offline_data.dart';
import 'offline_provider.dart';

final _connectivityServiceProvider = Provider<ConnectivityService>(
  (Ref ref) {
    final ConnectivityService service = ConnectivityService();
    service.initialize();
    ref.onDispose(service.dispose);
    return service;
  },
);

final networkStateProvider = StreamProvider<bool>(
  (Ref ref) async* {
    final ConnectivityService service = ref.watch(_connectivityServiceProvider);
    yield service.isOnline;
    yield* service.changes;
  },
);

final syncQueueStreamProvider = StreamProvider<List<SyncTaskEntity>>(
  (Ref ref) {
    final OfflineLocalDataSource local =
        ref.watch(offlineLocalDataSourceProvider);

    List<SyncTaskEntity> mapModels(List<SyncTaskModel> items) =>
        items.map((SyncTaskModel m) => m.toEntity()).toList(growable: false);

    return local.watchSync().map(mapModels);
  },
);

final syncOfflineDataUseCaseProvider = Provider<SyncOfflineData>(
  (Ref ref) => SyncOfflineData(ref.watch(offlineRepositoryProvider)),
);

final enqueueSyncUseCaseProvider = Provider<EnqueueSync>(
  (Ref ref) => EnqueueSync(ref.watch(offlineRepositoryProvider)),
);

class SyncController extends StateNotifier<SyncState> {
  SyncController({
    required SyncOfflineData syncOfflineData,
    required EnqueueSync enqueueSync,
    required ConnectivityService connectivity,
  })  : _syncOfflineData = syncOfflineData,
        _enqueueSync = enqueueSync,
        _connectivity = connectivity,
        super(const SyncState.idle());

  final SyncOfflineData _syncOfflineData;
  final EnqueueSync _enqueueSync;
  final ConnectivityService _connectivity;
  Timer? _retryTimer;

  Future<void> syncNow() async {
    if (!_connectivity.isOnline) {
      state = state.copyWith(
        status: SyncStatusKind.waitingForConnection,
        message: 'Waiting for connection',
      );
      return;
    }
    state = state.copyWith(status: SyncStatusKind.syncing);
    final dynamic result = await _syncOfflineData();
    if (result.isFailure) {
      state = state.copyWith(
        status: SyncStatusKind.failed,
        message: 'Sync failed',
      );
      _scheduleRetry();
      return;
    }
    state = state.copyWith(status: SyncStatusKind.idle, message: null);
  }

  Future<void> enqueueSample({
    required SyncSource source,
    required SyncPayloadType type,
    required Map<String, dynamic> payload,
  }) async {
    await _enqueueSync(source: source, payloadType: type, payload: payload);
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(seconds: 8), () {
      if (!_connectivity.isOnline) return;
      syncNow();
    });
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }
}

enum SyncStatusKind { idle, syncing, failed, waitingForConnection }

class SyncState {
  const SyncState({required this.status, this.message});
  const SyncState.idle()
      : status = SyncStatusKind.idle,
        message = null;

  final SyncStatusKind status;
  final String? message;

  SyncState copyWith({SyncStatusKind? status, String? message}) => SyncState(
        status: status ?? this.status,
        message: message ?? this.message,
      );
}

final syncControllerProvider =
    StateNotifierProvider<SyncController, SyncState>(
  (Ref ref) => SyncController(
    syncOfflineData: ref.watch(syncOfflineDataUseCaseProvider),
    enqueueSync: ref.watch(enqueueSyncUseCaseProvider),
    connectivity: ref.watch(_connectivityServiceProvider),
  ),
);