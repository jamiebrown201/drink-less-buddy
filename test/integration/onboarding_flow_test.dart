import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/screens/onboarding/age_verification_screen_animated.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Onboarding Flow Integration Test', () {
    testWidgets('should complete full onboarding flow', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(
          const AgeVerificationScreenAnimated(),
        ),
      );
      await pumpAndSettle(tester);

      // 1. Age Verification Screen
      expect(find.text('Age Verification'), findsOneWidget);
      expect(findTextContaining('18 or older'), findsOneWidget);

      // Tap "I am 18 or older"
      final confirmAgeButton = find.text('I am 18 or older');
      await tapAndSettle(tester, confirmAgeButton);

      // 2. Legal Disclaimer Screen should appear
      expect(findTextContaining('Medical Disclaimer'), findsOneWidget);
      expect(findTextContaining('Not a Medical Device'), findsOneWidget);

      // Tap "I Understand"
      final understandButton = find.text('I Understand');
      await tapAndSettle(tester, understandButton);

      // 3. Terms of Service Screen should appear
      expect(find.text('Terms & Privacy'), findsOneWidget);

      // Accept terms and privacy
      final termsCheckbox = find.byType(Checkbox).first;
      await tapAndSettle(tester, termsCheckbox);

      final privacyCheckbox = find.byType(Checkbox).last;
      await tapAndSettle(tester, privacyCheckbox);

      // Tap "Continue"
      final continueButton = find.text('Continue');
      await tapAndSettle(tester, continueButton);

      // 4. Welcome Screen should appear
      expect(findTextContaining('Welcome to'), findsOneWidget);
      expect(findTextContaining('Drink Less Buddy'), findsOneWidget);

      // Complete onboarding
      final getStartedButton = findTextContaining('Get Started');
      await tapAndSettle(tester, getStartedButton);

      // 5. Home Screen should appear (or at least onboarding should be complete)
      // Note: In real app, this would navigate to HomeScreenAnimated
      // For testing, we verify the flow reaches this point without errors
    });

    testWidgets('should show error when under 18', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(
          const AgeVerificationScreenAnimated(),
        ),
      );
      await pumpAndSettle(tester);

      // Tap "I am under 18"
      final underAgeButton = find.text('I am under 18');
      await tapAndSettle(tester, underAgeButton);

      // Error dialog should appear
      expect(find.text('Access Denied'), findsOneWidget);
      expect(findTextContaining('must be 18'), findsOneWidget);
    });

    testWidgets('should not allow continuing without accepting terms', (tester) async {
      await tester.pumpWidget(
        createTestWidgetWithProviders(
          const AgeVerificationScreenAnimated(),
        ),
      );
      await pumpAndSettle(tester);

      // Complete age verification
      await tapAndSettle(tester, find.text('I am 18 or older'));
      await pumpAndSettle(tester);

      // Complete legal disclaimer
      await tapAndSettle(tester, find.text('I Understand'));
      await pumpAndSettle(tester);

      // On terms screen, try to continue without accepting
      final continueButton = find.text('Continue');
      final button = tester.widget<TextButton>(
        find.ancestor(
          of: continueButton,
          matching: find.byType(TextButton),
        ),
      );

      // Button should be disabled
      expect(button.onPressed, isNull);
    });
  });
}
