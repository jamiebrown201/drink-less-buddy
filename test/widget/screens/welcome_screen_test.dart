import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/screens/onboarding/welcome_screen_animated.dart';
import 'package:drink_less_buddy/core/widgets/animated_card.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('WelcomeScreenAnimated', () {
    testWidgets('should display welcome message', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(const WelcomeScreenAnimated()),
      );
      await pumpAndSettle(tester);

      // The welcome text is a single multiline text widget
      expect(findTextContaining('Welcome to'), findsOneWidget);
      expect(findTextContaining('Drink Less Buddy'), findsOneWidget);
    });

    testWidgets('should display feature cards', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(const WelcomeScreenAnimated()),
      );
      await pumpAndSettle(tester);

      // Uses AnimatedCard, not Card
      expect(find.byType(AnimatedCard), findsWidgets);
      expect(findTextContaining('Self-Monitoring'), findsOneWidget);
      expect(findTextContaining('Personalized Feedback'), findsOneWidget);
    });

    testWidgets('should have recommended limit selected by default', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(const WelcomeScreenAnimated()),
      );
      await pumpAndSettle(tester);

      // Scroll to make checkbox visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await pumpAndSettle(tester);

      final checkbox = find.byType(Checkbox).first;
      final checkboxWidget = tester.widget<Checkbox>(checkbox);

      expect(checkboxWidget.value, true);
    });

    testWidgets('should display 14 units for recommended limit', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(const WelcomeScreenAnimated()),
      );
      await pumpAndSettle(tester);

      // Scroll to make goal section visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await pumpAndSettle(tester);

      expect(findTextContaining('14'), findsWidgets);
    });

    testWidgets('should have Get Started button', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(const WelcomeScreenAnimated()),
      );
      await pumpAndSettle(tester);

      // Scroll to bottom for Get Started button
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -600));
      await pumpAndSettle(tester);

      expect(findTextContaining('Get Started'), findsOneWidget);
    });

    testWidgets('should have CheckboxListTile for recommended limit toggle', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(const WelcomeScreenAnimated()),
      );
      await pumpAndSettle(tester);

      // Slider should not be visible when recommended limit is selected (default)
      expect(find.byType(Slider), findsNothing);

      // Find the CheckboxListTile and ensure it's visible by scrolling
      final checkboxListTile = find.byType(CheckboxListTile);
      await tester.ensureVisible(checkboxListTile);
      await pumpAndSettle(tester);

      // Verify CheckboxListTile exists for recommended limit toggle
      expect(checkboxListTile, findsOneWidget);

      // Verify the label text contains recommended limit info
      expect(findTextContaining('recommended low-risk limit'), findsOneWidget);
      expect(findTextContaining('14 units per week'), findsOneWidget);
    });
  });
}
