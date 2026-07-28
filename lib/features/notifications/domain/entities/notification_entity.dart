import 'package:flutter/foundation.dart';

/// One notification delivered to the signed-in user.
@immutable
class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAtIso,
    this.routeName,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String message;
  final String createdAtIso;
  final String? routeName;
  final bool isRead;

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? message,
    String? createdAtIso,
    String? routeName,
    bool clearRoute = false,
    bool? isRead,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAtIso: createdAtIso ?? this.createdAtIso,
      routeName: clearRoute ? null : (routeName ?? this.routeName),
      isRead: isRead ?? this.isRead,
    );
  }
}