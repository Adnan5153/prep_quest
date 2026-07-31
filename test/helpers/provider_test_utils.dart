import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a fresh [ProviderContainer] for the duration of [body] and
/// disposes it afterwards. Use this in unit-style provider tests that do
/// not pump widgets.
Future<T> withProviderContainer<T>(
  Future<T> Function(ProviderContainer container) body, {
  List<Override> overrides = const <Override>[],
}) async {
  final ProviderContainer container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  return body(container);
}

/// Reads the current value of [provider] from [container], asserting it
/// has completed at least once. Useful for synchronous notifier state
/// checks.
T readProvider<T>(
  ProviderContainer container,
  ProviderListenable<T> provider,
) {
  return container.read(provider);
}

/// Awaits the first frame after mutating a notifier via [mutate]. Most
/// Riverpod notifiers schedule updates synchronously, but [StateNotifier]
/// subclasses sometimes emit asynchronously.
Future<void> pumpNotifierFrame(ProviderContainer container) async {
  // Yield to the microtask queue so any pending notifier listeners fire.
  await Future<void>.delayed(Duration.zero);
  // Touch the container so it considers itself active.
  container.read(_noopProvider);
}

final Provider<int> _noopProvider = Provider<int>((Ref ref) => 0);

/// Convenience helper that listens to [provider] while [body] runs and
/// records every emitted value (excluding the seed value) into [emissions].
Future<T> captureEmissions<T>(
  ProviderContainer container,
  ProviderListenable<T> provider,
  Future<T> Function(List<T> emissions) body,
) async {
  final List<T> emissions = <T>[];
  final ProviderSubscription<T> subscription = container.listen<T>(
    provider,
    (T? previous, T next) {
      emissions.add(next);
    },
    fireImmediately: false,
  );
  addTearDown(subscription.close);
  return body(emissions);
}

/// Builds a [WidgetTester]-compatible [ProviderScope] override for tests
/// that need to inject overrides but otherwise use the production
/// providers.
List<Override> overrideProviders(List<Override> overrides) => overrides;

/// Convenience wrapper that pumps a [ProviderScope] wrapped widget. Use
/// inside `testWidgets` blocks where you cannot use [withProviderContainer].
Future<void> pumpWidgetWithProviders(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const <Override>[],
}) async {
  await tester.pumpWidget(
    ProviderScope(overrides: overrides, child: child),
  );
  await tester.pump();
}
