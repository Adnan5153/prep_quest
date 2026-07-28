import 'dart:async';

import '../../../../shared/enums/exam_track.dart';
import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';
import 'profile_remote_datasource.dart';

/// In-memory profile data source.
///
/// Mirrors the surface of a Firestore `users/{uid}` document so the
/// production switch is a one-line provider override. The "database"
/// is reset on process restart.
class MockProfileRemoteDataSource implements ProfileRemoteDataSource {
  MockProfileRemoteDataSource({Duration? latency})
      : _latency = latency ?? const Duration(milliseconds: 600) {
    _bootstrap();
  }

  final Duration _latency;
  final StreamController<UserProfileModel> _controller =
      StreamController<UserProfileModel>.broadcast();
  UserProfileModel _profile = _emptyProfile();

  void _bootstrap() {
    final DateTime now = DateTime.now();
    _profile = UserProfileModel(
      id: 'demo-user',
      email: 'demo@prepquest.app',
      displayName: 'Demo Learner',
      emailVerified: true,
      phoneNumber: '+8801700000000',
      university: 'University of Dhaka',
      examTrackId: ExamTrack.bcs.id,
      languageId: ProfileLanguage.english.id,
      role: 'free',
      district: 'Dhaka',
      bio: 'Cramming for the 45th BCS preliminary.',
      photoUrl: '',
      progression: ProgressionModel(
        totalXp: 4820,
        level: 12,
        xpInLevel: 820,
        xpForNextLevel: 1000,
        coins: 1240,
        energy: 4,
        maxEnergy: 5,
        energyRechargeSecondsRemaining: 0,
        rankId: ProfileRank.silver.id,
        streakDays: 7,
        isStreakAtRisk: false,
      ),
      studyStats: StudyStatsModel(
        totalQuizzesTaken: 86,
        totalQuestionsAnswered: 1340,
        totalCorrectAnswers: 1080,
        totalStudyMinutes: 2640,
        currentStreakDays: 7,
        longestStreakDays: 21,
        averageAccuracy: 0.81,
        lastActiveAt: now.subtract(const Duration(hours: 6)),
      ),
      achievements: <AchievementModel>[
        AchievementModel(
          id: 'first-quiz',
          title: 'First Quiz',
          description: 'Completed your first quiz',
          iconName: 'check_circle',
          unlockedAt: now.subtract(const Duration(days: 30)),
          xpReward: 50,
          coinReward: 10,
        ),
        AchievementModel(
          id: 'seven-day-streak',
          title: '7-day Streak',
          description: 'Studied 7 days in a row',
          iconName: 'local_fire_department',
          unlockedAt: now.subtract(const Duration(days: 2)),
          xpReward: 200,
          coinReward: 50,
        ),
        AchievementModel(
          id: 'level-10',
          title: 'Level 10',
          description: 'Reached level 10',
          iconName: 'military_tech',
          unlockedAt: now.subtract(const Duration(days: 9)),
          xpReward: 150,
          coinReward: 30,
        ),
      ],
      badges: <BadgeModel>[
        BadgeModel(
          id: 'badge-fast-learner',
          name: 'Fast Learner',
          description: 'Complete a quiz in under 60 seconds',
          iconName: 'bolt',
          isEarned: true,
          progress: 1.0,
        ),
        BadgeModel(
          id: 'badge-perfectionist',
          name: 'Perfectionist',
          description: 'Score 100% on three quizzes',
          iconName: 'workspace_premium',
          isEarned: true,
          progress: 1.0,
        ),
        BadgeModel(
          id: 'badge-marathoner',
          name: 'Marathoner',
          description: 'Study for 5 hours in a single day',
          iconName: 'directions_run',
          isEarned: false,
          progress: 0.6,
        ),
        BadgeModel(
          id: 'badge-bookworm',
          name: 'Bookworm',
          description: 'Read 20 chapters',
          iconName: 'menu_book',
          isEarned: false,
          progress: 0.45,
        ),
        BadgeModel(
          id: 'badge-night-owl',
          name: 'Night Owl',
          description: 'Study after midnight',
          iconName: 'nightlight',
          isEarned: false,
          progress: 0.0,
        ),
        BadgeModel(
          id: 'badge-early-bird',
          name: 'Early Bird',
          description: 'Study before 7am',
          iconName: 'wb_sunny',
          isEarned: false,
          progress: 0.25,
        ),
      ],
      quickActions: <String>[
        'resume',
        'mock_test',
        'guidebook',
        'leaderboard',
        'ai_tutor',
        'missions',
        'streak',
        'search',
        'bookmarks',
        'notes',
      ],
      createdAt: now.subtract(const Duration(days: 60)),
      lastUpdatedAt: now,
    );
  }

