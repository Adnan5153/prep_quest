import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/features/authentication/domain/entities/user_entity.dart';
import 'package:prep_quest/shared/enums/exam_track.dart';
import 'package:prep_quest/shared/enums/user_role.dart';

import '../../helpers/fake_data.dart';

void main() {
  final DateTime createdAt = DateTime.utc(2025, 1, 2, 3, 4, 5);
  final DateTime lastSignInAt = DateTime.utc(2025, 2, 3, 4, 5, 6);

  UserEntity makeUser({
    String displayName = FakeData.testName,
    ExamTrack examTrack = ExamTrack.bcs,
  }) {
    return UserEntity(
      id: 'user-1',
      email: FakeData.testEmail,
      displayName: displayName,
      emailVerified: true,
      phoneNumber: FakeData.testPhone,
      examTrack: examTrack,
      role: UserRole.free,
      district: FakeData.testDistrict,
      photoUrl: 'https://example.com/avatar.png',
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
    );
  }

  group('equality and hashCode', () {
    test('identical field values are equal', () {
      final UserEntity first = makeUser();
      final UserEntity second = makeUser();

      expect(first, equals(second));
      expect(first.hashCode, equals(second.hashCode));
    });

    test('different field values are not equal', () {
      expect(makeUser(), isNot(equals(makeUser(displayName: 'Other User'))));
    });

    test('supports identity equality', () {
      final UserEntity user = makeUser();
      expect(user, same(user));
    });
  });

  group('hasCompletedProfile', () {
    test('is true when name is non-blank and track is selected', () {
      expect(makeUser().hasCompletedProfile, isTrue);
    });

    test('is false when display name is blank', () {
      expect(makeUser(displayName: '   ').hasCompletedProfile, isFalse);
    });

    test('is false when exam track is other', () {
      expect(makeUser(examTrack: ExamTrack.other).hasCompletedProfile, isFalse);
    });
  });

  group('copyWith', () {
    test('creates a distinct instance preserving unchanged fields', () {
      final UserEntity original = makeUser();
      final UserEntity copied = original.copyWith();

      expect(copied, isNot(same(original)));
      expect(copied, equals(original));
    });

    test('updates every supplied field', () {
      final UserEntity original = makeUser();
      final DateTime newCreated = createdAt.add(const Duration(days: 1));
      final DateTime newSignIn = lastSignInAt.add(const Duration(days: 1));
      final UserEntity copied = original.copyWith(
        id: 'user-2',
        email: 'other@example.com',
        displayName: 'Other User',
        emailVerified: false,
        phoneNumber: '+8801812345678',
        examTrack: ExamTrack.bank,
        role: UserRole.premium,
        district: 'Chattogram',
        photoUrl: 'https://example.com/other.png',
        createdAt: newCreated,
        lastSignInAt: newSignIn,
      );

      expect(copied.id, 'user-2');
      expect(copied.email, 'other@example.com');
      expect(copied.displayName, 'Other User');
      expect(copied.emailVerified, isFalse);
      expect(copied.phoneNumber, '+8801812345678');
      expect(copied.examTrack, ExamTrack.bank);
      expect(copied.role, UserRole.premium);
      expect(copied.district, 'Chattogram');
      expect(copied.photoUrl, 'https://example.com/other.png');
      expect(copied.createdAt, newCreated);
      expect(copied.lastSignInAt, newSignIn);
      expect(original.id, 'user-1');
    });
  });
}
