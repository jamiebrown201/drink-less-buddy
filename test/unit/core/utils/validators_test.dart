import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateWeeklyGoal', () {
      test('should return error for null value', () {
        final result = Validators.validateWeeklyGoal(null);

        expect(result, isNotNull);
        expect(result, contains('enter a weekly goal'));
      });

      test('should return error for empty string', () {
        final result = Validators.validateWeeklyGoal('');

        expect(result, isNotNull);
        expect(result, contains('enter a weekly goal'));
      });

      test('should return error for non-numeric value', () {
        final result = Validators.validateWeeklyGoal('abc');

        expect(result, isNotNull);
        expect(result, contains('valid number'));
      });

      test('should return error for zero', () {
        final result = Validators.validateWeeklyGoal('0');

        expect(result, isNotNull);
        expect(result, contains('greater than 0'));
      });

      test('should return error for negative value', () {
        final result = Validators.validateWeeklyGoal('-5');

        expect(result, isNotNull);
        expect(result, contains('greater than 0'));
      });

      test('should return error for unreasonably high value', () {
        final result = Validators.validateWeeklyGoal('501');

        expect(result, isNotNull);
        expect(result, contains('unreasonably high'));
      });

      test('should accept valid positive integers', () {
        expect(Validators.validateWeeklyGoal('14'), isNull);
        expect(Validators.validateWeeklyGoal('21'), isNull);
        expect(Validators.validateWeeklyGoal('50'), isNull);
      });

      test('should accept valid positive decimals', () {
        expect(Validators.validateWeeklyGoal('14.5'), isNull);
        expect(Validators.validateWeeklyGoal('10.25'), isNull);
      });

      test('should accept boundary value 500', () {
        expect(Validators.validateWeeklyGoal('500'), isNull);
      });

      test('should accept small decimals', () {
        expect(Validators.validateWeeklyGoal('0.1'), isNull);
        expect(Validators.validateWeeklyGoal('1.5'), isNull);
      });
    });

    group('validateEmail', () {
      test('should return null for null value (optional)', () {
        final result = Validators.validateEmail(null);

        expect(result, isNull);
      });

      test('should return null for empty string (optional)', () {
        final result = Validators.validateEmail('');

        expect(result, isNull);
      });

      test('should accept valid email addresses', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
        expect(Validators.validateEmail('user.name@domain.co.uk'), isNull);
        expect(Validators.validateEmail('user+tag@example.com'), isNull);
        expect(Validators.validateEmail('user123@test-domain.com'), isNull);
      });

      test('should reject invalid email formats', () {
        expect(Validators.validateEmail('invalid'), isNotNull);
        expect(Validators.validateEmail('invalid@'), isNotNull);
        expect(Validators.validateEmail('@domain.com'), isNotNull);
        expect(Validators.validateEmail('user@'), isNotNull);
        expect(Validators.validateEmail('user@domain'), isNotNull);
        expect(Validators.validateEmail('user domain@test.com'), isNotNull);
      });

      test('should return error message for invalid email', () {
        final result = Validators.validateEmail('invalid-email');

        expect(result, isNotNull);
        expect(result, contains('valid email'));
      });
    });

    group('validateRequired', () {
      test('should return error for null value', () {
        final result = Validators.validateRequired(null, 'Username');

        expect(result, isNotNull);
        expect(result, 'Username is required');
      });

      test('should return error for empty string', () {
        final result = Validators.validateRequired('', 'Username');

        expect(result, isNotNull);
        expect(result, 'Username is required');
      });

      test('should return error for whitespace only', () {
        final result = Validators.validateRequired('   ', 'Username');

        expect(result, isNotNull);
        expect(result, 'Username is required');
      });

      test('should accept non-empty string', () {
        expect(Validators.validateRequired('value', 'Field'), isNull);
        expect(Validators.validateRequired('  value  ', 'Field'), isNull);
      });

      test('should include field name in error message', () {
        final result1 = Validators.validateRequired(null, 'Email');
        final result2 = Validators.validateRequired(null, 'Password');

        expect(result1, 'Email is required');
        expect(result2, 'Password is required');
      });
    });

    group('validateLength', () {
      test('should return error for null value', () {
        final result = Validators.validateLength(null, 3, 10, 'Password');

        expect(result, isNotNull);
        expect(result, 'Password is required');
      });

      test('should return error for too short value', () {
        final result = Validators.validateLength('ab', 3, 10, 'Password');

        expect(result, isNotNull);
        expect(result, contains('at least 3 characters'));
      });

      test('should return error for too long value', () {
        final result = Validators.validateLength(
          'this is a very long string',
          3,
          10,
          'Password',
        );

        expect(result, isNotNull);
        expect(result, contains('less than 10 characters'));
      });

      test('should accept value at minimum length', () {
        final result = Validators.validateLength('abc', 3, 10, 'Password');

        expect(result, isNull);
      });

      test('should accept value at maximum length', () {
        final result = Validators.validateLength('1234567890', 3, 10, 'Password');

        expect(result, isNull);
      });

      test('should accept value within range', () {
        final result = Validators.validateLength('hello', 3, 10, 'Password');

        expect(result, isNull);
      });

      test('should include field name and limits in error messages', () {
        final shortResult = Validators.validateLength('a', 5, 20, 'Username');
        final longResult = Validators.validateLength(
          'a' * 25,
          5,
          20,
          'Username',
        );

        expect(shortResult, contains('Username'));
        expect(shortResult, contains('5 characters'));
        expect(longResult, contains('Username'));
        expect(longResult, contains('20 characters'));
      });
    });

    group('validatePositiveNumber', () {
      test('should return error for null value', () {
        final result = Validators.validatePositiveNumber(null, 'Units');

        expect(result, isNotNull);
        expect(result, 'Units is required');
      });

      test('should return error for empty string', () {
        final result = Validators.validatePositiveNumber('', 'Units');

        expect(result, isNotNull);
        expect(result, 'Units is required');
      });

      test('should return error for non-numeric value', () {
        final result = Validators.validatePositiveNumber('abc', 'Units');

        expect(result, isNotNull);
        expect(result, contains('valid number'));
      });

      test('should return error for zero', () {
        final result = Validators.validatePositiveNumber('0', 'Units');

        expect(result, isNotNull);
        expect(result, contains('greater than 0'));
      });

      test('should return error for negative value', () {
        final result = Validators.validatePositiveNumber('-5', 'Units');

        expect(result, isNotNull);
        expect(result, contains('greater than 0'));
      });

      test('should accept positive integers', () {
        expect(Validators.validatePositiveNumber('1', 'Units'), isNull);
        expect(Validators.validatePositiveNumber('100', 'Units'), isNull);
      });

      test('should accept positive decimals', () {
        expect(Validators.validatePositiveNumber('0.5', 'Units'), isNull);
        expect(Validators.validatePositiveNumber('2.5', 'Units'), isNull);
        expect(Validators.validatePositiveNumber('10.99', 'Units'), isNull);
      });

      test('should include field name in error messages', () {
        final result = Validators.validatePositiveNumber('-1', 'Alcohol Units');

        expect(result, contains('Alcohol Units'));
        expect(result, contains('greater than 0'));
      });
    });

    group('Complex validation scenarios', () {
      test('should validate user registration form', () {
        // Valid data
        expect(Validators.validateRequired('john_doe', 'Username'), isNull);
        expect(Validators.validateLength('john_doe', 3, 20, 'Username'), isNull);
        expect(Validators.validateEmail('john@example.com'), isNull);
        expect(Validators.validateWeeklyGoal('14'), isNull);

        // Invalid username (too short)
        expect(
          Validators.validateLength('ab', 3, 20, 'Username'),
          isNotNull,
        );

        // Invalid email
        expect(Validators.validateEmail('invalid-email'), isNotNull);

        // Invalid goal
        expect(Validators.validateWeeklyGoal('0'), isNotNull);
      });

      test('should validate drink logging form', () {
        // Valid data
        expect(Validators.validateRequired('Beer', 'Drink Type'), isNull);
        expect(Validators.validatePositiveNumber('2.5', 'Units'), isNull);

        // Invalid data
        expect(Validators.validateRequired('', 'Drink Type'), isNotNull);
        expect(Validators.validatePositiveNumber('0', 'Units'), isNotNull);
        expect(Validators.validatePositiveNumber('-1', 'Units'), isNotNull);
      });

      test('should validate settings update', () {
        // Valid weekly goal updates
        expect(Validators.validateWeeklyGoal('10'), isNull);
        expect(Validators.validateWeeklyGoal('14'), isNull);
        expect(Validators.validateWeeklyGoal('21'), isNull);
        expect(Validators.validateWeeklyGoal('100'), isNull);

        // Invalid updates
        expect(Validators.validateWeeklyGoal(''), isNotNull);
        expect(Validators.validateWeeklyGoal('abc'), isNotNull);
        expect(Validators.validateWeeklyGoal('-5'), isNotNull);
        expect(Validators.validateWeeklyGoal('1000'), isNotNull);
      });

      test('should handle edge cases', () {
        // Very small positive number
        expect(Validators.validatePositiveNumber('0.001', 'Units'), isNull);
        expect(Validators.validateWeeklyGoal('0.1'), isNull);

        // Boundary values
        expect(Validators.validateWeeklyGoal('500'), isNull);
        expect(Validators.validateWeeklyGoal('500.0'), isNull);
        expect(Validators.validateWeeklyGoal('500.1'), isNotNull);

        // Whitespace handling
        expect(Validators.validateRequired('  text  ', 'Field'), isNull);
        expect(Validators.validateRequired('     ', 'Field'), isNotNull);
      });
    });
  });
}
