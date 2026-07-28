import 'package:flutter/foundation.dart';

/// Aggregate download + storage usage info used by the storage
/// management screen.
@immutable
class StorageUsageEntity {
  const StorageUsageEntity({
    required this.totalBytes,
    required this.usedBytes,
    required this.freeBytes,
    required this.lessonCount,
    required this.questionSetCount,
    required this.largestItemBytes,
  });

  final int totalBytes;
  final int usedBytes;
  final int freeBytes;
  final int lessonCount;
  final int questionSetCount;
  final int largestItemBytes;

  double get usedRatio => totalBytes == 0 ? 0 : usedBytes / totalBytes;
}
