/// Base contract for domain failures surfaced at the validation boundary.
abstract class Failure {
  /// Creates a failure.
  const Failure();

  /// Human-readable description of the failure.
  String get message;

  @override
  String toString() => message;
}
