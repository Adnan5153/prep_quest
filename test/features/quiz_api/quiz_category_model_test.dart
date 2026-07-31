import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/features/quiz_api/data/models/quiz_category_model.dart';

void main() {
  group('QuizCategoryModel.fromJson', () {
    test('parses a category envelope', () {
      final model = QuizCategoryModel.fromApiResponse(<String, dynamic>{
        'success': true,
        'data': <String, dynamic>{
          'id': 1,
          'name': 'General Knowledge',
          'description': 'General knowledge questions',
        },
      });

      expect(model.id, '1');
      expect(model.name, 'General Knowledge');
      expect(model.description, 'General knowledge questions');
    });

    test('parses a bare category object', () {
      final model = QuizCategoryModel.fromApiResponse(<String, dynamic>{
        'id': 42,
        'name': 'Math',
      });

      expect(model.id, '42');
      expect(model.name, 'Math');
      expect(model.description, isNull);
    });

    test('trims name whitespace and falls back to empty string', () {
      final model = QuizCategoryModel.fromApiResponse(<String, dynamic>{
        'id': 7,
        'name': '   ',
      });

      expect(model.name, '');
    });
  });

  group('QuizCategoryModel.toJson', () {
    test('omits null description', () {
      final model = QuizCategoryModel(id: '1', name: 'Science');
      expect(model.toJson(), <String, dynamic>{'name': 'Science'});
    });

    test('includes description when present', () {
      final model = QuizCategoryModel(
        id: '1',
        name: 'Science',
        description: 'A topic',
      );
      expect(
        model.toJson(),
        <String, dynamic>{'name': 'Science', 'description': 'A topic'},
      );
    });
  });
}
