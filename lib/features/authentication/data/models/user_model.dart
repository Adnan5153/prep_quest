import '../../../../shared/enums/exam_track.dart';
import '../../../../shared/enums/user_role.dart';
import '../../domain/entities/user_entity.dart';

/// Data-layer transport model for [UserEntity].
///
/// Models are immutable from the domain's perspective. They expose
/// [toEntity] / [fromEntity] / [fromMap] / [toMap] so the data source
/// can serialise to JSON (or Firestore) without leaking the JSON
/// primitives back into the domain layer.
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.emailVerified,
    required this.phoneNumber,
    required this.examTrackId,
    required this.roleId,
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
  final String examTrackId;
  final String roleId;
  final String district;
  final String photoUrl;
  final DateTime createdAt;
  final DateTime lastSignInAt;

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName,
      emailVerified: emailVerified,
      phoneNumber: phoneNumber,
      examTrack: ExamTrack.fromId(examTrackId),
      role: UserRole.fromId(roleId),
      district: district,
      photoUrl: photoUrl,
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
    );
  }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      emailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
      examTrackId: user.examTrack.id,
      roleId: user.role.id,
      district: user.district,
      photoUrl: user.photoUrl,
      createdAt: user.createdAt,
      lastSignInAt: user.lastSignInAt,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: (map['email'] as String?)?.trim() ?? '',
      displayName: (map['displayName'] as String?)?.trim() ?? '',
      emailVerified: map['emailVerified'] as bool? ?? false,
      phoneNumber: (map['phoneNumber'] as String?)?.trim() ?? '',
      examTrackId: (map['examTrack'] as String?) ?? ExamTrack.other.id,
      roleId: (map['role'] as String?) ?? UserRole.free.id,
      district: (map['district'] as String?)?.trim() ?? '',
      photoUrl: (map['photoUrl'] as String?)?.trim() ?? '',
      createdAt: _dateFromMap(map['createdAt']) ?? DateTime.now(),
      lastSignInAt: _dateFromMap(map['lastSignInAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'displayName': displayName,
      'emailVerified': emailVerified,
      'phoneNumber': phoneNumber,
      'examTrack': examTrackId,
      'role': roleId,
      'district': district,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastSignInAt': lastSignInAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    bool? emailVerified,
    String? phoneNumber,
    String? examTrackId,
    String? roleId,
    String? district,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastSignInAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      examTrackId: examTrackId ?? this.examTrackId,
      roleId: roleId ?? this.roleId,
      district: district ?? this.district,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
    );
  }
}

DateTime? _dateFromMap(Object? value) {
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  return null;
}