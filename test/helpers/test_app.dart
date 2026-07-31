import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps a widget tree with a minimal MaterialApp so individual widgets
/// can be tested without spinning up the full Prep Quest router or
/// theming pipeline.
///
/// NOTE: localisation delegates are intentionally not provided so this
/// helper works without requiring the `flutter_localizations` SDK
/// package on the classpath. Tests that need localised strings
/// should supply their own delegates via `localizationsDelegates`.
class TestApp extends StatelessWidget {
  const TestApp({
    super.key,
    required this.child,
    this.theme = ThemeMode.light,
    this.locale = const Locale('en'),
    this.textDirection = TextDirection.ltr,
    this.localizationsDelegates = const <LocalizationsDelegate<Object>>[],
    this.supportedLocales = const <Locale>[Locale('en')],
  });

  final Widget child;
  final ThemeMode theme;
  final Locale locale;
  final TextDirection textDirection;
  final List<LocalizationsDelegate<Object>> localizationsDelegates;
  final List<Locale> supportedLocales;

  ThemeData get _lightTheme => ThemeData.light(useMaterial3: true);
  ThemeData get _darkTheme => ThemeData.dark(useMaterial3: true);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: theme,
      home: Directionality(textDirection: textDirection, child: child),
    );
  }
}

/// Pumps [child] inside a [TestApp] and waits for animations to settle.
Future<void> pumpTestWidget(
  WidgetTester tester,
  Widget child, {
  ThemeMode theme = ThemeMode.light,
  TextDirection textDirection = TextDirection.ltr,
  Duration? settle,
}) async {
  await tester.pumpWidget(
    TestApp(
      theme: theme,
      textDirection: textDirection,
      child: child,
    ),
  );
  await tester.pump(settle ?? Duration.zero);
}

/// Sets a deterministic surface size for layout-sensitive tests.
void useTestSurface({
  required WidgetTester tester,
  Size size = const Size(360, 800),
  double devicePixelRatio = 1.0,
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = devicePixelRatio;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}