// NOTE: `lib/core/widgets/ai/ai_avatar.dart` is currently an empty stub
// (a single newline — no `AiAvatar` widget is exported from this file).
// The widget tests for the avatar family live in:
//   - `loading/ai_loading_avatar_test.dart`
//   - `ai_history_section/widgets/ai_history_avatar_test.dart`
//   - `chat_message_list/chat_message_avatar_test.dart`
// This file is intentionally a no-op so that the test harness still runs
// against the helper API for the AI widget directory.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  group('AiAvatar', () {
    testWidgets(
      'placeholder smoke test — AiAvatar module is empty',
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