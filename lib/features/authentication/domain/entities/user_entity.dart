import 'package:flutter/foundation.dart';

import '../../../../shared/enums/exam_track.dart';
import '../../../../shared/enums/user_role.dart';

/// Immutable representation of an authenticated Prep Quest user.
///
/// Pure-domain object: no Firebase, JSON, or storage concerns. Models
/// in `data/models` are responsible for the conversions.
@immutable
class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    required this.emailVerified,
    required this.phoneNumber,
    required this.examTrack,
    required this.role,
    required this.district,
    required this.photoUrl,
    required this.createdAt,
    required this.lastSignInAt,
  });

  final String id;
  final String email;
  final String displayName;
  final bool emailVerified;
  final String phoneNumber;
  final ExamTrack examTrack;
  final UserRole role;
  final String district;
  final String photoUrl;
  final DateTime createdAt;
  final DateTime lastSignInAt;

  bool get hasCompletedProfile =>
      displayName.trim().isNotEmpty && examTrack != ExamTrack.other;

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    bool? emailVerified,
    String? phoneNumber,
    ExamTrack? examTrack,
    UserRole? role,
    String? district,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastSignInAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      examTrack: examTrack ?? this.examTrack,
      role: role ?? this.role,
      district: district ?? this.district,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.email == email &&
        other.displayName == displayName &&
        other.emailVerified == emailVerified &&
        other.phoneNumber == phoneNumber &&
        other.examTrack == examTrack &&
        other.role == role &&
        other.district == district &&
        other.photoUrl == photoUrl &&
        other.createdAt == createdAt &&
        other.lastSignInAt == lastSignInAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        email,
        displayName,
        emailVerified,
        phoneNumber,
        examTrack,
        role,
        district,
        photoUrl,
        createdAt,
        lastSignInAt,
      );
}