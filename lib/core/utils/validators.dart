/// Input validation utilities
/// Following Single Responsibility Principle
class Validators {
  Validators._(); // Private constructor

  /// Validate weekly goal
  static String? validateWeeklyGoal(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a weekly goal';
    }

    final goal = double.tryParse(value);
    if (goal == null) {
      return 'Please enter a valid number';
    }

    if (goal <= 0) {
      return 'Goal must be greater than 0';
    }

    if (goal > 500) {
      return 'Goal seems unreasonably high';
    }

    return null;
  }

  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate text field (non-empty)
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate text length
  static String? validateLength(
    String? value,
    int minLength,
    int maxLength,
    String fieldName,
  ) {
    if (value == null) {
      return '$fieldName is required';
    }

    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    if (value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }

    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number <= 0) {
      return '$fieldName must be greater than 0';
    }

    return null;
  }
}
