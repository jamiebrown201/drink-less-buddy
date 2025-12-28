import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/models/intention.dart';

void main() {
  group('Intention Model', () {
    test('should create an intention with all properties', () {
      final createdAt = DateTime(2025, 1, 1, 10, 0);
      final intentionDate = DateTime(2025, 1, 2);
      final intention = Intention(
        createdAt: createdAt,
        intentionDate: intentionDate,
        activity: 'Morning workout',
        time: '8:00 AM',
        reason: 'Stay healthy',
        userId: 'user123',
      );

      expect(intention.createdAt, createdAt);
      expect(intention.intentionDate, intentionDate);
      expect(intention.activity, 'Morning workout');
      expect(intention.time, '8:00 AM');
      expect(intention.reason, 'Stay healthy');
      expect(intention.userId, 'user123');
      expect(intention.id, isNotEmpty);
    });

    test('should create an intention without optional fields', () {
      final intention = Intention(
        createdAt: DateTime.now(),
        intentionDate: DateTime.now().add(const Duration(days: 1)),
        activity: 'Important meeting',
        userId: 'user123',
      );

      expect(intention.time, isNull);
      expect(intention.reason, isNull);
    });

    test('isForTomorrow should return true for tomorrow', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final intention = Intention(
        createdAt: DateTime.now(),
        intentionDate: DateTime(tomorrow.year, tomorrow.month, tomorrow.day),
        activity: 'Test',
        userId: 'user123',
      );

      expect(intention.isForTomorrow, isTrue);
    });

    test('isForTomorrow should return false for today', () {
      final today = DateTime.now();
      final intention = Intention(
        createdAt: DateTime.now(),
        intentionDate: DateTime(today.year, today.month, today.day),
        activity: 'Test',
        userId: 'user123',
      );

      expect(intention.isForTomorrow, isFalse);
    });

    test('isForToday should return true for today', () {
      final today = DateTime.now();
      final intention = Intention(
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        intentionDate: DateTime(today.year, today.month, today.day),
        activity: 'Test',
        userId: 'user123',
      );

      expect(intention.isForToday, isTrue);
    });

    test('isForToday should return false for tomorrow', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final intention = Intention(
        createdAt: DateTime.now(),
        intentionDate: DateTime(tomorrow.year, tomorrow.month, tomorrow.day),
        activity: 'Test',
        userId: 'user123',
      );

      expect(intention.isForToday, isFalse);
    });

    test('should serialize to JSON correctly', () {
      final createdAt = DateTime(2025, 1, 1, 10, 0);
      final intentionDate = DateTime(2025, 1, 2);
      final intention = Intention(
        id: 'test-id',
        createdAt: createdAt,
        intentionDate: intentionDate,
        activity: 'Morning workout',
        time: '8:00 AM',
        reason: 'Stay healthy',
        userId: 'user123',
      );

      final json = intention.toJson();

      expect(json['id'], 'test-id');
      expect(json['createdAt'], createdAt.toIso8601String());
      expect(json['intentionDate'], intentionDate.toIso8601String());
      expect(json['activity'], 'Morning workout');
      expect(json['time'], '8:00 AM');
      expect(json['reason'], 'Stay healthy');
      expect(json['userId'], 'user123');
    });

    test('should deserialize from JSON correctly', () {
      final createdAt = DateTime(2025, 1, 1, 10, 0);
      final intentionDate = DateTime(2025, 1, 2);
      final json = {
        'id': 'test-id',
        'createdAt': createdAt.toIso8601String(),
        'intentionDate': intentionDate.toIso8601String(),
        'activity': 'Morning workout',
        'time': '8:00 AM',
        'reason': 'Stay healthy',
        'userId': 'user123',
      };

      final intention = Intention.fromJson(json);

      expect(intention.id, 'test-id');
      expect(intention.createdAt, createdAt);
      expect(intention.intentionDate, intentionDate);
      expect(intention.activity, 'Morning workout');
      expect(intention.time, '8:00 AM');
      expect(intention.reason, 'Stay healthy');
      expect(intention.userId, 'user123');
    });

    test('should handle JSON with null optional fields', () {
      final json = {
        'id': 'test-id',
        'createdAt': DateTime.now().toIso8601String(),
        'intentionDate': DateTime.now().toIso8601String(),
        'activity': 'Test',
        'time': null,
        'reason': null,
        'userId': 'user123',
      };

      final intention = Intention.fromJson(json);

      expect(intention.time, isNull);
      expect(intention.reason, isNull);
    });

    test('should round-trip through JSON serialization', () {
      final original = Intention(
        createdAt: DateTime(2025, 1, 1, 10, 0),
        intentionDate: DateTime(2025, 1, 2),
        activity: 'Morning workout',
        time: '8:00 AM',
        reason: 'Stay healthy',
        userId: 'user123',
      );

      final json = original.toJson();
      final deserialized = Intention.fromJson(json);

      expect(deserialized.id, original.id);
      expect(deserialized.createdAt, original.createdAt);
      expect(deserialized.intentionDate, original.intentionDate);
      expect(deserialized.activity, original.activity);
      expect(deserialized.time, original.time);
      expect(deserialized.reason, original.reason);
      expect(deserialized.userId, original.userId);
    });
  });
}
