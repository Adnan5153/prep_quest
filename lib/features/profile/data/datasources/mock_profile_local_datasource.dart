import '../models/user_profile_model.dart';
import 'profile_local_datasource.dart';

/// In-memory profile cache.
///
/// Survives only until process restart — the entire mock stack is
/// designed so we can swap it for Hive (or another durable store)
/// without changing the repository contract.
class MockProfileLocalDataSource implements ProfileLocalDataSource {
  MockProfileLocalDataSource({Duration? latency})
      : _latency = latency ?? const Duration(milliseconds: 50);

  final Duration _latency;
  UserProfileModel? _cached;

  @override
  Future<UserProfileModel?> read() async {
    await _wait();
    return _cached;
  }

  @override
  Future<void> write(UserProfileModel model) async {
    await _wait();
    _cached = model;
  }

  @override
  Future<void> clear() async {
    await _wait();
    _cached = null;
  }

  Future<void> _wait() async {
    await Future<void>.delayed(_latency);
  }
}