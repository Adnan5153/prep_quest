// NOTE: `lib/core/widgets/ai/prompt_card.dart` is currently an empty stub
// (a single newline — no `PromptCard` widget is exported yet).
// The widget tests for prompt-related avatars live in:
//   - `prompt_category_chip_test.dart`
//   - `prompt_history_tile_test.dart`
//   - `smart_prompt_chip_test.dart`
//   - `smart_prompt_list_test.dart`
// This file is intentionally a no-op so that the test harness still runs
// against the helper API for the AI widget directory.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  group('PromptCard', () {
    testWidgets(
      'placeholder smoke test — PromptCard module is empty',
      (tester) async {
        await pumpTestWidget(
          tester,
          const SizedBox.shrink(),
        );

        expect(tester.takeException(), isNull);
      },
    );
  });
}