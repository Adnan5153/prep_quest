// ignore_for_file: prefer_initializing_formals

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/cache/hive_manager.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/datasources/offline_local_datasource.dart';
import '../../data/datasources/offline_remote_datasource.dart';
import '../../data/models/offline_item_model.dart';
import '../../data/repositories/offline_repository_impl.dart';
import '../../domain/entities/offline_item_entity.dart';
import '../../domain/entities/storage_usage_entity.dart';
import '../../domain/repositories/offline_repository.dart';
import '../../domain/usecases/clear_cache.dart';
import '../../domain/usecases/delete_download.dart';
import '../../domain/usecases/get_offline_items.dart';

final _hiveManagerProvider = Provider<HiveManager>(
  (Ref ref) => HiveManager.instance,
);

final _storageServiceProvider = Provider<StorageService>(
  (Ref ref) => StorageService(),
);

final offlineLocalDataSourceProvider = Provider<OfflineLocalDataSource>(
  (Ref ref) {
    final OfflineLocalDataSource ds = OfflineLocalDataSource(
      hive: ref.watch(_hiveManagerProvider),
    );
    ref.onDispose(ds.dispose);
    return ds;
  },
);

final offlineRemoteDataSourceProvider = Provider<OfflineRemoteDataSource>(
  (Ref ref) => OfflineRemoteDataSource(),
);

final offlineRepositoryProvider = Provider<OfflineRepository>(
  (Ref ref) {
    final OfflineRepositoryImpl impl = OfflineRepositoryImpl(
      local: ref.watch(offlineLocalDataSourceProvider),
      remote: ref.watch(offlineRemoteDataSourceProvider),
      storage: ref.watch(_storageServiceProvider),
    );
    ref.onDispose(impl.dispose);
    return impl;
  },
);

final getOfflineItemsUseCaseProvider = Provider<GetOfflineItems>(
  (Ref ref) => GetOfflineItems(ref.watch(offlineRepositoryProvider)),
);

final deleteDownloadUseCaseProvider = Provider<DeleteDownload>(
  (Ref ref) => DeleteDownload(ref.watch(offlineRepositoryProvider)),
);

final clearCacheUseCaseProvider = Provider<ClearCache>(
  (Ref ref) => ClearCache(ref.watch(offlineRepositoryProvider)),
);

final getStorageUsageUseCaseProvider = Provider<GetStorageUsage>(
  (Ref ref) => GetStorageUsage(ref.watch(offlineRepositoryProvider)),
);

final deleteAllDownloadsUseCaseProvider = Provider<DeleteAllDownloads>(
  (Ref ref) => DeleteAllDownloads(ref.watch(offlineRepositoryProvider)),
);

/// Live view of every offline item, broadcast from the local datasource.
final offlineItemsStreamProvider = StreamProvider<List<OfflineItemEntity>>(
  (Ref ref) {
    final OfflineLocalDataSource local =
        ref.watch(offlineLocalDataSourceProvider);
    List<OfflineItemEntity> mapModels(List<OfflineItemModel> items) =>
        items.map((OfflineItemModel m) => m.toEntity()).toList(growable: false);
    return local.watchItems().map(mapModels);
  },
);

/// Storage usage snapshot refreshed every time the items stream fires.
final storageUsageProvider = FutureProvider<StorageUsageEntity>(
  (Ref ref) async {
    ref.watch(offlineItemsStreamProvider);
    final GetStorageUsage useCase = ref.watch(getStorageUsageUseCaseProvider);
    final dynamic result = await useCase.call();
    if (result.isFailure) {
      throw StateError('Failed to load storage usage');
    }
    return result.value as StorageUsageEntity;
  },
);