import '../models/notification_model.dart';

/// Future Firestore-backed source of truth.
class NotificationRemoteDataSource {
  const NotificationRemoteDataSource();

  List<NotificationModel> readAll() {
    throw UnimplementedError(
      'NotificationRemoteDataSource is not yet wired to Firestore.',
    );
  }

  void write(NotificationModel model) {
    throw UnimplementedError(
      'NotificationRemoteDataSource is not yet wired to Firestore.',
    );
  }
}