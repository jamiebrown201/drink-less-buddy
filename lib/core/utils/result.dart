import '../error/failures.dart';

/// Result type for error handling
/// Either Success<T> or Failure
/// Following functional programming principles
sealed class Result<T> {
  const Result();

  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is failure
  bool get isFailure => this is Failure;

  /// Get value if success, throw if failure
  T get value {
    return switch (this) {
      Success(value: final v) => v,
      Error(failure: final f) => throw f,
    };
  }

  /// Get value if success, return null if failure
  T? get valueOrNull {
    return switch (this) {
      Success(value: final v) => v,
      Error() => null,
    };
  }

  /// Get failure if error, throw if success
  Failure get failure {
    return switch (this) {
      Success() => throw StateError('Cannot get failure from Success'),
      Error(failure: final f) => f,
    };
  }

  /// Fold result into a single value
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onError,
  }) {
    return switch (this) {
      Success(value: final v) => onSuccess(v),
      Error(failure: final f) => onError(f),
    };
  }

  /// Map success value
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success(value: final v) => Success(transform(v)),
      Error(failure: final f) => Error(f),
    };
  }

  /// Async map
  Future<Result<R>> mapAsync<R>(
    Future<R> Function(T value) transform,
  ) async {
    return switch (this) {
      Success(value: final v) => Success(await transform(v)),
      Error(failure: final f) => Error(f),
    };
  }

  /// Chain results (flatMap/bind)
  Result<R> flatMap<R>(Result<R> Function(T value) transform) {
    return switch (this) {
      Success(value: final v) => transform(v),
      Error(failure: final f) => Error(f),
    };
  }
}

/// Success result
final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Error result
final class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Error<T> && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
