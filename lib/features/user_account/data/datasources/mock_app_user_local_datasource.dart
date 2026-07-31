import '../models/app_user_model.dart';
import 'app_user_local_datasource.dart';

/// In-memory [AppUserLocalDataSource] used during development and tests.
///
/// Simulates Hive by holding a single [AppUserModel] in a private
/// field. Production swaps in the Hive-backed implementation.
class MockAppUserLocalDataSource implements AppUserLocalDataSource {
  MockAppUserLocalDataSource({Duration? latency})
      : _latency = latency ?? const Duration(milliseconds: 50);

  final Duration _latency;
  AppUserModel? _stored;

  @override
  Future<AppUserModel?> read() async {
    await Future<void>.delayed(_latency);
    return _stored;
  }

  @override
  Future<void> write(AppUserModel model) async {
    await Future<void>.delayed(_latency);
    _stored = model;
  }

  @override
  Future<void> clear() async {
    await Future<void>.delayed(_latency);
    _stored = null;
  }
}