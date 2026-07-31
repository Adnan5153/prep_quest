import 'package:flutter/foundation.dart';

/// Canonical notification types — drives the icon, color, and the
/// Cloud Function selector on the backend.
enum NotificationType {
  reminder,
  mission,
  reward,
  announcement,
  system,
  aiSuggestion,
  subscription,
  dailyQuiz,
  streak,
  levelUp,
  xpEarned,
  coinReward,
  generic,
}

extension NotificationTypeX on NotificationType {
  String get wireName => name;

  static NotificationType fromWire(String? raw) {
    return NotificationType.values.firstWhere(
      (NotificationType t) => t.name == raw,
      orElse: () => NotificationType.generic,
    );
  }
}

/// Priority bucket — survives a round-trip via [NotificationPriority.name].
enum NotificationPriority { low, normal, high }

/// One notification delivered to the signed-in user (Phase 48).
///
/// Fields beyond the original five (id, title, message, createdAtIso,
/// routeName, isRead) are optional so every pre-Phase 48 constructor
/// call site stays valid.
@immutable
class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAtIso,
    this.routeName,
    this.isRead = false,
    this.type = NotificationType.generic,
    this.imageUrl,
    this.deepLink,
    this.priority = NotificationPriority.normal,
    this.expiresAtIso,
    this.payload = const <String, dynamic>{},
  });

  final String id;
  final String title;
  final String message;
  final String createdAtIso;
  final String? routeName;
  final bool isRead;
  final NotificationType type;
  final String? imageUrl;
  final String? deepLink;
  final NotificationPriority priority;
  final String? expiresAtIso;
  final Map<String, dynamic> payload;

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? message,
    String? createdAtIso,
    String? routeName,
    bool clearRoute = false,
    bool? isRead,
    NotificationType? type,
    String? imageUrl,
    bool clearImageUrl = false,
    String? deepLink,
    bool clearDeepLink = false,
    NotificationPriority? priority,
    String? expiresAtIso,
    bool clearExpiresAt = false,
    Map<String, dynamic>? payload,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAtIso: createdAtIso ?? this.createdAtIso,
      routeName: clearRoute ? null : (routeName ?? this.routeName),
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
      deepLink: clearDeepLink ? null : (deepLink ?? this.deepLink),
      priority: priority ?? this.priority,
      expiresAtIso: clearExpiresAt ? null : (expiresAtIso ?? this.expiresAtIso),
      payload: payload ?? this.payload,
    );
  }
}
