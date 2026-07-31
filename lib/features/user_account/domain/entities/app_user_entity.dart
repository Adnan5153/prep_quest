import 'package:flutter/foundation.dart';

import '../../../profile/domain/entities/user_profile.dart';

/// Domain entity for an app user.
///
/// A new, slim representation of the user profile scoped to the
/// `user_account` feature. Decouples the account repository from the
/// `profile` feature so sign-in can populate state without depending
/// on the profile presentation layer.
@immutable
class AppUserEntity {
  const AppUserEntity({
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
  final ProgressionEntity progression;
  final StudyStatsEntity studyStats;
  final List<String> quickActions;
  final int completedQuizzes;

  AppUserEntity copyWith({
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
    ProgressionEntity? progression,
    StudyStatsEntity? studyStats,
    List<String>? quickActions,
    int? completedQuizzes,
  }) {
    return AppUserEntity(
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