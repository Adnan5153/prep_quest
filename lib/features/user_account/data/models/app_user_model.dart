import 'package:flutter/foundation.dart';

import '../../../../shared/enums/exam_track.dart';
import '../../../profile/data/models/user_profile_model.dart';
import '../../domain/entities/app_user_entity.dart';

/// Canonical list of home-screen quick actions when the field is
/// missing from the persisted user document. Used by [fromMap].
const List<String> kDefaultQuickActions = <String>[
  'resume',
  'mock_test',
  'leaderboard',
];

/// Data-layer model for [AppUserEntity].
///
/// Knows how to read Firestore's legacy sparse-doc shape (only the 8
/// fields written by the older auth feature) and remap them onto the
/// richer entity shape used by the rest of the app.
@immutable
class AppUserModel {
  const AppUserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.emailVerified,
    required this.phoneNumber,
    required this.examTrackId,
    required this.roleId,
    required this.district,
    required this.photoUrl,
    required this.createdAt,
    required this.lastSignInAt,
    required this.progression,
    required this.studyStats,
    required this.quickActions,
    this.completedQuizzes = 0,
  });

  final String id;
  final String displayName;
  final String email;
  final bool emailVerified;
  final String phoneNumber;
  final String examTrackId;
  final String roleId;
  final String district;
  final String photoUrl;
  final DateTime createdAt;
  final DateTime lastSignInAt;
  final ProgressionModel progression;
  final StudyStatsModel studyStats;
  final List<String> quickActions;
  final int completedQuizzes;

  AppUserEntity toEntity() {
    return AppUserEntity(
      id: id,
      displayName: displayName,
      email: email,
      emailVerified: emailVerified,
      phoneNumber: phoneNumber,
      examTrackId: examTrackId,
      roleId: roleId,
      district: district,
      photoUrl: photoUrl,
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
      progression: progression.toEntity(),
      studyStats: studyStats.toEntity(),
      quickActions: List<String>.unmodifiable(quickActions),
      completedQuizzes: completedQuizzes,
    );
  }

  factory AppUserModel.fromEntity(AppUserEntity entity) {
    return AppUserModel(
      id: entity.id,
      displayName: entity.displayName,
      email: entity.email,
      emailVerified: entity.emailVerified,
      phoneNumber: entity.phoneNumber,
      examTrackId: entity.examTrackId,
      roleId: entity.roleId,
      district: entity.district,
      photoUrl: entity.photoUrl,
      createdAt: entity.createdAt,
      lastSignInAt: entity.lastSignInAt,
      progression: ProgressionModel.fromEntity(entity.progression),
      studyStats: StudyStatsModel.fromEntity(entity.studyStats),
      quickActions: List<String>.unmodifiable(entity.quickActions),
      completedQuizzes: entity.completedQuizzes,
    );
  }

  /// Reads a Firestore-shaped map into the model.
  ///
  /// Accepts both the modern field names (`examTrackId`, `roleId`,
  /// `progression`, `studyStats`) and the legacy names (`examTrack`,
  /// `role`) so existing documents keep working after the rename.
  ///
  /// When `quickActions` is absent, the canonical defaults are
  /// supplied; when explicitly empty, the user's choice to opt-out
  /// is preserved.
  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    final String examTrack = (map['examTrackId'] as String?) ??
        (map['examTrack'] as String?) ??
        ExamTrack.other.id;
    final String role =
        (map['roleId'] as String?) ?? (map['role'] as String?) ?? 'free';

    final DateTime now = DateTime.now();
    final DateTime createdAt =
        DateTime.tryParse(map['createdAt'] as String? ?? '')?.toLocal() ??
            now;
    final DateTime lastSignInAt =
        DateTime.tryParse(map['lastSignInAt'] as String? ?? '')?.toLocal() ??
            now;

    final List<String> quickActions;
    final Object? rawQuick = map['quickActions'];
    if (rawQuick is List) {
      quickActions = rawQuick.whereType<String>().toList(growable: false);
    } else {
      quickActions = List<String>.unmodifiable(kDefaultQuickActions);
    }

    return AppUserModel(
      id: map['id'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      emailVerified: map['emailVerified'] as bool? ?? false,
      phoneNumber: map['phoneNumber'] as String? ?? '',
      examTrackId: examTrack,
      roleId: role,
      district: map['district'] as String? ?? '',
      photoUrl: map['photoUrl'] as String? ?? '',
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
      progression: ProgressionModel.fromMap(
        (map['progression'] as Map<String, dynamic>?) ??
            const <String, dynamic>{},
      ),
      studyStats: StudyStatsModel.fromMap(
        (map['studyStats'] as Map<String, dynamic>?) ??
            const <String, dynamic>{},
      ),
      quickActions: quickActions,
      completedQuizzes:
          (map['completedQuizzes'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'displayName': displayName,
      'email': email,
      'emailVerified': emailVerified,
      'phoneNumber': phoneNumber,
      'examTrackId': examTrackId,
      'roleId': roleId,
      'district': district,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'lastSignInAt': lastSignInAt.toUtc().toIso8601String(),
      'progression': progression.toMap(),
      'studyStats': studyStats.toMap(),
      'quickActions': quickActions,
      'completedQuizzes': completedQuizzes,
    };
  }

  AppUserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    bool? emailVerified,
    String? phoneNumber,
    String? examTrackId,
    String? roleId,
    String? district,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastSignInAt,
    ProgressionModel? progression,
    StudyStatsModel? studyStats,
    List<String>? quickActions,
    int? completedQuizzes,
  }) {
    return AppUserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      examTrackId: examTrackId ?? this.examTrackId,
      roleId: roleId ?? this.roleId,
      district: district ?? this.district,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      progression: progression ?? this.progression,
      studyStats: studyStats ?? this.studyStats,
      quickActions: quickActions ?? this.quickActions,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
    );
  }
}