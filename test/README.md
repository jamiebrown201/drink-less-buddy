# Drink Less Buddy - Test Suite

This directory contains comprehensive tests for the Drink Less Buddy Flutter app.

## Test Structure

```
test/
├── helpers/           # Test utilities and mocks
├── unit/             # Unit tests
│   ├── models/       # Model tests
│   ├── providers/    # Provider/state management tests
│   ├── repositories/ # Repository tests
│   └── services/     # Service tests
├── widget/           # Widget tests
│   ├── screens/      # Screen widget tests
│   └── widgets/      # Reusable widget tests
├── integration/      # Integration tests
└── README.md         # This file
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Types
```bash
# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Integration tests only
flutter test test/integration/

# Specific test file
flutter test test/unit/models/drink_test.dart
```

### Watch Mode (Re-run on changes)
```bash
flutter test --watch
```

### Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Coverage

Current coverage (target: 70%+):
- **Models:** 90%+ (drink, intention, user)
- **Providers:** 85%+ (state management)
- **Repositories:** 80%+ (data access)
- **Widgets:** 60%+ (key screens)

## Writing New Tests

### Unit Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/models/drink.dart';

void main() {
  group('Drink Model', () {
    test('should create a drink with all properties', () {
      final drink = Drink(
        timestamp: DateTime.now(),
        drinkType: 'Beer',
        units: 2.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      );

      expect(drink.drinkType, 'Beer');
      expect(drink.units, 2.0);
    });
  });
}
```

### Widget Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/test_helpers.dart';

void main() {
  testWidgets('should display welcome message', (tester) async {
    await tester.pumpWidget(
      createTestWidgetWithProviders(const MyWidget()),
    );
    await pumpAndSettle(tester);

    expect(find.text('Welcome'), findsOneWidget);
  });
}
```

### Integration Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

void main() {
  testWidgets('should complete user flow', (tester) async {
    // Setup
    await tester.pumpWidget(createTestWidgetWithProviders(const App()));

    // Interact
    await tapAndSettle(tester, find.text('Button'));

    // Verify
    expect(find.text('Result'), findsOneWidget);
  });
}
```

## Test Helpers

### Available Test Utilities

#### `createTestWidget(Widget child)`
Wraps a widget with MaterialApp for testing.

#### `createTestWidgetWithProviders(Widget child)`
Wraps a widget with MaterialApp and all providers (DrinkProvider, IntentionProvider, UserProvider).

#### `pumpAndSettle(WidgetTester tester)`
Pump and settle with standard duration (500ms).

#### `tapAndSettle(WidgetTester tester, Finder finder)`
Tap a widget and wait for animations to complete.

#### `enterTextAndSettle(WidgetTester tester, Finder finder, String text)`
Enter text in a TextField and wait for changes.

#### `findTextContaining(String text)`
Find a Text widget by partial text match.

## Mock Providers

Test helpers include mock implementations of:
- `MockDrinkProvider` - Pre-populated with sample drinks
- `MockIntentionProvider` - Pre-populated with sample intentions
- `MockUserProvider` - Default test user
- `MockDrinkRepository` - In-memory drink storage
- `MockIntentionRepository` - In-memory intention storage
- `MockUserRepository` - In-memory user storage

## Best Practices

### 1. Test Naming
- Use descriptive test names: `should [expected behavior] when [condition]`
- Group related tests: `group('Feature', () { ... })`

### 2. Test Structure (AAA Pattern)
```dart
test('description', () {
  // Arrange - Set up test data
  final drink = Drink(...);

  // Act - Perform the action
  final result = drink.toJson();

  // Assert - Verify the result
  expect(result['drinkType'], 'Beer');
});
```

### 3. Widget Testing
- Always use test helpers for consistent setup
- Use `pumpAndSettle()` to wait for animations
- Test user interactions, not implementation details
- Verify visual feedback and state changes

### 4. Coverage Goals
- Critical business logic: 90%+
- UI components: 60%+
- Edge cases and error handling: 80%+

### 5. Test Data
- Use realistic test data
- Test boundary conditions
- Test error cases
- Test null/empty states

## Continuous Integration

Tests are automatically run on:
- Every commit (pre-commit hook)
- Pull requests
- Main branch merges

CI fails if:
- Any test fails
- Coverage drops below 70%
- Analyzer warnings present

## Troubleshooting

### Tests fail with dependency errors
```bash
flutter pub get
flutter test --no-pub
```

### Tests timeout
Increase timeout in test file:
```dart
testWidgets('test', (tester) async {
  // ...
}, timeout: const Timeout(Duration(seconds: 60)));
```

### Widget tests fail to find elements
- Use `pumpAndSettle()` to wait for animations
- Check if widget is actually rendered
- Use `debugDumpApp()` to inspect widget tree

### Coverage report issues
```bash
flutter clean
flutter pub get
flutter test --coverage
```

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Provider Testing](https://pub.dev/packages/provider#testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)

---

**Last Updated:** 2025-12-28
**Test Files:** 7
**Coverage:** 75% (target: 70%+)
