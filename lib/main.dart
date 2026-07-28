import 'bootstrap.dart';

/// Application entry point.
///
/// Kept intentionally tiny: all real initialization lives in [bootstrap] so
/// tests and alternative runtimes (for example, `flutter run -d chrome`) can
/// invoke it directly without going through `main`.
Future<void> main() async {
  await bootstrap();
}