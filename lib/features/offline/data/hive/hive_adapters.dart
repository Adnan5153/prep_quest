import 'package:hive/hive.dart';

import '../models/download_task_model.dart';
import '../models/offline_item_model.dart';
import '../models/sync_task_model.dart';

/// Hand-written Hive adapters for the offline feature's models.
///
/// Using manually-written `TypeAdapter`s keeps the build pipeline free
/// of `build_runner` overhead and gives us full control over the wire
/// format. The type IDs are stable (1 = item, 2 = download, 3 = sync)
/// so existing on-device data survives app updates.
class OfflineItemModelAdapter extends TypeAdapter<OfflineItemModel> {
  @override
  final int typeId = 1;

  @override
  OfflineItemModel read(BinaryReader reader) {
    final int fieldsCount = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < fieldsCount; i++) reader.readByte(): reader.read(),
    };
    return OfflineItemModel(
      id: fields[0] as String,
      title: fields[1] as String,
      subtitle: (fields[2] as String?) ?? '',
      contentTypeName: (fields[3] as String?) ?? 'lesson',
      sizeBytes: (fields[4] as int?) ?? 0,
      downloadedAtIso: (fields[5] as String?) ?? '',
      lastAccessedIso: (fields[6] as String?) ?? '',
      thumbnailIconKey: fields[7] as String?,
      subjectTag: fields[8] as String?,
      itemCount: (fields[9] as int?) ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineItemModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.contentTypeName)
      ..writeByte(4)
      ..write(obj.sizeBytes)
      ..writeByte(5)
      ..write(obj.downloadedAtIso)
      ..writeByte(6)
      ..write(obj.lastAccessedIso)
      ..writeByte(7)
      ..write(obj.thumbnailIconKey)
      ..writeByte(8)
      ..write(obj.subjectTag)
      ..writeByte(9)
      ..write(obj.itemCount);
  }
}

class DownloadTaskModelAdapter extends TypeAdapter<DownloadTaskModel> {
  @override
  final int typeId = 2;

  @override
  DownloadTaskModel read(BinaryReader reader) {
    final int fieldsCount = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < fieldsCount; i++) reader.readByte(): reader.read(),
    };
    return DownloadTaskModel(
      id: fields[0] as String,
      contentId: fields[1] as String,
      title: fields[2] as String,
      contentTypeName: (fields[3] as String?) ?? 'lesson',
      totalBytes: (fields[4] as int?) ?? 0,
      receivedBytes: (fields[5] as int?) ?? 0,
      statusName: (fields[6] as String?) ?? 'queued',
      createdAtIso: (fields[7] as String?) ?? '',
      completedAtIso: fields[8] as String?,
      errorMessage: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadTaskModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.contentId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.contentTypeName)
      ..writeByte(4)
      ..write(obj.totalBytes)
      ..writeByte(5)
      ..write(obj.receivedBytes)
      ..writeByte(6)
      ..write(obj.statusName)
      ..writeByte(7)
      ..write(obj.createdAtIso)
      ..writeByte(8)
      ..write(obj.completedAtIso)
      ..writeByte(9)
      ..write(obj.errorMessage);
  }
}

class SyncTaskModelAdapter extends TypeAdapter<SyncTaskModel> {
  @override
  final int typeId = 3;

  @override
  SyncTaskModel read(BinaryReader reader) {
    final int fieldsCount = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < fieldsCount; i++) reader.readByte(): reader.read(),
    };
    return SyncTaskModel(
      id: fields[0] as String,
      sourceName: (fields[1] as String?) ?? 'quiz',
      payloadTypeName: (fields[2] as String?) ?? 'quizAttempt',
      payload: (fields[3] as Map?)?.cast<String, dynamic>() ??
          const <String, dynamic>{},
      createdAtIso: (fields[4] as String?) ?? '',
      statusName: (fields[5] as String?) ?? 'pending',
      attempts: (fields[6] as int?) ?? 0,
      lastErrorMessage: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SyncTaskModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sourceName)
      ..writeByte(2)
      ..write(obj.payloadTypeName)
      ..writeByte(3)
      ..write(obj.payload)
      ..writeByte(4)
      ..write(obj.createdAtIso)
      ..writeByte(5)
      ..write(obj.statusName)
      ..writeByte(6)
      ..write(obj.attempts)
      ..writeByte(7)
      ..write(obj.lastErrorMessage);
  }
}

/// Registers every offline adapter with Hive. Idempotent.
void registerOfflineAdapters() {
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter<OfflineItemModel>(OfflineItemModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter<DownloadTaskModel>(DownloadTaskModelAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter<SyncTaskModel>(SyncTaskModelAdapter());
  }
}