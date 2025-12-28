import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/models/user.dart';

void main() {
  group('User Model', () {
    test('should create a user with all properties', () {
      final user = User(
        id: 'user123',
        weeklyGoalUnits: 14.0,
        isPremium: true,
        hasCompletedOnboarding: true,
        hasAcceptedTerms: true,
        hasConfirmedAge: true,
      );

      expect(user.id, 'user123');
      expect(user.weeklyGoalUnits, 14.0);
      expect(user.isPremium, true);
      expect(user.hasCompletedOnboarding, true);
      expect(user.hasAcceptedTerms, true);
      expect(user.hasConfirmedAge, true);
    });

    test('should create a user with default values', () {
      final user = User(id: 'user123');

      expect(user.weeklyGoalUnits, isNull);
      expect(user.isPremium, false);
      expect(user.hasCompletedOnboarding, false);
      expect(user.hasAcceptedTerms, false);
      expect(user.hasConfirmedAge, false);
    });

    test('should serialize to JSON correctly', () {
      final user = User(
        id: 'user123',
        weeklyGoalUnits: 14.0,
        isPremium: true,
        hasCompletedOnboarding: true,
        hasAcceptedTerms: true,
        hasConfirmedAge: true,
      );

      final json = user.toJson();

      expect(json['id'], 'user123');
      expect(json['weeklyGoalUnits'], 14.0);
      expect(json['isPremium'], true);
      expect(json['hasCompletedOnboarding'], true);
      expect(json['hasAcceptedTerms'], true);
      expect(json['hasConfirmedAge'], true);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'user123',
        'weeklyGoalUnits': 14.0,
        'isPremium': true,
        'hasCompletedOnboarding': true,
        'hasAcceptedTerms': true,
        'hasConfirmedAge': true,
      };

      final user = User.fromJson(json);

      expect(user.id, 'user123');
      expect(user.weeklyGoalUnits, 14.0);
      expect(user.isPremium, true);
      expect(user.hasCompletedOnboarding, true);
      expect(user.hasAcceptedTerms, true);
      expect(user.hasConfirmedAge, true);
    });

    test('should handle null weeklyGoalUnits in JSON', () {
      final json = {
        'id': 'user123',
        'weeklyGoalUnits': null,
        'isPremium': false,
        'hasCompletedOnboarding': false,
        'hasAcceptedTerms': false,
        'hasConfirmedAge': false,
      };

      final user = User.fromJson(json);

      expect(user.weeklyGoalUnits, isNull);
    });

    test('should round-trip through JSON serialization', () {
      final original = User(
        id: 'user123',
        weeklyGoalUnits: 21.0,
        isPremium: true,
        hasCompletedOnboarding: true,
        hasAcceptedTerms: true,
        hasConfirmedAge: true,
      );

      final json = original.toJson();
      final deserialized = User.fromJson(json);

      expect(deserialized.id, original.id);
      expect(deserialized.weeklyGoalUnits, original.weeklyGoalUnits);
      expect(deserialized.isPremium, original.isPremium);
      expect(deserialized.hasCompletedOnboarding, original.hasCompletedOnboarding);
      expect(deserialized.hasAcceptedTerms, original.hasAcceptedTerms);
      expect(deserialized.hasConfirmedAge, original.hasConfirmedAge);
    });

    test('copyWith should create a new user with updated values', () {
      final original = User(
        id: 'user123',
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
