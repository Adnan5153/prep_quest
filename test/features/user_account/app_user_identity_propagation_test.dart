import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/features/user_account/data/datasources/app_user_local_datasource.dart';
import 'package:prep_quest/features/user_account/data/datasources/mock_app_user_local_datasource.dart';
import 'package:prep_quest/features/user_account/data/datasources/mock_app_user_remote_datasource.dart';
import 'package:prep_quest/features/user_account/data/models/app_user_model.dart';
import 'package:prep_quest/features/user_account/data/repositories/app_user_repository_impl.dart';
import 'package:prep_quest/features/user_account/domain/entities/app_user_entity.dart';
import 'package:prep_quest/features/user_account/domain/entities/auth_identity_seed.dart';
import 'package:prep_quest/shared/enums/exam_track.dart';

/// In-memory [AppUserLocalDataSource] for tests. Skips the latency
/// from [MockAppUserLocalDataSource] so the assertions stay
/// deterministic.
class _InMemoryAppUserLocalDataSource implements AppUserLocalDataSource {
  AppUserModel? _stored;

  @override
  Future<AppUserModel?> read() async => _stored;

  @override
  Future<void> write(AppUserModel model) async {
    _stored = model;
  }

  @override
  Future<void> clear() async {
    _stored = null;
  }
}

AuthIdentitySeed _seed({
  String displayName = 'Jane Doe',
  String email = 'jane@example.com',
  bool emailVerified = true,
  String phoneNumber = '+15555550100',
  String photoUrl = 'https://example.com/avatar.png',
  DateTime? createdAt,
}) {
  return AuthIdentitySeed(
    displayName: displayName,
    email: email,
    emailVerified: emailVerified,
    phoneNumber: phoneNumber,
    photoUrl: photoUrl,
    createdAt: createdAt ?? DateTime.utc(2024, 1, 1),
  );
}

