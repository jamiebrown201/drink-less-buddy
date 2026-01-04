import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/models/user.dart';

void main() {
  group('User Model', () {
    test('should create a user with all properties', () {
      final createdAt = DateTime(2025, 1, 1);
      final user = User(
        id: 'user123',
        createdAt: createdAt,
        weeklyGoalUnits: 14.0,
        isPremium: true,
        hasCompletedOnboarding: true,
        hasAcceptedTerms: true,
        isOver18: true,
      );

      expect(user.id, 'user123');
      expect(user.createdAt, createdAt);
      expect(user.weeklyGoalUnits, 14.0);
      expect(user.isPremium, true);
      expect(user.hasCompletedOnboarding, true);
      expect(user.hasAcceptedTerms, true);
      expect(user.isOver18, true);
    });

    test('should create a user with default values', () {
      final createdAt = DateTime.now();
      final user = User(id: 'user123', createdAt: createdAt);

      expect(user.weeklyGoalUnits, isNull);
      expect(user.isPremium, false);
      expect(user.hasCompletedOnboarding, false);
      expect(user.hasAcceptedTerms, false);
      expect(user.isOver18, false);
    });

    test('should serialize to JSON correctly', () {
      final createdAt = DateTime(2025, 1, 1);
      final user = User(
        id: 'user123',
        createdAt: createdAt,
        weeklyGoalUnits: 14.0,
        isPremium: true,
        hasCompletedOnboarding: true,
        hasAcceptedTerms: true,
        isOver18: true,
      );

      final json = user.toJson();

      expect(json['id'], 'user123');
      expect(json['created_at'], createdAt.toIso8601String());
      expect(json['weekly_goal_units'], 14.0);
      expect(json['is_premium'], true);
      expect(json['has_completed_onboarding'], true);
      expect(json['has_accepted_terms'], true);
      expect(json['is_over_18'], true);
    });

    test('should deserialize from JSON correctly', () {
      final createdAt = DateTime(2025, 1, 1);
      final json = {
        'id': 'user123',
        'created_at': createdAt.toIso8601String(),
        'weekly_goal_units': 14.0,
        'is_premium': true,
        'has_completed_onboarding': true,
        'has_accepted_terms': true,
        'is_over_18': true,
      };

      final user = User.fromJson(json);

      expect(user.id, 'user123');
      expect(user.createdAt, createdAt);
      expect(user.weeklyGoalUnits, 14.0);
      expect(user.isPremium, true);
      expect(user.hasCompletedOnboarding, true);
      expect(user.hasAcceptedTerms, true);
      expect(user.isOver18, true);
    });

    test('should handle null weeklyGoalUnits in JSON', () {
      final json = {
        'id': 'user123',
        'created_at': DateTime.now().toIso8601String(),
        'weekly_goal_units': null,
        'is_premium': false,
        'has_completed_onboarding': false,
        'has_accepted_terms': false,
        'is_over_18': false,
      };

      final user = User.fromJson(json);

      expect(user.weeklyGoalUnits, isNull);
    });

    test('should round-trip through JSON serialization', () {
      final original = User(
        id: 'user123',
        createdAt: DateTime(2025, 1, 1),
        weeklyGoalUnits: 21.0,
        isPremium: true,
        hasCompletedOnboarding: true,
        hasAcceptedTerms: true,
        isOver18: true,
      );

      final json = original.toJson();
      final deserialized = User.fromJson(json);

      expect(deserialized.id, original.id);
      expect(deserialized.createdAt, original.createdAt);
      expect(deserialized.weeklyGoalUnits, original.weeklyGoalUnits);
      expect(deserialized.isPremium, original.isPremium);
      expect(deserialized.hasCompletedOnboarding, original.hasCompletedOnboarding);
      expect(deserialized.hasAcceptedTerms, original.hasAcceptedTerms);
      expect(deserialized.isOver18, original.isOver18);
    });

    test('copyWith should create a new user with updated values', () {
      final original = User(
        id: 'user123',
        createdAt: DateTime(2025, 1, 1),
        weeklyGoalUnits: 14.0,
        isPremium: false,
      );

      final updated = original.copyWith(
        weeklyGoalUnits: 21.0,
        isPremium: true,
      );

      expect(updated.id, 'user123');
      expect(updated.weeklyGoalUnits, 21.0);
      expect(updated.isPremium, true);
      expect(updated.hasCompletedOnboarding, false); // Unchanged
    });

    test('copyWith should preserve unchanged values', () {
      final original = User(
        id: 'user123',
        createdAt: DateTime(2025, 1, 1),
        weeklyGoalUnits: 14.0,
        isPremium: true,
        hasCompletedOnboarding: true,
      );

      final updated = original.copyWith(isPremium: false);

      expect(updated.id, 'user123');
      expect(updated.weeklyGoalUnits, 14.0);
      expect(updated.isPremium, false);
      expect(updated.hasCompletedOnboarding, true);
    });
  });
}
