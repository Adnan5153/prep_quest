import '../models/notification_model.dart';

/// Deterministic in-memory datasource used until notification sync is wired.
class NotificationLocalDataSource {
  NotificationLocalDataSource({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  List<NotificationModel>? _cache;

  List<NotificationModel> readAll() {
    _ensureSeeded();
    return List<NotificationModel>.unmodifiable(_cache!);
  }

  void writeAll(List<NotificationModel> rows) {
    _cache = List<NotificationModel>.from(rows);
  }

  void _ensureSeeded() {
    if (_cache != null) return;
    final DateTime now = _clock();
    _cache = <NotificationModel>[
      NotificationModel(
        id: 'notification_daily_quiz',
        title: 'Daily quiz is ready',
        message: 'Your new daily quiz is waiting. Keep your streak alive.',
        createdAtIso: now.subtract(const Duration(minutes: 12)).toIso8601String(),
        routeName: '/quiz/overview',
        isRead: false,
      ),
      NotificationModel(
        id: 'notification_rank',
        title: 'Leaderboard update',
        message: 'You moved up one place in the weekly leaderboard.',
        createdAtIso: now.subtract(const Duration(hours: 2)).toIso8601String(),
        routeName: '/leaderboard/weekly',
        isRead: false,
      ),
      NotificationModel(
        id: 'notification_mission',
        title: 'Mission reward available',
        message: 'A completed mission reward is ready to claim.',
        createdAtIso: now.subtract(const Duration(days: 1)).toIso8601String(),
        routeName: '/missions/daily',
        isRead: true,
      ),
    ];
  }
}