void main() {
  group('MockAppUserRemoteDataSource.fetchOrCreate', () {
    test('seeds a new document from the supplied identity', () async {
      final MockAppUserRemoteDataSource remote =
          MockAppUserRemoteDataSource(latency: Duration.zero);
      final AuthIdentitySeed identity = _seed();

      final AppUserModel model =
          await remote.fetchOrCreate('uid-1', identity: identity);

      expect(model.id, 'uid-1');
      expect(model.displayName, 'Jane Doe');
      expect(model.email, 'jane@example.com');
      expect(model.emailVerified, isTrue);
      expect(model.phoneNumber, '+15555550100');
      expect(model.photoUrl, 'https://example.com/avatar.png');
      expect(model.createdAt, DateTime.utc(2024, 1, 1));
    });

    test('returns an empty profile when identity is null', () async {
      final MockAppUserRemoteDataSource remote =
          MockAppUserRemoteDataSource(latency: Duration.zero);

      final AppUserModel model = await remote.fetchOrCreate('uid-2');

      expect(model.id, 'uid-2');
      expect(model.displayName, isEmpty);
      expect(model.email, isEmpty);
      expect(model.emailVerified, isFalse);
      expect(model.photoUrl, isEmpty);
    });

    test(
        'backfills empty identity fields when a previously-stored '
        'document is loaded with a real identity on re-login',
        () async {
      final MockAppUserRemoteDataSource remote =
          MockAppUserRemoteDataSource(latency: Duration.zero);

      // First sign-in created the doc with no identity at all
      // (legacy code path).
      final AppUserModel first = await remote.fetchOrCreate('uid-3');
      expect(first.displayName, isEmpty);

      // Later, Firebase re-emits an identity-bearing user (e.g.
      // after a token refresh). The document should be backfilled,
      // not overwritten.
      final AuthIdentitySeed identity = _seed(
        displayName: 'Real Name',
        email: 'real@example.com',
        photoUrl: 'https://example.com/me.png',
      );
      final AppUserModel second =
          await remote.fetchOrCreate('uid-3', identity: identity);

      expect(second.id, 'uid-3');
      expect(second.displayName, 'Real Name');
      expect(second.email, 'real@example.com');
      expect(second.photoUrl, 'https://example.com/me.png');
    });

    test(
        'preserves user-edited profile fields and only fills truly '
        'empty identity fields', () async {
      final MockAppUserRemoteDataSource remote =
          MockAppUserRemoteDataSource(latency: Duration.zero);

      // Seed with no identity.
      final AppUserModel first = await remote.fetchOrCreate('uid-4');
      expect(first.displayName, isEmpty);
      // Simulate the user editing their profile (e.g. setting a
      // displayName manually).
      await remote.patch('uid-4', <String, dynamic>{
        'displayName': 'User Edited Name',
      });

      // Re-login with an identity that also has a displayName — the
      // existing non-empty value must NOT be overwritten.
      final AppUserModel second = await remote.fetchOrCreate(
        'uid-4',
        identity: _seed(displayName: 'Identity Provided Name'),
      );
      expect(second.displayName, 'User Edited Name');
      // But identity fields the user never touched are still
      // backfilled.
      expect(second.email, 'jane@example.com');
    });
  });

  group('AppUserRepositoryImpl.onSignedIn', () {
    test('passes the identity seed through to the remote datasource',
        () async {
      final MockAppUserRemoteDataSource remote =
          MockAppUserRemoteDataSource(latency: Duration.zero);
      final _InMemoryAppUserLocalDataSource local =
          _InMemoryAppUserLocalDataSource();

      final AppUserRepositoryImpl repo =
          AppUserRepositoryImpl(remote: remote, local: local);
      addTearDown(repo.dispose);

      await repo.onSignedIn('uid-5', identity: _seed());

      final AppUserModel? cached = await local.read();
      expect(cached, isNotNull);
      expect(cached!.displayName, 'Jane Doe');
      expect(cached.email, 'jane@example.com');
      expect(cached.photoUrl, 'https://example.com/avatar.png');
      expect(cached.emailVerified, isTrue);
    });

    test('currentUser is null before any sign-in and populated after',
        () async {
      final MockAppUserRemoteDataSource remote =
          MockAppUserRemoteDataSource(latency: Duration.zero);
      final AppUserRepositoryImpl repo = AppUserRepositoryImpl(
        remote: remote,
        local: _InMemoryAppUserLocalDataSource(),
      );
      addTearDown(repo.dispose);

      expect(repo.currentUser, isNull);

      await repo.onSignedIn('uid-6', identity: _seed(displayName: 'Hi'));
      expect(repo.currentUser, isNotNull);
      expect(repo.currentUser!.displayName, 'Hi');
    });

    test(
        're-signing in with an identity backfills existing empty '
        'fields without losing prior progression', () async {
      final MockAppUserRemoteDataSource remote =
          MockAppUserRemoteDataSource(latency: Duration.zero);
      final AppUserRepositoryImpl repo = AppUserRepositoryImpl(
        remote: remote,
        local: _InMemoryAppUserLocalDataSource(),
      );
      addTearDown(repo.dispose);

      // First sign-in: identity is null (legacy flow) and the user
      // accumulates some progression.
      await repo.onSignedIn('uid-7');
      await repo.applyProgression(
        repo.currentUser!.copyWith(progression: repo.currentUser!.progression
            .copyWith(totalXp: 1234, coins: 56)),
      );
      expect(repo.currentUser!.progression.totalXp, 1234);
      expect(repo.currentUser!.displayName, isEmpty);

      // Second sign-in: Firebase now provides the real identity.
      await repo.onSignedIn(
        'uid-7',
        identity: _seed(displayName: 'Returning User'),
      );
      // Progression is preserved (still 1234 XP / 56 coins).
      expect(repo.currentUser!.progression.totalXp, 1234);
      expect(repo.currentUser!.progression.coins, 56);
      // Identity fields are backfilled.
      expect(repo.currentUser!.displayName, 'Returning User');
    });
  });

  group('AppUserModel.fromMap', () {
    test(
        'reads a legacy sparse doc (only the 8 fields written by the '
        'older auth feature) without losing identity', () {
      // This matches the exact Firestore shape Yeasin Ahmed's account
      // had in the field — only 8 fields, written by the previous
      // version of FirebaseAuthRemoteDataSource which used `examTrack`
      // (not `examTrackId`) and `role` (not `roleId`).
      final AppUserModel model = AppUserModel.fromMap(
        <String, dynamic>{
          'createdAt': '2026-07-28T13:58:19.953Z',
          'displayName': 'Yeasin Ahmed',
          'district': '',
          'email': 'adnan.yeasin@gmail.com',
          'emailVerified': true,
          'examTrack': 'bcs',
          'lastSignInAt': '2026-07-28T15:02:26.944Z',
          'phoneNumber': '',
          'photoUrl': 'https://lh3.googleusercontent.com/example',
          'role': 'free',
        },
      );

      expect(model.id, '');
      expect(model.displayName, 'Yeasin Ahmed');
      expect(model.email, 'adnan.yeasin@gmail.com');
      expect(model.emailVerified, isTrue);
      expect(model.photoUrl, 'https://lh3.googleusercontent.com/example');
      // The legacy `examTrack` field should map onto `examTrackId`.
      expect(model.examTrackId, ExamTrack.bcs.id);
      // Same for `role` → `roleId`.
      expect(model.roleId, 'free');
      // The doc had no `quickActions`, but the canonical defaults
      // still appear in the read so the home-screen grid doesn't
      // collapse to nothing.
      expect(model.quickActions, contains('mock_test'));
      expect(model.quickActions, contains('leaderboard'));
    });

    test(
        'preserves an explicitly empty quickActions list (user-opted-'
        'out) and only falls back when the field is absent', () {
      final AppUserModel populated = AppUserModel.fromMap(
        <String, dynamic>{
          'quickActions': <String>[],
        },
      );
      expect(populated.quickActions, isEmpty);

      final AppUserModel absent = AppUserModel.fromMap(
        <String, dynamic>{},
      );
      expect(absent.quickActions, contains('resume'));
    });
  });

  group('AppUserRepositoryImpl.recordQuizCompletion', () {
    test(
        'persists progression, studyStats, and completedQuizzes '
        'together in a single patch (so they cannot drift apart '
        'across sign-ins)', () async {
      final MockAppUserRemoteDataSource remote =
          MockAppUserRemoteDataSource(latency: Duration.zero);
      final _InMemoryAppUserLocalDataSource local =
          _InMemoryAppUserLocalDataSource();

      final AppUserRepositoryImpl repo = AppUserRepositoryImpl(
        remote: remote,
        local: local,
      );
      addTearDown(repo.dispose);

      await repo.onSignedIn('uid-8', identity: _seed());
      final AppUserEntity before = repo.currentUser!;
      // Baseline sanity — everything is zero before the quiz.
      expect(before.progression.totalXp, 0);
      expect(before.studyStats.totalQuizzesTaken, 0);
      expect(before.completedQuizzes, 0);

      // After completing a quiz, all three sub-objects must advance
      // together — XP from the rewards subsystem, studyStats
      // counters, and the at-a-glance completedQuizzes counter.
      final AppUserEntity after = await repo.recordQuizCompletion(
        nextProgression: before.progression.copyWith(totalXp: 250, coins: 30),
        nextStudyStats: before.studyStats.copyWith(
          totalQuizzesTaken: 1,
          totalQuestionsAnswered: 10,
          totalCorrectAnswers: 7,
          totalStudyMinutes: 4,
          averageAccuracy: 0.7,
          longestStreakDays: 2,
        ),
        completedQuizzes: 1,
      );

      expect(after.progression.totalXp, 250);
      expect(after.progression.coins, 30);
      expect(after.studyStats.totalQuizzesTaken, 1);
      expect(after.studyStats.totalQuestionsAnswered, 10);
      expect(after.studyStats.totalCorrectAnswers, 7);
      expect(after.studyStats.averageAccuracy, closeTo(0.7, 1e-9));
      expect(after.studyStats.longestStreakDays, 2);
      expect(after.completedQuizzes, 1);
    });

    test(
        'progress accumulates across repeated quiz completions and '
        'survives a re-sign-in (the bug that motivated this fix)',
        () async {
      final MockAppUserRemoteDataSource remote =
          MockAppUserRemoteDataSource(latency: Duration.zero);
      final _InMemoryAppUserLocalDataSource local =
          _InMemoryAppUserLocalDataSource();

      final AppUserRepositoryImpl repo = AppUserRepositoryImpl(
        remote: remote,
        local: local,
      );
      addTearDown(repo.dispose);

      await repo.onSignedIn('uid-9', identity: _seed());
      AppUserEntity baseline = repo.currentUser!;

      // First quiz.
      baseline = await repo.recordQuizCompletion(
        nextProgression: baseline.progression.copyWith(totalXp: 100),
        nextStudyStats: baseline.studyStats.copyWith(
          totalQuizzesTaken: 1,
          totalQuestionsAnswered: 5,
          totalCorrectAnswers: 4,
          averageAccuracy: 0.8,
        ),
        completedQuizzes: 1,
      );
      expect(baseline.progression.totalXp, 100);
      expect(baseline.completedQuizzes, 1);

      // Second quiz — counters MUST advance, not reset.
      baseline = await repo.recordQuizCompletion(
        nextProgression: baseline.progression.copyWith(totalXp: 250, coins: 20),
        nextStudyStats: baseline.studyStats.copyWith(
          totalQuizzesTaken: 2,
          totalQuestionsAnswered: 10,
          totalCorrectAnswers: 8,
          averageAccuracy: 0.8,
        ),
        completedQuizzes: 2,
      );
      expect(baseline.progression.totalXp, 250);
      expect(baseline.progression.coins, 20);
      expect(baseline.studyStats.totalQuizzesTaken, 2);
      expect(baseline.completedQuizzes, 2);

      // Simulate the user re-signing in. A fresh repo backed by the
      // same datasource must observe the same accumulated state, not
      // a fresh zero baseline.
      repo.onSignedOut();
      await repo.onSignedIn('uid-9', identity: _seed());
      final AppUserEntity reloaded = repo.currentUser!;
      expect(reloaded.progression.totalXp, 250);
      expect(reloaded.progression.coins, 20);
      expect(reloaded.studyStats.totalQuizzesTaken, 2);
      expect(reloaded.studyStats.totalQuestionsAnswered, 10);
      expect(reloaded.studyStats.totalCorrectAnswers, 8);
      expect(reloaded.completedQuizzes, 2);
    });
  });
}
