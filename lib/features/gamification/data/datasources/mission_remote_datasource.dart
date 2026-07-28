import '../../domain/enums/mission_enums.dart';
import '../models/mission_model.dart';

/// Future Firestore-backed source of truth.
///
/// Intentionally left unimplemented: the production app currently has
/// no backend for gamification. The repository implements a
/// remote-first / local-cache fallback so swapping this stub in is a
/// non-event for consumers — and tests can flip a switch to verify
/// the fallback path.
class MissionRemoteDataSource {
  const MissionRemoteDataSource();

  List<MissionModel> readAll() {
    throw UnimplementedError(
      'MissionRemoteDataSource is not yet wired to Firestore.',
    );
  }

  List<MissionModel> readByCadence(MissionCadence cadence) {
    throw UnimplementedError(
      'MissionRemoteDataSource is not yet wired to Firestore.',
    );
  }

  MissionModel? readById(String id) {
    throw UnimplementedError(
      'MissionRemoteDataSource is not yet wired to Firestore.',
    );
  }

  void write(MissionModel model) {
    throw UnimplementedError(
      'MissionRemoteDataSource is not yet wired to Firestore.',
    );
  }

  DateTime now() {
    throw UnimplementedError(
      'MissionRemoteDataSource is not yet wired to Firestore.',
    );
  }

  DateTime nextResetAfter(MissionCadence cadence) {
    throw UnimplementedError(
      'MissionRemoteDataSource is not yet wired to Firestore.',
    );
  }
}