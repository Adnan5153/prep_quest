import '../../domain/entities/notification_entity.dart';

/// JSON-ready persistence shape for [NotificationEntity].
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAtIso,
    required this.isRead,
    this.routeName,
  });

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      createdAtIso: entity.createdAtIso,
      routeName: entity.routeName,
      isRead: entity.isRead,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      message: (json['message'] as String?) ?? '',
      createdAtIso: (json['createdAtIso'] as String?) ?? '',
      routeName: json['routeName'] as String?,
      isRead: (json['isRead'] as bool?) ?? false,
    );
  }

  final String id;
  final String title;
  final String message;
  final String createdAtIso;
  final String? routeName;
  final bool isRead;

  NotificationEntity toEntity() => NotificationEntity(
        id: id,
        title: title,
        message: message,
        createdAtIso: createdAtIso,
        routeName: routeName,
        isRead: isRead,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'message': message,
        'createdAtIso': createdAtIso,
        'routeName': routeName,
        'isRead': isRead,
      };

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        id: id,
        title: title,
        message: message,
        createdAtIso: createdAtIso,
        routeName: routeName,
        isRead: isRead ?? this.isRead,
      );
}