import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/features/quiz_api/data/models/quiz_question_model.dart';

void main() {
  group('QuizQuestionModel.fromJson', () {
    test('parses a full question payload', () {
      final model = QuizQuestionModel.fromJson(<String, dynamic>{
        'id': 11,
        'categoryId': 1,
        'question': 'What is Flutter?',
        'options': <String>['Framework', 'Database', 'Browser', 'OS'],
        'answerIndex': 0,
        'mark': 10,
      });

      expect(model.id, '11');
      expect(model.categoryId, '1');
      expect(model.prompt, 'What is Flutter?');
      expect(model.options, <String>['Framework', 'Database', 'Browser', 'OS']);
      expect(model.answerIndex, 0);
      expect(model.mark, 10);
    });

    test('parses an envelope and unwraps data', () {
      final model = QuizQuestionModel.fromApiResponse(<String, dynamic>{
        'success': true,
        'data': <String, dynamic>{
          'id': 22,
          'categoryId': 3,
          'question': '2 + 2 = ?',
          'options': <String>['3', '4', '5'],
          'answerIndex': 1,
          'mark': 5,
        },
      });

      expect(model.id, '22');
      expect(model.categoryId, '3');
      expect(model.prompt, '2 + 2 = ?');
      expect(model.answerIndex, 1);
    });

    test('falls back to safe defaults for missing fields', () {
      final model = QuizQuestionModel.fromJson(<String, dynamic>{
        'id': 7,
      });

      expect(model.prompt, '');
      expect(model.options, isEmpty);
      expect(model.answerIndex, 0);
      expect(model.mark, 1);
      expect(model.categoryId, '');
    });

    test('filters out empty option strings', () {
      final model = QuizQuestionModel.fromJson(<String, dynamic>{
        'id': 8,
        'options': <String>['Yes', '', null as String? ?? ''],
        'answerIndex': 0,
        'mark': 1,
      });

      expect(model.options, <String>['Yes']);
    });
  });

  group('QuizQuestionModel.toEntity', () {
    test('produces a QuizQuestionEntity with the right flags', () {
      final model = QuizQuestionModel.fromJson(<String, dynamic>{
        'id': 5,
        'categoryId': 2,
        'question': 'Capital of France?',
        'options': <String>['Paris', 'London'],
        'answerIndex': 0,
        'mark': 2,
      });

      final entity = model.toEntity();
      expect(entity.id, '5');
      expect(entity.answerIndex, 0);
      expect(entity.options, <String>['Paris', 'London']);
      expect(entity.isCorrect(0), isTrue);
      expect(entity.isCorrect(1), isFalse);
      expect(entity.mark, 2);
    });
  });
}
