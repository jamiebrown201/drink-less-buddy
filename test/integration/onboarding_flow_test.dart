import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/screens/onboarding/age_verification_screen_animated.dart';
import 'package:drink_less_buddy/screens/onboarding/legal_disclaimer_screen_animated.dart';
import 'package:drink_less_buddy/screens/onboarding/welcome_screen_animated.dart';
import 'package:drink_less_buddy/core/widgets/glass_button.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Onboarding Flow Integration Test', () {
    testWidgets('age verification screen displays correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(
          const AgeVerificationScreenAnimated(),
        ),
      );
      await pumpAndSettle(tester);

      // Verify age verification screen elements
      expect(find.text('Age Verification'), findsOneWidget);
      expect(find.text('I am 18 or older'), findsOneWidget);
      expect(find.text('I am under 18'), findsOneWidget);
      expect(find.byIcon(Icons.verified_user), findsOneWidget);
    });

    testWidgets('legal disclaimer screen displays medical information', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(
          const LegalDisclaimerScreenAnimated(),
        ),
      );
      await pumpAndSettle(tester);

      // Verify legal disclaimer content
      expect(findTextContaining('Medical Disclaimer'), findsOneWidget);
      expect(findTextContaining('Not a Medical Device'), findsOneWidget);
      expect(findTextContaining('Not a Substitute'), findsOneWidget);
    });

    testWidgets('legal disclaimer has terms and privacy checkboxes', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(
          const LegalDisclaimerScreenAnimated(),
        ),
      );
      await pumpAndSettle(tester);

      // Find checkboxes - there should be 2 (terms and privacy)
      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(2));

      // Both should be unchecked initially
      final termsCheckbox = tester.widget<Checkbox>(checkboxes.first);
      final privacyCheckbox = tester.widget<Checkbox>(checkboxes.last);
      expect(termsCheckbox.value, false);
      expect(privacyCheckbox.value, false);
    });

    testWidgets('welcome screen displays feature cards', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(
          const WelcomeScreenAnimated(),
        ),
      );
      await pumpAndSettle(tester);

      // Verify welcome screen content
      expect(findTextContaining('Welcome to'), findsOneWidget);
      expect(findTextContaining('Self-Monitoring'), findsOneWidget);
      expect(findTextContaining('Personalized Feedback'), findsOneWidget);
    });

    testWidgets('welcome screen has recommended limit option', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(
          const WelcomeScreenAnimated(),
        ),
      );
      await pumpAndSettle(tester);

      // Scroll to goal section
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await pumpAndSettle(tester);

      // Verify recommended limit option
      expect(findTextContaining('recommended low-risk limit'), findsOneWidget);
      expect(findTextContaining('14 units per week'), findsOneWidget);
    });
  });
}
