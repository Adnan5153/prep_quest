import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/constants/app_spacing.dart';
import 'package:prep_quest/core/widgets/app_snackbar.dart';
import 'package:prep_quest/core/widgets/primary_button.dart';
import 'package:prep_quest/core/widgets/secondary_button.dart';

/// Drives a [PrimaryButton] tap and awaits the frame after the callback.
Future<void> tapPrimaryButton(
  WidgetTester tester,
  Finder finder, {
  String label = 'primary-cta',
}) async {
  final Finder byLabel = find.bySemanticsLabel(label);
  // Semantics nodes may merge into ancestors resulting in ambiguous matches.
  // Only use the label finder when there is exactly one match; otherwise
  // fall back to the explicit finder so the tap target is unambiguous.
  final Finder button =
      byLabel.evaluate().length == 1 ? byLabel : finder;
  await tester.tap(button);
  await tester.pump();
}

/// Drives a [SecondaryButton] tap.
Future<void> tapSecondaryButton(
  WidgetTester tester,
  Finder finder, {
  String label = 'secondary-cta',
}) async {
  final Finder byLabel = find.bySemanticsLabel(label);
  // See note in [tapPrimaryButton] about merged Semantics nodes.
  final Finder button =
      byLabel.evaluate().length == 1 ? byLabel : finder;
  await tester.tap(button);
  await tester.pump();
}

/// Scrolls [finder] into view in any scrollable ancestor.
Future<void> scrollIntoView(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder, 200);
}

/// Tolerance used for layout assertions in widget tests.
const double kGoldenTolerance = 0.05;

/// Standard button finder for the on-screen [AppSnackBar] if present.
Finder snackBarFinder() => find.byType(SnackBar);

/// Padding token used when constructing layout probes in widget tests.
const EdgeInsets kProbePadding = EdgeInsets.all(AppSpacing.md);
