import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/integration_test_utils.dart';

/// Shared integration-test setup.
///
/// The production bootstrap initializes Firebase and the full GoRouter. These
/// integration tests intentionally mount feature widgets in isolation so each
/// test can run independently without requiring a production Firebase project.
/// Tests that exercise Firebase-backed actions document the expected mock or
/// emulator prerequisite in the test body.
void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final IntegrationTestHarness harness = IntegrationTestHarness(binding);

  testWidgets('integration harness can mount an ad-hoc widget', (
    WidgetTester tester,
  ) async {
    await pumpIntegrationWidget(
      tester,
      const Text('Prep Quest integration test host'),
    );

    expect(find.text('Prep Quest integration test host'), findsOneWidget);
    await harness.pumpFor(tester, const Duration(milliseconds: 50));
  });
}
