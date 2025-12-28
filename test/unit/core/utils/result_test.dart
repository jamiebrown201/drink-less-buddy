import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/core/utils/result.dart';
import 'package:drink_less_buddy/core/error/failures.dart';

void main() {
  group('Result Type', () {
    group('Success', () {
      test('should create success result with value', () {
        const result = Success(42);

        expect(result.isSuccess, true);
        expect(result.isFailure, false);
        expect(result.value, 42);
        expect(result.valueOrNull, 42);
      });

      test('should support equality comparison', () {
        const result1 = Success(42);
        const result2 = Success(42);
        const result3 = Success(43);

        expect(result1, equals(result2));
        expect(result1, isNot(equals(result3)));
      });

      test('should have consistent hashCode', () {
        const result1 = Success(42);
        const result2 = Success(42);

        expect(result1.hashCode, equals(result2.hashCode));
      });

      test('should throw when accessing failure', () {
        const result = Success(42);

        expect(() => result.failure, throwsStateError);
      });
    });

    group('Error', () {
      test('should create error result with failure', () {
        const failure = StorageFailure('Storage error');
        const result = Error<int>(failure);

        expect(result.isSuccess, false);
        expect(result.isFailure, true);
        expect(result.failure, failure);
        expect(result.valueOrNull, isNull);
      });

      test('should support equality comparison', () {
        const failure1 = StorageFailure('Error');
        const failure2 = StorageFailure('Error');
        const failure3 = StorageFailure('Different');

        const result1 = Error<int>(failure1);
        const result2 = Error<int>(failure2);
        const result3 = Error<int>(failure3);

        expect(result1, equals(result2));
        expect(result1, isNot(equals(result3)));
      });

      test('should throw when accessing value', () {
        const failure = StorageFailure('Storage error');
        const result = Error<int>(failure);

        expect(() => result.value, throwsA(isA<StorageFailure>()));
      });
    });

    group('fold', () {
      test('should call onSuccess for success result', () {
        const result = Success(42);

        final folded = result.fold(
          onSuccess: (value) => 'Success: $value',
          onError: (failure) => 'Error: $failure',
        );

        expect(folded, 'Success: 42');
      });

      test('should call onError for error result', () {
        const failure = StorageFailure('Storage error');
        const result = Error<int>(failure);

        final folded = result.fold(
          onSuccess: (value) => 'Success: $value',
          onError: (failure) => 'Error: ${failure.message}',
        );

        expect(folded, 'Error: Storage error');
      });
    });

    group('map', () {
      test('should transform success value', () {
        const result = Success(42);

        final mapped = result.map((value) => value * 2);

        expect(mapped.isSuccess, true);
        expect(mapped.value, 84);
      });

      test('should preserve error', () {
        const failure = StorageFailure('Storage error');
        const result = Error<int>(failure);

        final mapped = result.map((value) => value * 2);

        expect(mapped.isFailure, true);
        expect(mapped.failure, failure);
      });

      test('should change result type', () {
        const result = Success(42);

        final mapped = result.map((value) => value.toString());

        expect(mapped.isSuccess, true);
        expect(mapped.value, '42');
      });
    });

    group('mapAsync', () {
      test('should transform success value asynchronously', () async {
        const result = Success(42);

        final mapped = await result.mapAsync((value) async {
          await Future.delayed(const Duration(milliseconds: 10));
          return value * 2;
        });

        expect(mapped.isSuccess, true);
        expect(mapped.value, 84);
      });

      test('should preserve error in async operation', () async {
        const failure = StorageFailure('Storage error');
        const result = Error<int>(failure);

        final mapped = await result.mapAsync((value) async {
          await Future.delayed(const Duration(milliseconds: 10));
          return value * 2;
        });

        expect(mapped.isFailure, true);
        expect(mapped.failure, failure);
      });
    });

    group('flatMap', () {
      test('should chain successful results', () {
        const result = Success(42);

        final chained = result.flatMap((value) {
          return Success(value * 2);
        });

        expect(chained.isSuccess, true);
        expect(chained.value, 84);
      });

      test('should propagate first error', () {
        const failure = StorageFailure('Storage error');
        const result = Error<int>(failure);

        final chained = result.flatMap((value) {
          return Success(value * 2);
        });

        expect(chained.isFailure, true);
        expect(chained.failure, failure);
      });

      test('should propagate second error', () {
        const result = Success(42);
        const failure = ValidationFailure('Validation error');

        final chained = result.flatMap((value) {
          return Error<int>(failure);
        });

        expect(chained.isFailure, true);
        expect(chained.failure, failure);
      });

      test('should change result type', () {
        const result = Success(42);

        final chained = result.flatMap((value) {
          return Success(value.toString());
        });

        expect(chained.isSuccess, true);
        expect(chained.value, '42');
      });
    });

    group('Complex scenarios', () {
      test('should chain multiple operations', () {
        const result = Success(10);

        final transformed = result
            .map((value) => value * 2)
            .flatMap((value) => Success(value + 5))
            .map((value) => value.toString());

        expect(transformed.isSuccess, true);
        expect(transformed.value, '25');
      });

      test('should stop chain on first error', () {
        const failure = StorageFailure('Storage error');
        const result = Error<int>(failure);

        final transformed = result
            .map((value) => value * 2)
            .flatMap((value) => Success(value + 5))
            .map((value) => value.toString());

        expect(transformed.isFailure, true);
        expect(transformed.failure, failure);
      });

      test('should handle real-world use case: parsing and validation', () {
        // Simulate parsing a string to int, then validating range
        Result<int> parseNumber(String input) {
          final parsed = int.tryParse(input);
          if (parsed == null) {
            return const Error(ValidationFailure('Invalid number'));
          }
          return Success(parsed);
        }

        Result<int> validateRange(int value) {
          if (value < 0 || value > 100) {
            return const Error(ValidationFailure('Out of range'));
          }
          return Success(value);
        }

        // Valid case
        final valid = parseNumber('42').flatMap(validateRange);
        expect(valid.isSuccess, true);
        expect(valid.value, 42);

        // Invalid parse
        final invalidParse = parseNumber('abc').flatMap(validateRange);
        expect(invalidParse.isFailure, true);

        // Invalid range
        final invalidRange = parseNumber('200').flatMap(validateRange);
        expect(invalidRange.isFailure, true);
      });
    });
  });
}
