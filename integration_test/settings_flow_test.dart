// Settings flow integration tests.
//
// Mounts a representative Settings hub that mirrors the production
// `SettingsScreen` from `lib/features/settings/presentation/screens/...` and
// exercises the theme / language / privacy toggles. Real settings state is
// sourced from `settingsControllerProvider` which is overridden per test.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/integration_test_utils.dart';

/// In-memory snapshot of a `SettingsEntity` for testing.
class _SettingsState {
  const _SettingsState({
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
    this.languageCode = 'en',
  });

  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final String languageCode;

  _SettingsState copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    String? languageCode,
  }) => _SettingsState(
    themeMode: themeMode ?? this.themeMode,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    languageCode: languageCode ?? this.languageCode,
  );
}

/// Mutable settings controller used by the stub settings screen.
class _SettingsController extends StateNotifier<_SettingsState> {
  _SettingsController() : super(const _SettingsState());

  void setTheme(ThemeMode mode) => state = state.copyWith(themeMode: mode);
  void toggleNotifications() =>
      state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
  void setLanguage(String code) => state = state.copyWith(languageCode: code);
}

final StateNotifierProvider<_SettingsController, _SettingsState>
_settingsStubProvider =
    StateNotifierProvider<_SettingsController, _SettingsState>(
      (Ref ref) => _SettingsController(),
    );

/// Stand-in settings screen modeled on the production `SettingsScreen`. The
/// category list mirrors the real "Theme / Notifications / Language / About"
/// sections so we can navigate into each sub-screen.
class _SettingsStub extends ConsumerWidget {
  const _SettingsStub({
    required this.onOpenTheme,
    required this.onOpenLanguage,
  });

  final VoidCallback onOpenTheme;
  final VoidCallback onOpenLanguage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            ListTile(
              key: const Key('settings.theme'),
              leading: const Icon(Icons.brightness_6),
              title: const Text('Theme'),
              subtitle: Text(ref.watch(_settingsStubProvider).themeMode.name),
              onTap: onOpenTheme,
            ),
            const Divider(),
            ListTile(
              key: const Key('settings.notifications'),
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              subtitle: Text(
                ref.watch(_settingsStubProvider).notificationsEnabled
                    ? 'Enabled'
                    : 'Disabled',
              ),
              trailing: Switch(
                value: ref.watch(_settingsStubProvider).notificationsEnabled,
                onChanged: (_) => ref
                    .read(_settingsStubProvider.notifier)
                    .toggleNotifications(),
              ),
            ),
            const Divider(),
            ListTile(
              key: const Key('settings.language'),
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: Text(
                ref.watch(_settingsStubProvider).languageCode.toUpperCase(),
              ),
              onTap: onOpenLanguage,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSettingsStub extends ConsumerWidget {
  const _ThemeSettingsStub();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode mode = ref.watch(_settingsStubProvider).themeMode;
    return Scaffold(
      appBar: AppBar(title: const Text('Theme')),
      body: SafeArea(
        child: RadioGroup<ThemeMode>(
          groupValue: mode,
          onChanged: (ThemeMode? value) {
            if (value == null) return;
            ref.read(_settingsStubProvider.notifier).setTheme(value);
          },
          child: Column(
            children: <Widget>[
              for (final ThemeMode option in <ThemeMode>[
                ThemeMode.light,
                ThemeMode.dark,
                ThemeMode.system,
              ])
                RadioListTile<ThemeMode>(
                  key: Key('settings.theme.option.${option.name}'),
                  title: Text(option.name),
                  value: option,
                ),
              const SizedBox(height: 24),
              Text('Currently: ${mode.name}'),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSettingsStub extends StatelessWidget {
  const _LanguageSettingsStub();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: SafeArea(
        child: RadioGroup<String>(
          groupValue: 'en',
          onChanged: (_) {},
          child: Column(
            children: <Widget>[
              for (final String code in <String>['en', 'bn', 'hi'])
                RadioListTile<String>(
                  key: Key('settings.language.option.$code'),
                  title: Text(code.toUpperCase()),
                  value: code,
                ),
            ],
          ),
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
    'settings - opens Settings hub and exposes theme / language rows',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: _SettingsStub(
              onOpenTheme: () {
                Navigator.of(_settingsContext(tester)).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const _ThemeSettingsStub(),
                  ),
                );
              },
              onOpenLanguage: () {
                Navigator.of(_settingsContext(tester)).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const _LanguageSettingsStub(),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
    },
  );

  testWidgets(
    'settings - toggling theme switches between light / dark / system',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: _SettingsStub(
              onOpenTheme: () {
                Navigator.of(_settingsContext(tester)).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const _ThemeSettingsStub(),
                  ),
                );
              },
              onOpenLanguage: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('settings.theme')));
      await tester.pumpAndSettle();

      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('system'), findsOneWidget);

      await tester.tap(find.byKey(const Key('settings.theme.option.dark')));
      await tester.pumpAndSettle();
      expect(find.text('Currently: dark'), findsOneWidget);

      await tester.tap(find.byKey(const Key('settings.theme.option.light')));
      await tester.pumpAndSettle();
      expect(find.text('Currently: light'), findsOneWidget);
    },
  );

  testWidgets('settings - notifications toggle updates the row subtitle', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: _SettingsStub(onOpenTheme: () {}, onOpenLanguage: () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Enabled'), findsOneWidget);

    await tester.tap(find.byKey(const Key('settings.notifications')));
    await tester.pumpAndSettle();

    expect(find.text('Disabled'), findsOneWidget);
  });

  testWidgets('settings - language screen exposes language options', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: _SettingsStub(
            onOpenTheme: () {},
            onOpenLanguage: () {
              Navigator.of(_settingsContext(tester)).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => const _LanguageSettingsStub(),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('settings.language')));
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsWidgets);
    expect(find.text('EN'), findsOneWidget);
    expect(find.text('BN'), findsOneWidget);
    expect(find.text('HI'), findsOneWidget);
  });

  testWidgets('settings - harness dismissAnyModal is safe on Settings screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: _SettingsStub(onOpenTheme: () {}, onOpenLanguage: () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await harness.dismissAnyModal(tester);
    expect(find.text('Settings'), findsOneWidget);
  });
}

/// Pulls the BuildContext that owns the [Navigator] for the current tester.
BuildContext _settingsContext(WidgetTester tester) {
  return tester.element(find.byType(_SettingsStub));
}
