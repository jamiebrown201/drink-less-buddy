import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drink_less_buddy/data/repositories/user_repository.dart';
import 'package:drink_less_buddy/core/services/storage_service.dart';
import 'package:drink_less_buddy/models/user.dart';
import 'package:drink_less_buddy/core/error/failures.dart';

void main() {
  group('UserRepository', () {
    late UserRepository repository;
    late StorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = SharedPrefsStorageService();
      await storage.init();
      repository = UserRepositoryImpl(storage);
    });

    group('getUser', () {
      test('should return null when no user exists', () async {
        final result = await repository.getUser();

        expect(result.isSuccess, true);
        expect(result.value, isNull);
      });

      test('should return saved user', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: false,
          hasCompletedOnboarding: true,
          hasAcceptedTerms: true,
          hasConfirmedAge: true,
        );

        await repository.saveUser(user);

        final result = await repository.getUser();

        expect(result.isSuccess, true);
        expect(result.value, isNotNull);
        expect(result.value!.id, 'user123');
        expect(result.value!.weeklyGoalUnits, 14.0);
      });

      test('should deserialize user correctly', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 21.5,
          isPremium: true,
          hasCompletedOnboarding: true,
          hasAcceptedTerms: true,
          hasConfirmedAge: true,
        );

        await repository.saveUser(user);

        final result = await repository.getUser();

        expect(result.value!.id, 'user123');
        expect(result.value!.weeklyGoalUnits, 21.5);
        expect(result.value!.isPremium, true);
        expect(result.value!.hasCompletedOnboarding, true);
        expect(result.value!.hasAcceptedTerms, true);
        expect(result.value!.hasConfirmedAge, true);
      });
    });

    group('saveUser', () {
      test('should save user successfully', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: false,
          hasCompletedOnboarding: true,
          hasAcceptedTerms: true,
          hasConfirmedAge: true,
        );

        final result = await repository.saveUser(user);

        expect(result.isSuccess, true);

        final savedUser = await repository.getUser();
        expect(savedUser.value, isNotNull);
        expect(savedUser.value!.id, 'user123');
      });

      test('should overwrite existing user', () async {
        final user1 = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: false,
        );

        final user2 = User(
          id: 'user456',
          weeklyGoalUnits: 21.0,
          isPremium: true,
        );

        await repository.saveUser(user1);
        await repository.saveUser(user2);

        final result = await repository.getUser();

        expect(result.value!.id, 'user456');
        expect(result.value!.weeklyGoalUnits, 21.0);
        expect(result.value!.isPremium, true);
      });

      test('should preserve all user properties', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.5,
          isPremium: true,
          hasCompletedOnboarding: true,
          hasAcceptedTerms: true,
          hasConfirmedAge: true,
        );

        await repository.saveUser(user);

        final result = await repository.getUser();
        final saved = result.value!;

        expect(saved.id, 'user123');
        expect(saved.weeklyGoalUnits, 14.5);
        expect(saved.isPremium, true);
        expect(saved.hasCompletedOnboarding, true);
        expect(saved.hasAcceptedTerms, true);
        expect(saved.hasConfirmedAge, true);
      });

      test('should handle null weeklyGoalUnits', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: null,
          isPremium: false,
        );

        await repository.saveUser(user);

        final result = await repository.getUser();

        expect(result.value!.weeklyGoalUnits, isNull);
      });
    });

    group('deleteUser', () {
      test('should delete existing user', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: false,
        );

        await repository.saveUser(user);

        final deleteResult = await repository.deleteUser();

        expect(deleteResult.isSuccess, true);

        final getResult = await repository.getUser();
        expect(getResult.value, isNull);
      });

      test('should handle deleting when no user exists', () async {
        final result = await repository.deleteUser();

        expect(result.isSuccess, true);

        final getResult = await repository.getUser();
        expect(getResult.value, isNull);
      });
    });

    group('updateWeeklyGoal', () {
      test('should update weekly goal for existing user', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: false,
        );

        await repository.saveUser(user);

        final updateResult = await repository.updateWeeklyGoal(21.0);

        expect(updateResult.isSuccess, true);

        final result = await repository.getUser();
        expect(result.value!.weeklyGoalUnits, 21.0);
      });

      test('should preserve other user properties', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: true,
          hasCompletedOnboarding: true,
          hasAcceptedTerms: true,
          hasConfirmedAge: true,
        );

        await repository.saveUser(user);

        await repository.updateWeeklyGoal(10.0);

        final result = await repository.getUser();

        expect(result.value!.id, 'user123');
        expect(result.value!.weeklyGoalUnits, 10.0);
        expect(result.value!.isPremium, true);
        expect(result.value!.hasCompletedOnboarding, true);
        expect(result.value!.hasAcceptedTerms, true);
        expect(result.value!.hasConfirmedAge, true);
      });

      test('should return error when user not found', () async {
        final result = await repository.updateWeeklyGoal(14.0);

        expect(result.isFailure, true);
        expect(result.failure, isA<StorageFailure>());
        expect(result.failure.message, contains('User not found'));
      });

      test('should accept decimal values', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: false,
        );

        await repository.saveUser(user);

        await repository.updateWeeklyGoal(15.5);

        final result = await repository.getUser();
        expect(result.value!.weeklyGoalUnits, 15.5);
      });
    });

    group('upgradeToPremium', () {
      test('should upgrade user to premium', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: false,
        );

        await repository.saveUser(user);

        final upgradeResult = await repository.upgradeToPremium();

        expect(upgradeResult.isSuccess, true);

        final result = await repository.getUser();
        expect(result.value!.isPremium, true);
      });

      test('should preserve other user properties', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: false,
          hasCompletedOnboarding: true,
          hasAcceptedTerms: true,
          hasConfirmedAge: true,
        );

        await repository.saveUser(user);

        await repository.upgradeToPremium();

        final result = await repository.getUser();

        expect(result.value!.id, 'user123');
        expect(result.value!.weeklyGoalUnits, 14.0);
        expect(result.value!.isPremium, true);
        expect(result.value!.hasCompletedOnboarding, true);
        expect(result.value!.hasAcceptedTerms, true);
        expect(result.value!.hasConfirmedAge, true);
      });

      test('should return error when user not found', () async {
        final result = await repository.upgradeToPremium();

        expect(result.isFailure, true);
        expect(result.failure, isA<StorageFailure>());
        expect(result.failure.message, contains('User not found'));
      });

      test('should handle already premium user', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: true,
        );

        await repository.saveUser(user);

        final result = await repository.upgradeToPremium();

        expect(result.isSuccess, true);

        final getResult = await repository.getUser();
        expect(getResult.value!.isPremium, true);
      });
    });

    group('Integration scenarios', () {
      test('should handle complete user lifecycle', () async {
        // Create new user
        final newUser = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: false,
          hasCompletedOnboarding: false,
          hasAcceptedTerms: false,
          hasConfirmedAge: false,
        );

        await repository.saveUser(newUser);

        // Complete onboarding
        var user = (await repository.getUser()).value!;
        final onboarded = user.copyWith(
          hasCompletedOnboarding: true,
          hasAcceptedTerms: true,
          hasConfirmedAge: true,
        );
        await repository.saveUser(onboarded);

        // Update weekly goal
        await repository.updateWeeklyGoal(21.0);

        // Upgrade to premium
        await repository.upgradeToPremium();

        // Verify final state
        final result = await repository.getUser();
        final final_ = result.value!;

        expect(final_.id, 'user123');
        expect(final_.weeklyGoalUnits, 21.0);
        expect(final_.isPremium, true);
        expect(final_.hasCompletedOnboarding, true);
        expect(final_.hasAcceptedTerms, true);
        expect(final_.hasConfirmedAge, true);
      });

      test('should handle multiple goal updates', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: false,
        );

        await repository.saveUser(user);

        // Simulate user adjusting their goal over time
        await repository.updateWeeklyGoal(21.0);
        await repository.updateWeeklyGoal(10.0);
        await repository.updateWeeklyGoal(14.0);

        final result = await repository.getUser();
        expect(result.value!.weeklyGoalUnits, 14.0);
      });

      test('should handle user deletion and recreation', () async {
        final user1 = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: true,
        );

        await repository.saveUser(user1);
        await repository.deleteUser();

        var result = await repository.getUser();
        expect(result.value, isNull);

        // Create new user
        final user2 = User(
          id: 'user456',
          weeklyGoalUnits: 21.0,
          isPremium: false,
        );

        await repository.saveUser(user2);

        result = await repository.getUser();
        expect(result.value!.id, 'user456');
        expect(result.value!.weeklyGoalUnits, 21.0);
        expect(result.value!.isPremium, false);
      });

      test('should maintain data consistency across operations', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: 14.0,
          isPremium: false,
          hasCompletedOnboarding: true,
        );

        await repository.saveUser(user);

        // Multiple updates
        await repository.updateWeeklyGoal(20.0);
        await repository.upgradeToPremium();
        await repository.updateWeeklyGoal(15.0);

        final result = await repository.getUser();

        expect(result.value!.id, 'user123');
        expect(result.value!.weeklyGoalUnits, 15.0);
        expect(result.value!.isPremium, true);
        expect(result.value!.hasCompletedOnboarding, true);
      });

      test('should handle edge case with null goal', () async {
        final user = User(
          id: 'user123',
          weeklyGoalUnits: null,
          isPremium: false,
        );

        await repository.saveUser(user);

        await repository.updateWeeklyGoal(14.0);

        final result = await repository.getUser();
        expect(result.value!.weeklyGoalUnits, 14.0);
      });
    });

    group('Error handling', () {
      test('should handle update operations on non-existent user', () async {
        final goalResult = await repository.updateWeeklyGoal(14.0);
        expect(goalResult.isFailure, true);

        final premiumResult = await repository.upgradeToPremium();
        expect(premiumResult.isFailure, true);
      });

      test('should provide clear error messages', () async {
        final goalResult = await repository.updateWeeklyGoal(14.0);
        expect(goalResult.failure.message, 'User not found');

        final premiumResult = await repository.upgradeToPremium();
        expect(premiumResult.failure.message, 'User not found');
      });
    });
  });
}
