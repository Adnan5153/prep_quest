/// Reusable callback typedefs.
///
/// Centralising these prevents long inline signatures in widgets and
/// notifiers and makes the call sites easier to read.
typedef AsyncCallback = Future<void> Function();
typedef ValueChangedCallback<T> = void Function(T value);
typedef Callback = void Function();
