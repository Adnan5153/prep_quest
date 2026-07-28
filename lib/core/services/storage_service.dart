/// Lightweight storage-usage facade.
///
/// The current implementation returns a deterministic mock snapshot so
/// the UI can be exercised without platform-specific plugins. Swap
/// with `disk_space`/`path_provider` at integration time.
class StorageService {
  StorageService();

  /// Total usable space reported by the platform in MB.
  static const double _totalMb = 32768.0; // 32 GB
  static const double _usedMb = 6240.0; // ~6.1 GB

  Future<StorageSnapshot> snapshot() async {
    await Future<void>.delayed(const Duration(milliseconds: 40));
    final double free = _totalMb - _usedMb;
    return StorageSnapshot(
      totalMb: _totalMb,
      usedMb: _usedMb,
      freeMb: free,
    );
  }
}

/// Immutable storage reading used by the offline UI.
class StorageSnapshot {
  const StorageSnapshot({
    required this.totalMb,
    required this.usedMb,
    required this.freeMb,
  });

  final double totalMb;
  final double usedMb;
  final double freeMb;

  double get usedRatio => totalMb == 0 ? 0 : usedMb / totalMb;
}