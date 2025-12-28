import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/screens/onboarding/welcome_screen_animated.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('WelcomeScreenAnimated', () {
    testWidgets('should display welcome message', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(const WelcomeScreenAnimated()),
      );
      await pumpAndSettle(tester);

      expect(find.text('Welcome to'), findsOneWidget);
      expect(find.text('Drink Less Buddy'), findsOneWidget);
    });

    testWidgets('should display feature cards', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(const WelcomeScreenAnimated()),
      );
      await pumpAndSettle(tester);

      expect(find.byType(Card), findsWidgets);
      expect(findTextContaining('Self-Monitoring'), findsOneWidget);
      expect(findTextContaining('Personalized Feedback'), findsOneWidget);
    });

    testWidgets('should have UK guideline selected by default', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(const WelcomeScreenAnimated()),
      );
      await pumpAndSettle(tester);

      final checkbox = find.byType(Checkbox).first;
      final checkboxWidget = tester.widget<Checkbox>(checkbox);

      expect(checkboxWidget.value, true);
    });

    testWidgets('should display 14 units for UK guideline', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(const WelcomeScreenAnimated()),
      );
      await pumpAndSettle(tester);

      expect(find.text('14'), findsOneWidget);
    });

    testWidgets('should have Get Started button', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(const WelcomeScreenAnimated()),
      );
      await pumpAndSettle(tester);

      expect(findTextContaining('Get Started'), findsOneWidget);
    });

    testWidgets('should allow toggling between UK guideline and custom goal', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(const WelcomeScreenAnimated()),
      );
      await pumpAndSettle(tester);

      // Find and tap the custom goal checkbox
      final customCheckbox = find.byType(Checkbox).last;
      await tapAndSettle(tester, customCheckbox);

      // Custom input field should be enabled
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
    });
  });
}
