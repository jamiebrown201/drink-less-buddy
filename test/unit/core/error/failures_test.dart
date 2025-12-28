import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/core/error/failures.dart';

void main() {
  group('Failures', () {
    group('StorageFailure', () {
      test('should create failure with message', () {
        const failure = StorageFailure('Failed to save data');

        expect(failure.message, 'Failed to save data');
        expect(failure.stackTrace, isNull);
      });

      test('should create failure with stack trace', () {
        final stackTrace = StackTrace.current;
        final failure = StorageFailure('Failed to save data', stackTrace);

        expect(failure.message, 'Failed to save data');
        expect(failure.stackTrace, stackTrace);
      });

      test('should convert to string', () {
        const failure = StorageFailure('Failed to save data');

        expect(failure.toString(), 'Failed to save data');
      });

      test('should be instance of Failure', () {
        const failure = StorageFailure('Failed to save data');

        expect(failure, isA<Failure>());
        expect(failure, isA<StorageFailure>());
      });
    });

    group('ValidationFailure', () {
      test('should create failure with message', () {
        const failure = ValidationFailure('Invalid input');

        expect(failure.message, 'Invalid input');
        expect(failure.stackTrace, isNull);
      });

      test('should create failure with stack trace', () {
        final stackTrace = StackTrace.current;
        final failure = ValidationFailure('Invalid input', stackTrace);

        expect(failure.message, 'Invalid input');
        expect(failure.stackTrace, stackTrace);
      });

      test('should be instance of Failure', () {
        const failure = ValidationFailure('Invalid input');

        expect(failure, isA<Failure>());
        expect(failure, isA<ValidationFailure>());
      });
    });

    group('NetworkFailure', () {
      test('should create failure with message', () {
        const failure = NetworkFailure('Connection timeout');

        expect(failure.message, 'Connection timeout');
        expect(failure.stackTrace, isNull);
      });

      test('should create failure with stack trace', () {
        final stackTrace = StackTrace.current;
        final failure = NetworkFailure('Connection timeout', stackTrace);

        expect(failure.message, 'Connection timeout');
        expect(failure.stackTrace, stackTrace);
      });

      test('should be instance of Failure', () {
        const failure = NetworkFailure('Connection timeout');

        expect(failure, isA<Failure>());
        expect(failure, isA<NetworkFailure>());
      });
    });

    group('AuthFailure', () {
      test('should create failure with message', () {
        const failure = AuthFailure('Unauthorized access');

        expect(failure.message, 'Unauthorized access');
        expect(failure.stackTrace, isNull);
      });

      test('should create failure with stack trace', () {
        final stackTrace = StackTrace.current;
        final failure = AuthFailure('Unauthorized access', stackTrace);

        expect(failure.message, 'Unauthorized access');
        expect(failure.stackTrace, stackTrace);
      });

      test('should be instance of Failure', () {
        const failure = AuthFailure('Unauthorized access');

        expect(failure, isA<Failure>());
        expect(failure, isA<AuthFailure>());
      });
    });

    group('UnexpectedFailure', () {
      test('should create failure with message', () {
        const failure = UnexpectedFailure('Something went wrong');

        expect(failure.message, 'Something went wrong');
        expect(failure.stackTrace, isNull);
      });

      test('should create failure with stack trace', () {
        final stackTrace = StackTrace.current;
        final failure = UnexpectedFailure('Something went wrong', stackTrace);

        expect(failure.message, 'Something went wrong');
        expect(failure.stackTrace, stackTrace);
      });

      test('should be instance of Failure', () {
        const failure = UnexpectedFailure('Something went wrong');

        expect(failure, isA<Failure>());
        expect(failure, isA<UnexpectedFailure>());
      });
    });

    group('Failure hierarchy', () {
      test('all specific failures should extend base Failure', () {
        const storage = StorageFailure('test');
        const validation = ValidationFailure('test');
        const network = NetworkFailure('test');
        const auth = AuthFailure('test');
        const unexpected = UnexpectedFailure('test');

        expect(storage, isA<Failure>());
        expect(validation, isA<Failure>());
        expect(network, isA<Failure>());
        expect(auth, isA<Failure>());
        expect(unexpected, isA<Failure>());
      });

      test('failures should be distinguishable by type', () {
        Failure getFailure(String type) {
          switch (type) {
            case 'storage':
              return const StorageFailure('test');
            case 'validation':
              return const ValidationFailure('test');
            case 'network':
              return const NetworkFailure('test');
            case 'auth':
              return const AuthFailure('test');
            default:
              return const UnexpectedFailure('test');
          }
        }

        expect(getFailure('storage'), isA<StorageFailure>());
        expect(getFailure('validation'), isA<ValidationFailure>());
        expect(getFailure('network'), isA<NetworkFailure>());
        expect(getFailure('auth'), isA<AuthFailure>());
        expect(getFailure('unexpected'), isA<UnexpectedFailure>());
      });

      test('should handle failures polymorphically', () {
        final List<Failure> failures = [
          const StorageFailure('Storage error'),
          const ValidationFailure('Validation error'),
          const NetworkFailure('Network error'),
          const AuthFailure('Auth error'),
          const UnexpectedFailure('Unexpected error'),
        ];

        for (final failure in failures) {
          expect(failure, isA<Failure>());
          expect(failure.message, contains('error'));
        }
      });
    });

    group('Real-world scenarios', () {
      test('should handle storage error with stack trace', () {
        Exception createStorageError() {
          throw const StorageFailure('Database write failed');
        }

        expect(
          () => createStorageError(),
          throwsA(isA<StorageFailure>()),
        );
      });

      test('should differentiate between error types', () {
        Failure handleError(String errorType) {
          if (errorType == 'storage') {
            return const StorageFailure('Storage operation failed');
          } else if (errorType == 'validation') {
            return const ValidationFailure('Input validation failed');
          } else if (errorType == 'network') {
            return const NetworkFailure('Network request failed');
          } else {
            return const UnexpectedFailure('Unknown error occurred');
          }
        }

        final storageError = handleError('storage');
        expect(storageError, isA<StorageFailure>());
        expect(storageError.message, 'Storage operation failed');

        final validationError = handleError('validation');
        expect(validationError, isA<ValidationFailure>());
        expect(validationError.message, 'Input validation failed');

        final networkError = handleError('network');
        expect(networkError, isA<NetworkFailure>());
        expect(networkError.message, 'Network request failed');
      });
    });
  });
}
