// Profile flow + sign-out + subscription entry integration tests.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class _ProfileFlowStub extends StatelessWidget {
  const _ProfileFlowStub({required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const CircleAvatar(radius: 32, child: Text('PQ')),
          const SizedBox(height: 12),
          const Text('Integration User', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ListTile(
            key: const Key('profile.settings'),
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: onOpenSettings,
          ),
          ListTile(
            key: const Key('profile.subscription'),
            leading: const Icon(Icons.workspace_premium),
            title: const Text('Subscription'),
            onTap: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const _SubscriptionStub(),
              ),
            ),
          ),
          ListTile(
            key: const Key('profile.signOut'),
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () => showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Sign out?'),
                content: const Text('Are you sure you want to sign out?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    key: const Key('profile.signOut.confirm'),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsEntryStub extends StatelessWidget {
  const _SettingsEntryStub();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings page content')),
    );
  }
}

class _SubscriptionStub extends StatelessWidget {
  const _SubscriptionStub();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          Text(
            'Choose your plan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 16),
          Card(child: ListTile(title: Text('Free'))),
          Card(child: ListTile(title: Text('Premium'))),
          Card(child: ListTile(title: Text('Premium yearly'))),
        ],
      ),
    );
  }
}

void _openSettings(WidgetTester tester) {
  Navigator.of(tester.element(find.byType(_ProfileFlowStub))).push<void>(
    MaterialPageRoute<void>(builder: (_) => const _SettingsEntryStub()),
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('profile - settings navigation opens Settings', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: _ProfileFlowStub(onOpenSettings: () => _openSettings(tester)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    await tester.tap(find.byKey(const Key('profile.settings')));
    await tester.pumpAndSettle();
    expect(find.text('Settings page content'), findsOneWidget);
  });

  testWidgets('profile - sign out asks for confirmation then closes dialog', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: _ProfileFlowStub(onOpenSettings: _noop)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile.signOut')));
    await tester.pumpAndSettle();
    expect(find.text('Sign out?'), findsOneWidget);

    await tester.tap(find.byKey(const Key('profile.signOut.confirm')));
    await tester.pumpAndSettle();
    expect(find.text('Sign out?'), findsNothing);
  });

  testWidgets('profile - cancelling sign out keeps the user on Profile', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: _ProfileFlowStub(onOpenSettings: _noop)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile.signOut')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Sign out?'), findsNothing);
  });

  testWidgets('profile - subscription entry opens plan list', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: _ProfileFlowStub(onOpenSettings: _noop)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile.subscription')));
    await tester.pumpAndSettle();

    expect(find.text('Choose your plan'), findsOneWidget);
    expect(find.text('Premium'), findsOneWidget);
  });

  testWidgets('subscription - plan cards render free and premium options', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _SubscriptionStub()));
    await tester.pumpAndSettle();

    expect(find.text('Choose your plan'), findsOneWidget);
    expect(find.text('Free'), findsOneWidget);
    expect(find.text('Premium'), findsOneWidget);
    expect(find.text('Premium yearly'), findsOneWidget);
  });
}

void _noop() {}
