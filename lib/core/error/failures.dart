/// Base class for all failures in the application
/// Following Clean Architecture principles
abstract class Failure {
  final String message;
  final StackTrace? stackTrace;

  const Failure(this.message, [this.stackTrace]);

  @override
  String toString() => message;
}

/// Storage-related failures
class StorageFailure extends Failure {
  const StorageFailure(super.message, [super.stackTrace]);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.stackTrace]);
}

/// Network-related failures (for future Supabase integration)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.stackTrace]);
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.stackTrace]);
}

/// Generic failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, [super.stackTrace]);
}
