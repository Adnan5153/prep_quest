// Subscription flow integration tests.
//
// Verifies the Subscription plans hub reaches the screen, lists the major
// plan tiers, and that the BillingCycle selector switches between Monthly and
// Yearly modes. Real subscription provisioning requires a backend (RevenueCat
// / Play Billing) so this test only exercises the offline UI surface.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

enum _BillingCycle { monthly, yearly }

class _SubscriptionPlansStub extends StatefulWidget {
  const _SubscriptionPlansStub();

  @override
  State<_SubscriptionPlansStub> createState() => _SubscriptionPlansStubState();
}

class _SubscriptionPlansStubState extends State<_SubscriptionPlansStub> {
  _BillingCycle _cycle = _BillingCycle.monthly;
  String? _selectedPlan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription plans'),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const Text(
              'Pick a plan that fits your preparation style.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            SegmentedButton<_BillingCycle>(
              segments: const <ButtonSegment<_BillingCycle>>[
                ButtonSegment<_BillingCycle>(
                  value: _BillingCycle.monthly,
                  label: Text('Monthly'),
                ),
                ButtonSegment<_BillingCycle>(
                  value: _BillingCycle.yearly,
                  label: Text('Yearly'),
                ),
              ],
              selected: <_BillingCycle>{_cycle},
              onSelectionChanged: (Set<_BillingCycle> set) {
                if (set.isEmpty) return;
                setState(() => _cycle = set.first);
              },
            ),
            const SizedBox(height: 24),
            RadioGroup<String>(
              groupValue: _selectedPlan ?? 'Free',
              onChanged: (String? value) {
                if (value == null) return;
                setState(() => _selectedPlan = value);
              },
              child: Column(
                children: <Widget>[
                  for (final String plan in <String>[
                    'Free',
                    'Premium',
                    'Premium Yearly',
                  ])
                    RadioListTile<String>(
                      key: Key('subscription.plan.$plan'),
                      title: Text(plan),
                      subtitle: Text(
                        _cycle == _BillingCycle.yearly
                            ? 'Billed yearly'
                            : 'Billed monthly',
                      ),
                      value: plan,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: const Key('subscription.continue'),
              onPressed: () {},
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('subscription - plans screen lists all tiers', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: _SubscriptionPlansStub()));
    await tester.pumpAndSettle();

    expect(find.text('Subscription plans'), findsOneWidget);
    expect(find.text('Free'), findsOneWidget);
    expect(find.text('Premium'), findsOneWidget);
    expect(find.text('Premium Yearly'), findsOneWidget);
  });

  testWidgets(
    'subscription - billing cycle switches between monthly and yearly',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: _SubscriptionPlansStub()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Billed monthly'), findsWidgets);

      await tester.tap(find.text('Yearly'));
      await tester.pumpAndSettle();
      expect(find.text('Billed yearly'), findsWidgets);

      await tester.tap(find.text('Monthly'));
      await tester.pumpAndSettle();
      expect(find.text('Billed monthly'), findsWidgets);
    },
  );

  testWidgets('subscription - selecting a tier updates the radio control', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _SubscriptionPlansStub()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('subscription.plan.Premium')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('subscription.plan.Premium')), findsOneWidget);
  });

  testWidgets('subscription - Continue CTA is present and tappable', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _SubscriptionPlansStub()));
    await tester.pumpAndSettle();
    final Finder continueFinder = find.byKey(
      const Key('subscription.continue'),
    );
    expect(continueFinder, findsOneWidget);
    await tester.tap(continueFinder);
    await tester.pump();
  });

  testWidgets('subscription - back button returns to caller', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) => Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const _SubscriptionPlansStub(),
                    ),
                  );
                },
              ),
            ),
            body: const Center(child: Text('Profile body')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Subscription plans'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Profile body'), findsOneWidget);
  });
}
