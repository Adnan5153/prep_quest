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
    this.type = NotificationType.generic,
    this.imageUrl,
    this.deepLink,
    this.priority = NotificationPriority.normal,
    this.expiresAtIso,
    this.payload = const <String, dynamic>{},
  });

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      createdAtIso: entity.createdAtIso,
      routeName: entity.routeName,
      isRead: entity.isRead,
      type: entity.type,
      imageUrl: entity.imageUrl,
      deepLink: entity.deepLink,
      priority: entity.priority,
      expiresAtIso: entity.expiresAtIso,
      payload: entity.payload,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final String? priorityName = json['priority'] as String?;
    final NotificationPriority priority = NotificationPriority.values
        .firstWhere(
          (NotificationPriority p) => p.name == priorityName,
          orElse: () => NotificationPriority.normal,
        );
    final Map<String, dynamic>? rawPayload = json['payload'] as Map<String, dynamic>?;
    return NotificationModel(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      message: (json['message'] as String?) ?? '',
      createdAtIso: (json['createdAtIso'] as String?) ?? '',
      routeName: json['routeName'] as String?,
      isRead: (json['isRead'] as bool?) ?? false,
      type: NotificationTypeX.fromWire(json['type'] as String?),
      imageUrl: json['imageUrl'] as String?,
      deepLink: json['deepLink'] as String?,
      priority: priority,
      expiresAtIso: json['expiresAtIso'] as String?,
      payload: rawPayload ?? const <String, dynamic>{},
    );
  }

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

  NotificationEntity toEntity() => NotificationEntity(
        id: id,
        title: title,
        message: message,
        createdAtIso: createdAtIso,
        routeName: routeName,
        isRead: isRead,
        type: type,
        imageUrl: imageUrl,
        deepLink: deepLink,
        priority: priority,
        expiresAtIso: expiresAtIso,
        payload: payload,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'message': message,
        'createdAtIso': createdAtIso,
        'routeName': routeName,
        'isRead': isRead,
        'type': type.wireName,
        'imageUrl': imageUrl,
        'deepLink': deepLink,
        'priority': priority.name,
        'expiresAtIso': expiresAtIso,
        'payload': payload,
      };

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        id: id,
        title: title,
        message: message,
        createdAtIso: createdAtIso,
        routeName: routeName,
        isRead: isRead ?? this.isRead,
        type: type,
        imageUrl: imageUrl,
        deepLink: deepLink,
        priority: priority,
        expiresAtIso: expiresAtIso,
        payload: payload,
      );
}
