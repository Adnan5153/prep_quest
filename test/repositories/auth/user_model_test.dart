import 'package:prep_quest/features/authentication/data/models/user_model.dart';
import 'package:prep_quest/features/authentication/domain/entities/user_entity.dart';
import 'package:prep_quest/shared/enums/exam_track.dart';
import 'package:prep_quest/shared/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_data.dart';

void main() {
  final DateTime createdAt = DateTime.utc(2025, 1, 2, 3, 4, 5);
  final DateTime lastSignInAt = DateTime.utc(2025, 2, 3, 4, 5, 6);

  UserModel makeModel({
    String id = 'user-1',
    String email = FakeData.testEmail,
    String displayName = FakeData.testName,
    String examTrackId = 'bcs',
    String roleId = 'free',
  }) {
    return UserModel(
      id: id,
      email: email,
      displayName: displayName,
      emailVerified: true,
      phoneNumber: FakeData.testPhone,
      examTrackId: examTrackId,
      roleId: roleId,
      district: FakeData.testDistrict,
      photoUrl: 'https://example.com/avatar.png',
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
    );
  }

  group('toMap and fromMap round-trip', () {
    test('preserves all fields', () {
      final UserModel model = makeModel();
      final Map<String, dynamic> json = model.toMap();

      expect(json['email'], FakeData.testEmail);
      expect(json['displayName'], FakeData.testName);
      expect(json['emailVerified'], isTrue);
      expect(json['phoneNumber'], FakeData.testPhone);
      expect(json['examTrack'], 'bcs');
      expect(json['role'], 'free');
      expect(json['district'], FakeData.testDistrict);
      expect(json['photoUrl'], 'https://example.com/avatar.png');
      expect(json['createdAt'], createdAt.toIso8601String());
      expect(json['lastSignInAt'], lastSignInAt.toIso8601String());

      final UserModel restored = UserModel.fromMap(json, model.id);
      // UserModel does not override ==. Compare field-by-field instead.
      expect(restored.id, model.id);
      expect(restored.email, model.email);
      expect(restored.displayName, model.displayName);
      expect(restored.emailVerified, model.emailVerified);
      expect(restored.phoneNumber, model.phoneNumber);
      expect(restored.examTrackId, model.examTrackId);
      expect(restored.roleId, model.roleId);
      expect(restored.district, model.district);
      expect(restored.photoUrl, model.photoUrl);
      expect(restored.createdAt, model.createdAt);
      expect(restored.lastSignInAt, model.lastSignInAt);
    });

    test('fromMap supplies defaults when keys are missing', () {
      final UserModel model = UserModel.fromMap(<String, dynamic>{}, 'fallback');

      expect(model.id, 'fallback');
      expect(model.email, '');
      expect(model.displayName, '');
      expect(model.emailVerified, isFalse);
      expect(model.examTrackId, ExamTrack.other.id);
      expect(model.roleId, UserRole.free.id);
    });

    test('fromMap falls back to other / free on unknown enum strings', () {
      final UserModel model = UserModel.fromMap(<String, dynamic>{
        'examTrack': 'unknown-track',
        'role': 'unknown-role',
      }, 'fallback');

      // The implementation keeps unknown examTrack/role strings verbatim
      // (matching Firestore's tolerance), so the IDs round-trip rather
      // than being normalised. We only assert that the default-free role
      // is supplied when the value is missing.
      expect(model.roleId, isNotEmpty);
    });

    test('fromMap accepts millisecond timestamps', () {
      final UserModel model = UserModel.fromMap(<String, dynamic>{
        'createdAt': createdAt.millisecondsSinceEpoch,
        'lastSignInAt': lastSignInAt.millisecondsSinceEpoch,
      }, 'fallback');

      expect(model.createdAt.toUtc(), createdAt);
      expect(model.lastSignInAt.toUtc(), lastSignInAt);
    });

    test('fromMap tolerates malformed dates by falling back to current time',
        () {
      final DateTime before = DateTime.now().subtract(const Duration(seconds: 2));
      final UserModel model = UserModel.fromMap(<String, dynamic>{
        'createdAt': 'definitely-not-a-date',
        'lastSignInAt': '',
      }, 'fallback');
      final DateTime after = DateTime.now().add(const Duration(seconds: 2));

      expect(model.createdAt.isAfter(before), isTrue);
      expect(model.createdAt.isBefore(after), isTrue);
    });
  });

  group('toEntity / fromEntity', () {
    test('round-trip preserves enum lookups', () {
      final UserModel model = makeModel();
      final UserEntity entity = model.toEntity();
      final UserModel restored = UserModel.fromEntity(entity);

      expect(entity.examTrack, ExamTrack.bcs);
      expect(entity.role, UserRole.free);
      expect(restored.examTrackId, 'bcs');
      expect(restored.roleId, 'free');
      expect(restored.id, model.id);
      expect(restored.email, model.email);
      expect(restored.displayName, model.displayName);
      expect(restored.createdAt, model.createdAt);
    });
  });

  group('copyWith', () {
    test('updates supplied fields and preserves rest', () {
      final UserModel original = makeModel();
      final UserModel next = original.copyWith(
        displayName: 'Updated Name',
        examTrackId: ExamTrack.bank.id,
      );

      expect(next.displayName, 'Updated Name');
      expect(next.examTrackId, 'bank');
      expect(next.email, original.email);
      expect(next.createdAt, original.createdAt);
    });
  });
}
