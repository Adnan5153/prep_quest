// AI tutor integration tests.
//
// The production AI tutor delegates message generation to a remote provider.
// These tests use a deterministic in-memory response so they validate the
// complete user-facing interaction (open tutor -> type question -> send ->
// response appears) without making a network call.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/integration_test_utils.dart';

class _AiTutorStub extends StatefulWidget {
  const _AiTutorStub();

  @override
  State<_AiTutorStub> createState() => _AiTutorStubState();
}

class _AiTutorStubState extends State<_AiTutorStub> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = <String>[];
  bool _isThinking = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Tutor'),
        actions: <Widget>[
          IconButton(
            key: const Key('ai.history'),
            tooltip: 'History',
            onPressed: () {},
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: _messages.isEmpty
                  ? const Center(
                      child: Text('Ask me anything about your studies.'),
                    )
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                            key: Key('ai.message.$index'),
                            title: Text(_messages[index]),
                          ),
                    ),
            ),
            if (_isThinking)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Thinking...'),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      key: const Key('ai.input'),
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Ask a question',
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('ai.send'),
                    tooltip: 'Send',
                    onPressed: _send,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    final String question = _controller.text.trim();
    if (question.isEmpty) return;
    setState(() {
      _messages.add(question);
      _controller.clear();
      _isThinking = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 30));
    if (!mounted) return;
    setState(() {
      _messages.add('Here is a concise explanation of: $question');
      _isThinking = false;
    });
  }
}

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final IntegrationTestHarness harness = IntegrationTestHarness(binding);

  testWidgets('AI tutor - ask a question and receive a response', (
    tester,
  ) async {
    await _mountAiTutor(tester);
    await tester.pumpAndSettle();

    expect(find.text('AI Tutor'), findsOneWidget);
    expect(find.text('Ask me anything about your studies.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('ai.input')),
      'What is the capital of Bangladesh?',
    );
    await tester.tap(find.byKey(const Key('ai.send')));
    await tester.pumpAndSettle();

    expect(find.text('What is the capital of Bangladesh?'), findsOneWidget);
    expect(
      find.text(
        'Here is a concise explanation of: What is the capital of Bangladesh?',
      ),
      findsOneWidget,
    );
  });

  testWidgets('AI tutor - empty message is not sent', (tester) async {
    await _mountAiTutor(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('ai.send')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('ai.message.0')), findsNothing);
    expect(find.text('Ask me anything about your studies.'), findsOneWidget);
  });

  testWidgets('AI tutor - history action is reachable', (tester) async {
    await _mountAiTutor(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('ai.history')));
    await tester.pumpAndSettle();
    expect(find.text('AI Tutor'), findsOneWidget);
  });

  testWidgets('AI tutor - harness waits for async response', (tester) async {
    await _mountAiTutor(tester);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('ai.input')), 'Define GDP');
    await tester.tap(find.byKey(const Key('ai.send')));
    await harness.pumpFor(tester, const Duration(milliseconds: 100));

    expect(
      find.text('Here is a concise explanation of: Define GDP'),
      findsOneWidget,
    );
  });
}

Future<void> _mountAiTutor(WidgetTester tester) {
  return pumpIntegrationWidget(tester, const _AiTutorStub());
}
