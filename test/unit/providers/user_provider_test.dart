import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/models/user.dart';
import 'package:drink_less_buddy/providers/user_provider_refactored.dart';
import 'package:drink_less_buddy/core/error/failures.dart';
import '../../helpers/mock_providers.dart';

void main() {
  group('UserProvider', () {
    late UserProvider provider;
    late MockUserRepository repository;

    setUp(() {
      repository = MockUserRepository();
      provider = UserProvider(repository);
    });

    test('should start with null user', () {
      expect(provider.user, isNull);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      expect(provider.hasError, false);
      expect(provider.hasCompletedOnboarding, false);
      expect(provider.isPremium, false);
    });

    group('loadUserData', () {
      test('should load existing user successfully', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: false,
          hasCompletedOnboarding: true,
        );

        await repository.saveUser(user);

        await provider.loadUserData();

        expect(provider.user, isNotNull);
        expect(provider.user!.id, 'user123');
        expect(provider.user!.weeklyGoalUnits, 14.0);
        expect(provider.isLoading, false);
        expect(provider.error, isNull);
      });

      test('should create new user if none exists', () async {
        await provider.loadUserData();

        expect(provider.user, isNotNull);
        expect(provider.user!.id, isNotEmpty);
        expect(provider.isLoading, false);
      });

      test('should set loading state', () async {
        var wasLoading = false;
        provider.addListener(() {
          if (provider.isLoading) {
            wasLoading = true;
          }
        });

        await provider.loadUserData();

        expect(wasLoading, true);
        expect(provider.isLoading, false);
      });

      test('should clear error before loading', () async {
        // Create an error state
        await provider.updateWeeklyGoal(-1);

        // Load user should clear the error
        await provider.loadUserData();

        expect(provider.error, isNull);
        expect(provider.hasError, false);
      });
    });

    group('confirmAge', () {
      test('should confirm user age', () async {
        await provider.loadUserData();

        final success = await provider.confirmAge();

        expect(success, true);
        expect(provider.user!.isOver18, true);
      });

      test('should return false when no user', () async {
        final success = await provider.confirmAge();

        expect(success, false);
      });

      test('should preserve other properties', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: true,
        );

        await repository.saveUser(user);
        await provider.loadUserData();

        await provider.confirmAge();

        expect(provider.user!.weeklyGoalUnits, 14.0);
        expect(provider.user!.isPremium, true);
      });
    });

    group('acceptTerms', () {
      test('should accept terms', () async {
        await provider.loadUserData();

        final success = await provider.acceptTerms();

        expect(success, true);
        expect(provider.user!.hasAcceptedTerms, true);
      });

      test('should return false when no user', () async {
        final success = await provider.acceptTerms();

        expect(success, false);
      });

      test('should preserve other properties', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isOver18: true,
        );

        await repository.saveUser(user);
        await provider.loadUserData();

        await provider.acceptTerms();

        expect(provider.user!.weeklyGoalUnits, 14.0);
        expect(provider.user!.isOver18, true);
      });
    });

    group('completeOnboarding', () {
      test('should complete onboarding without goal', () async {
        await provider.loadUserData();

        final success = await provider.completeOnboarding();

        expect(success, true);
        expect(provider.user!.hasCompletedOnboarding, true);
        expect(provider.hasCompletedOnboarding, true);
      });

      test('should complete onboarding with goal', () async {
        await provider.loadUserData();

        final success = await provider.completeOnboarding(weeklyGoal: 14.0);

        expect(success, true);
        expect(provider.user!.hasCompletedOnboarding, true);
        expect(provider.user!.weeklyGoalUnits, 14.0);
      });

      test('should return false when no user', () async {
        final success = await provider.completeOnboarding();

        expect(success, false);
      });

      test('should preserve other properties', () async {
        final user = User(
          id: 'user123',
          isOver18: true,
          hasAcceptedTerms: true,
        );

        await repository.saveUser(user);
        await provider.loadUserData();

        await provider.completeOnboarding(weeklyGoal: 21.0);

        expect(provider.user!.isOver18, true);
        expect(provider.user!.hasAcceptedTerms, true);
      });
    });

    group('updateWeeklyGoal', () {
      test('should update weekly goal', () async {
        await provider.loadUserData();
        await provider.completeOnboarding(weeklyGoal: 14.0);

        final success = await provider.updateWeeklyGoal(21.0);

        expect(success, true);
        expect(provider.user!.weeklyGoalUnits, 21.0);
      });

      test('should reject zero goal', () async {
        await provider.loadUserData();

        final success = await provider.updateWeeklyGoal(0);

        expect(success, false);
        expect(provider.error, isA<ValidationFailure>());
        expect(provider.error!.message, contains('greater than 0'));
      });

      test('should reject negative goal', () async {
        await provider.loadUserData();

        final success = await provider.updateWeeklyGoal(-5);

        expect(success, false);
        expect(provider.error, isA<ValidationFailure>());
      });

      test('should return false when no user', () async {
        final success = await provider.updateWeeklyGoal(14.0);

        expect(success, false);
      });

      test('should accept decimal values', () async {
        await provider.loadUserData();

        final success = await provider.updateWeeklyGoal(14.5);

        expect(success, true);
        expect(provider.user!.weeklyGoalUnits, 14.5);
      });

      test('should preserve other properties', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: true,
          hasCompletedOnboarding: true,
        );

        await repository.saveUser(user);
        await provider.loadUserData();

        await provider.updateWeeklyGoal(21.0);

        expect(provider.user!.isPremium, true);
        expect(provider.user!.hasCompletedOnboarding, true);
      });
    });

    group('upgradeToPremium', () {
      test('should upgrade to premium', () async {
        await provider.loadUserData();

        final success = await provider.upgradeToPremium();

        expect(success, true);
        expect(provider.user!.isPremium, true);
        expect(provider.isPremium, true);
      });

      test('should return false when no user', () async {
        final success = await provider.upgradeToPremium();

        expect(success, false);
      });

      test('should preserve other properties', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          hasCompletedOnboarding: true,
        );

        await repository.saveUser(user);
        await provider.loadUserData();

        await provider.upgradeToPremium();

        expect(provider.user!.weeklyGoalUnits, 14.0);
        expect(provider.user!.hasCompletedOnboarding, true);
      });

      test('should handle already premium user', () async {
        final user = User(
          id: 'user123',
          isPremium: true,
        );

        await repository.saveUser(user);
        await provider.loadUserData();

        final success = await provider.upgradeToPremium();

        expect(success, true);
        expect(provider.user!.isPremium, true);
      });
    });

    group('clearUserData', () {
      test('should clear user data', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: true,
        );

        await repository.saveUser(user);
        await provider.loadUserData();

        final success = await provider.clearUserData();

        expect(success, true);
        expect(provider.user, isNull);
        expect(provider.hasCompletedOnboarding, false);
        expect(provider.isPremium, false);
      });

      test('should handle clearing when no user exists', () async {
        final success = await provider.clearUserData();

        expect(success, true);
        expect(provider.user, isNull);
      });
    });

    group('Computed properties', () {
      test('hasCompletedOnboarding should reflect user state', () async {
        await provider.loadUserData();

        expect(provider.hasCompletedOnboarding, false);

        await provider.completeOnboarding();

        expect(provider.hasCompletedOnboarding, true);
      });

      test('isPremium should reflect user state', () async {
        await provider.loadUserData();

        expect(provider.isPremium, false);

        await provider.upgradeToPremium();

        expect(provider.isPremium, true);
      });

      test('hasCompletedOnboarding should return false when no user', () {
        expect(provider.hasCompletedOnboarding, false);
      });

      test('isPremium should return false when no user', () {
        expect(provider.isPremium, false);
      });
    });

    group('Integration scenarios', () {
      test('should handle complete onboarding flow', () async {
        // Initial load (creates new user)
        await provider.loadUserData();
        expect(provider.user, isNotNull);

        // Confirm age
        await provider.confirmAge();
        expect(provider.user!.isOver18, true);

        // Accept terms
        await provider.acceptTerms();
        expect(provider.user!.hasAcceptedTerms, true);

        // Complete onboarding with goal
        await provider.completeOnboarding(weeklyGoal: 14.0);
        expect(provider.user!.hasCompletedOnboarding, true);
        expect(provider.user!.weeklyGoalUnits, 14.0);

        // Verify final state
        expect(provider.hasCompletedOnboarding, true);
        expect(provider.isPremium, false);
      });

      test('should handle user lifecycle with upgrades', () async {
        await provider.loadUserData();
        await provider.completeOnboarding(weeklyGoal: 14.0);

        // Update goal
        await provider.updateWeeklyGoal(21.0);
        expect(provider.user!.weeklyGoalUnits, 21.0);

        // Upgrade to premium
        await provider.upgradeToPremium();
        expect(provider.isPremium, true);

        // Update goal again
        await provider.updateWeeklyGoal(10.0);
        expect(provider.user!.weeklyGoalUnits, 10.0);

        // Clear all data
        await provider.clearUserData();
        expect(provider.user, isNull);
      });

      test('should notify listeners on all operations', () async {
        var notifyCount = 0;
        provider.addListener(() {
          notifyCount++;
        });

        await provider.loadUserData();
        await provider.confirmAge();
        await provider.acceptTerms();
        await provider.completeOnboarding(weeklyGoal: 14.0);
        await provider.updateWeeklyGoal(21.0);
        await provider.upgradeToPremium();

        expect(notifyCount, greaterThan(0));
      });

      test('should maintain data consistency across operations', () async {
        await provider.loadUserData();
        final userId = provider.user!.id;

        await provider.confirmAge();
        expect(provider.user!.id, userId);

        await provider.acceptTerms();
        expect(provider.user!.id, userId);

        await provider.completeOnboarding(weeklyGoal: 14.0);
        expect(provider.user!.id, userId);
        expect(provider.user!.isOver18, true);
        expect(provider.user!.hasAcceptedTerms, true);
        expect(provider.user!.hasCompletedOnboarding, true);
        expect(provider.user!.weeklyGoalUnits, 14.0);
      });
    });

    group('Error handling', () {
      test('should handle validation errors', () async {
        await provider.loadUserData();

        await provider.updateWeeklyGoal(-1);

        expect(provider.hasError, true);
        expect(provider.error, isA<ValidationFailure>());
      });

      test('should clear errors on successful operations', () async {
        await provider.loadUserData();

        // Create error
        await provider.updateWeeklyGoal(-1);
        expect(provider.hasError, true);

        // Clear error with successful operation
        await provider.updateWeeklyGoal(14.0);
        expect(provider.hasError, false);
        expect(provider.error, isNull);
      });
    });
  });
}
