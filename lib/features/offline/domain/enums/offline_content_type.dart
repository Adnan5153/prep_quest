/// Top-level buckets of downloadable content.
enum OfflineContentType { lesson, chapter, subject, questionSet, mockTest }

/// State of a single download task.
enum DownloadStatus { queued, downloading, paused, completed, failed, cancelled }

/// State of a queued sync action.
enum SyncStatus { pending, syncing, synced, failed }

/// Coarse network state surfaced to the UI.
enum NetworkState {
  online,
  offline,
  syncing,
  waitingForConnection,
  downloadFailed,
  syncFailed,
}

extension OfflineContentTypeX on OfflineContentType {
  String get label {
    switch (this) {
      case OfflineContentType.lesson:
        return 'Lesson';
      case OfflineContentType.chapter:
        return 'Chapter';
      case OfflineContentType.subject:
        return 'Subject';
      case OfflineContentType.questionSet:
        return 'Question set';
      case OfflineContentType.mockTest:
        return 'Mock test';
    }
  }
}

extension DownloadStatusX on DownloadStatus {
  bool get isTerminal =>
      this == DownloadStatus.completed ||
      this == DownloadStatus.cancelled ||
      this == DownloadStatus.failed;
  bool get isActive =>
      this == DownloadStatus.queued ||
      this == DownloadStatus.downloading ||
      this == DownloadStatus.paused;
}

extension SyncStatusX on SyncStatus {
  bool get isTerminal =>
      this == SyncStatus.synced || this == SyncStatus.failed;
}

extension NetworkStateX on NetworkState {
  bool get isOnline => this == NetworkState.online || this == NetworkState.syncing;
  bool get isOffline => this == NetworkState.offline || this == NetworkState.waitingForConnection;
}