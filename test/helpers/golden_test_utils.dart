import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/theme/app_theme.dart';

/// Updates that ship without engine-side golden compatibility should
/// re-record. Defaults follow Flutter's recommeded `0.0` when no
/// override is needed.
bool _shouldWrite() =>
    Platform.environment['UPDATE_GOLDENS'] == 'true' ||
    Platform.environment['FLUTTER_TEST_UPDATE_GOLDENS'] == 'true';

Future<void> _initializeSurface(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Captures a golden file by rendering [child] inside an AppTheme-wrapped
/// MaterialApp. Pass [themeMode] to render against dark or light.
Future<void> captureGolden(
  WidgetTester tester,
  String name, {
  required Widget child,
  ThemeMode themeMode = ThemeMode.light,
  Size size = const Size(360, 800),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: Scaffold(body: child),
    ),
  );
  // Use pump with explicit duration instead of pumpAndSettle, which can
  // time out when the widget under test has a continuous animation
  // (e.g. indeterminate ProgressIndicator).
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));

  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/$name.png'),
  );
}

/// Captures both light and dark variants in one call.
Future<void> captureGoldenPair(
  WidgetTester tester,
  String baseName, {
  required Widget Function(BuildContext, ThemeMode) builder,
}) async {
  for (final ThemeMode mode in ThemeMode.values) {
    final String suffix = mode == ThemeMode.dark ? '_dark' : '_light';
    final String filename = '$baseName$suffix';
    await captureGolden(
      tester,
      filename,
      child: Builder(
        builder: (BuildContext context) => builder(context, mode),
      ),
      themeMode: mode,
    );
  }
}

/// Returns the raw PNG bytes of the rendered widget tree. Useful in
/// golden helper tests that want to inspect the surface before writing
/// the file.
Future<Uint8List> renderWidgetToBytes(
  WidgetTester tester,
  Widget child,
) async {
  await _initializeSurface(tester);
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: child)),
  );
  await tester.pumpAndSettle();
  final RenderRepaintBoundary boundary =
      tester.binding.rootElement!.renderObject! as RenderRepaintBoundary;
  final ui.Image image = await boundary.toImage(pixelRatio: 1.0);
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

bool get updateGoldens => _shouldWrite();