  @override
  Future<UserProfileModel> fetchProfile() async {
    await _wait();
    return _profile;
  }

  @override
  Stream<UserProfileModel> watchProfile() async* {
    yield _profile;
    yield* _controller.stream;
  }

  @override
  Future<UserProfileModel> updateProfile({
    required String userId,
    required ProfileUpdateEntity update,
  }) async {
    await _wait();
    final UserProfileModel next = UserProfileModel(
      id: _profile.id,
      email: _profile.email,
      displayName: update.displayName,
      emailVerified: _profile.emailVerified,
      phoneNumber: _profile.phoneNumber,
      university: update.university,
      examTrackId: update.examTrack.id,
      languageId: update.language.id,
      role: _profile.role,
      district: update.district,
      bio: update.bio,
      photoUrl: _profile.photoUrl,
      progression: _profile.progression,
      studyStats: _profile.studyStats,
      achievements: _profile.achievements,
      badges: _profile.badges,
      quickActions: _profile.quickActions,
      createdAt: _profile.createdAt,
      lastUpdatedAt: DateTime.now(),
    );
    _profile = next;
    _controller.add(next);
    return next;
  }

  @override
  Future<UserProfileModel> uploadAvatar({
    required String userId,
    required String imagePath,
  }) async {
    await _wait();
    final UserProfileModel next = UserProfileModel(
      id: _profile.id,
      email: _profile.email,
      displayName: _profile.displayName,
      emailVerified: _profile.emailVerified,
      phoneNumber: _profile.phoneNumber,
      university: _profile.university,
      examTrackId: _profile.examTrackId,
      languageId: _profile.languageId,
      role: _profile.role,
      district: _profile.district,
      bio: _profile.bio,
      photoUrl: imagePath,
      progression: _profile.progression,
      studyStats: _profile.studyStats,
      achievements: _profile.achievements,
      badges: _profile.badges,
      quickActions: _profile.quickActions,
      createdAt: _profile.createdAt,
      lastUpdatedAt: DateTime.now(),
    );
    _profile = next;
    _controller.add(next);
    return next;
  }

  @override
  Future<void> deleteProfile({required String userId}) async {
    await _wait();
    _profile = _emptyProfile();
    _controller.add(_profile);
  }

  void dispose() {
    _controller.close();
  }

  Future<void> _wait() async {
    await Future<void>.delayed(_latency);
  }

  static UserProfileModel _emptyProfile() {
    final DateTime now = DateTime.now();
    return UserProfileModel(
      id: 'demo-user',
      email: '',
      displayName: '',
      emailVerified: false,
      phoneNumber: '',
      university: '',
      examTrackId: ExamTrack.other.id,
      languageId: ProfileLanguage.english.id,
      role: 'free',
      district: '',
      bio: '',
      photoUrl: '',
      progression: const ProgressionModel(
        totalXp: 0,
        level: 1,
        xpInLevel: 0,
        xpForNextLevel: 100,
        coins: 0,
        energy: 5,
        maxEnergy: 5,
        energyRechargeSecondsRemaining: 0,
        rankId: 'bronze',
        streakDays: 0,
        isStreakAtRisk: false,
      ),
      studyStats: StudyStatsModel(
        totalQuizzesTaken: 0,
        totalQuestionsAnswered: 0,
        totalCorrectAnswers: 0,
        totalStudyMinutes: 0,
        currentStreakDays: 0,
        longestStreakDays: 0,
        averageAccuracy: 0,
        lastActiveAt: now,
      ),
      achievements: const <AchievementModel>[],
      badges: const <BadgeModel>[],
      quickActions: const <String>[],
      createdAt: now,
      lastUpdatedAt: now,
    );
  }
}