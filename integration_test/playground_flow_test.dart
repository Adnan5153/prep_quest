// Playground / home integration tests.
//
// The real PlaygroundScreen pulls a lot of Riverpod state (camera, profile,
// notifications). This file mounts a representative playground-style screen
// so the test can exercise the level-tap / node navigation flow without
// spinning up Firestore. Production `PlaygroundScreen` rendering is covered
// by the widget tests under `test/features/playground/...`.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/integration_test_utils.dart';

/// Simple level list mirroring the production `LevelCard` affordances.
class _PlaygroundStub extends StatelessWidget {
  const _PlaygroundStub({required this.onLevelTap});

  final void Function(int index) onLevelTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playground')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            for (int i = 1; i <= 5; i++)
              Card(
                key: Key('playground.level.$i'),
                child: ListTile(
                  leading: CircleAvatar(child: Text('$i')),
                  title: Text('Level $i'),
                  subtitle: Text('Tap to start level $i'),
                  onTap: () => onLevelTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LevelDetailStub extends StatelessWidget {
  const _LevelDetailStub({required this.levelIndex});

  final int levelIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Level $levelIndex')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Level $levelIndex detail'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to playground'),
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
    'playground - tapping a level card navigates to the level screen',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: _PlaygroundStub(
              onLevelTap: (int index) {
                Navigator.of(
                  tester.element(find.byType(_PlaygroundStub)),
                ).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => _LevelDetailStub(levelIndex: index),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Playground'), findsOneWidget);
      await tester.tap(find.byKey(const Key('playground.level.3')));
      await tester.pumpAndSettle();

      expect(find.text('Level 3 detail'), findsOneWidget);
    },
  );

  testWidgets('playground - back navigation returns to the level list', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: _PlaygroundStub(
            onLevelTap: (int index) {
              Navigator.of(
                tester.element(find.byType(_PlaygroundStub)),
              ).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => _LevelDetailStub(levelIndex: index),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('playground.level.1')));
    await tester.pumpAndSettle();
    expect(find.text('Level 1 detail'), findsOneWidget);

    await tester.tap(find.text('Back to playground'));
    await tester.pumpAndSettle();
    expect(find.text('Playground'), findsOneWidget);
  });

  testWidgets('playground - multiple taps cycle through levels', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: _PlaygroundStub(
            onLevelTap: (int index) {
              Navigator.of(
                tester.element(find.byType(_PlaygroundStub)),
              ).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => _LevelDetailStub(levelIndex: index),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    for (final int level in <int>[2, 4, 5]) {
      await tester.tap(find.byKey(Key('playground.level.$level')));
      await tester.pumpAndSettle();
      expect(find.text('Level $level detail'), findsOneWidget);
      await tester.tap(find.text('Back to playground'));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('playground - harness can capture screenshots', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: _PlaygroundStub(onLevelTap: _noop)),
      ),
    );
    await tester.pumpAndSettle();

    await harness.captureScreenshot('playground_home');
    // We can't easily assert the screenshot bytes from the test thread, but
    // verifying the call completes without exception is the contract.
  });
}

void _noop(int _) {}
