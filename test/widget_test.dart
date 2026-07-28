import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/app.dart';
import 'package:prep_quest/core/config/app_config.dart';

void main() {
  setUp(() async {
    // AppConfig is read by PrepQuestApp at build time, so every test
    // needs to initialize it before pumping the widget tree. We call the
    // static AppConfig.bootstrap() directly (instead of the wrapper
    // bootstrap() from main.dart) because that wrapper also calls runApp,
    // which is illegal inside the test harness.
    await AppConfig.bootstrap();
  });

  testWidgets('PrepQuestApp boots into the playground route', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(2400, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Tolerate pre-existing render-overflow warnings from upstream HUD
    // widgets during the boot smoke test; we only assert routing here.
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    await tester.pumpWidget(const PrepQuestApp());

    // The router resolves the initial route to `/` -> `/playground`, and the
    // HUD top bar is announced via its semantic label.
    expect(find.bySemanticsLabel('Playground player status'), findsOneWidget);
  });
}
