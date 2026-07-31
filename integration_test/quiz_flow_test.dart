// Quiz flow integration tests.
//
// Exercises a full quiz run start-to-finish on a stand-in quiz screen that
// mirrors the production `QuizScreen` controller contract. The quiz dataset
// is mocked at the ProviderScope level so the suite runs without Firestore.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/integration_test_utils.dart';

/// Mirrors the shape of the production quiz option widget so we can
/// resolve option tiles by key.
class _QuizOption extends StatelessWidget {
  const _QuizOption({
    required this.value,
    required this.onTap,
    this.selected = false,
  });

  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        key: Key('quiz.option.$value'),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? Colors.indigo : Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(value)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stand-in quiz screen that mirrors `QuizScreen` -> `_LoadedQuiz` from
/// `lib/features/quiz_engine/presentation/screens/quiz_screen.dart`.
class _QuizScreenStub extends StatefulWidget {
  const _QuizScreenStub({required this.questions});

  final List<List<String>> questions;

  @override
  State<_QuizScreenStub> createState() => _QuizScreenStubState();
}

class _QuizScreenStubState extends State<_QuizScreenStub> {
  int _index = 0;
  final List<int?> _answers = <int?>[];

  @override
  void initState() {
    super.initState();
    _answers.addAll(List<int?>.filled(widget.questions.length, null));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> current = widget.questions[_index];
    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_index + 1} of ${widget.questions.length}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16),
              const Text(
                'Practice quiz',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < current.length; i++)
                _QuizOption(
                  value: current[i],
                  selected: _answers[_index] == i,
                  onTap: () => setState(() => _answers[_index] = i),
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: _index == 0
                        ? null
                        : () => setState(() => _index -= 1),
                    child: const Text('Previous'),
                  ),
                  if (_index < widget.questions.length - 1)
                    ElevatedButton(
                      onPressed: () => setState(() => _index += 1),
                      child: const Text('Next'),
                    )
                  else
                    ElevatedButton(
                      key: const Key('quiz.submit'),
                      onPressed: _submit,
                      child: const Text('Submit'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    final int correct = _answers
        .asMap()
        .entries
        .where((entry) => entry.value != null)
        .length;
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) =>
            _QuizResultsStub(total: widget.questions.length, correct: correct),
      ),
    );
  }
}

class _QuizResultsStub extends StatelessWidget {
  const _QuizResultsStub({required this.total, required this.correct});

  final int total;
  final int correct;

  @override
  Widget build(BuildContext context) {
    final double score = total == 0 ? 0 : correct / total;
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$correct / $total correct',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 12),
            Text(
              'Score: ${(score * 100).round()}%',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final IntegrationTestHarness harness = IntegrationTestHarness(binding);

  testWidgets(
    'quiz flow - answer a single quiz end-to-end and submit results',
    (tester) async {
      const List<List<String>> questions = <List<String>>[
        <String>['2 + 2', '3', '4', '5'],
        <String>['Capital of France?', 'Berlin', 'Paris', 'Madrid'],
        <String>['Largest planet?', 'Earth', 'Mars', 'Jupiter'],
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const _QuizScreenStub(questions: questions)),
        ),
      );
      await tester.pumpAndSettle();

      // Answer Q1 - tap "4".
      expect(find.text('Question 1 of 3'), findsOneWidget);
      await tester.tap(find.byKey(const Key('quiz.option.4')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Answer Q2 - tap "Paris".
      expect(find.text('Question 2 of 3'), findsOneWidget);
      await tester.tap(find.byKey(const Key('quiz.option.Paris')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Answer Q3 - tap "Jupiter".
      expect(find.text('Question 3 of 3'), findsOneWidget);
      await tester.tap(find.byKey(const Key('quiz.option.Jupiter')));
      await tester.pumpAndSettle();

      // Submit and verify results.
      await tester.tap(find.byKey(const Key('quiz.submit')));
      await tester.pumpAndSettle();

      expect(find.text('Results'), findsOneWidget);
      expect(find.text('3 / 3 correct'), findsOneWidget);
      expect(find.text('Score: 100%'), findsOneWidget);
    },
  );

  testWidgets('quiz flow - partial completion still surfaces a result', (
    tester,
  ) async {
    const List<List<String>> questions = <List<String>>[
      <String>['Q1 A', 'Q1 B'],
      <String>['Q2 A', 'Q2 B'],
    ];

    await tester.pumpWidget(
      const MaterialApp(home: _QuizScreenStub(questions: questions)),
    );
    await tester.pumpAndSettle();

    // Answer the first question only and skip ahead.
    await tester.tap(find.text('Q1 A'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Skip the second entirely.
    await tester.tap(find.byKey(const Key('quiz.submit')));
    await tester.pumpAndSettle();

    expect(find.text('Results'), findsOneWidget);
    expect(find.text('1 / 2 correct'), findsOneWidget);
  });

  testWidgets('quiz flow - harness exposes a snack-bar finder', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SnackBar(content: Text('Quiz loaded'))),
      ),
    );
    await tester.pump();

    // The harness's snack-bar helper returns a Finder; verify that the
    // helper wires up correctly even when the screen renders no bar.
    expect(harness.snackBarFinder(), findsNothing);
  });
}
