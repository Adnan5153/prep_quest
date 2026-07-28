import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/core/widgets/ai/ai_hint_card/ai_hint_card.dart';
import 'package:prep_quest/core/widgets/ai/ai_hint_card/ai_hint_constants.dart';

void main() {
  testWidgets('AiHintCard renders title and hint text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AiHintCard(
            title: 'Test Title',
            hint: 'This is a test hint description.',
            type: AiHintType.quickTip,
          ),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('This is a test hint description.'), findsOneWidget);
    expect(find.text('AI Analysis'), findsOneWidget);
  });

  testWidgets('AiHintCard displays meta info when provided', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AiHintCard(
            title: 'Title',
            hint: 'Hint',
            topic: 'Dart Programming',
            difficulty: AiHintDifficulty.intermediate,
            quickTip: 'Use final for immutable variables.',
          ),
        ),
      ),
    );

    expect(find.text('Dart Programming'), findsOneWidget);
    expect(find.text('INTERMEDIATE'), findsOneWidget);
    expect(find.text('Use final for immutable variables.'), findsOneWidget);
  });
}
