import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/models/drink.dart';

void main() {
  group('Drink Model', () {
    test('should create a drink with all properties', () {
      final timestamp = DateTime(2025, 1, 1, 20, 30);
      final drink = Drink(
        timestamp: timestamp,
        drinkType: 'Pint of Beer (4%)',
        units: 2.3,
        mood: 'Happy',
        context: 'Bar/Pub',
        notes: 'Test notes',
        userId: 'user123',
      );

      expect(drink.timestamp, timestamp);
      expect(drink.drinkType, 'Pint of Beer (4%)');
      expect(drink.units, 2.3);
      expect(drink.mood, 'Happy');
      expect(drink.context, 'Bar/Pub');
      expect(drink.notes, 'Test notes');
      expect(drink.userId, 'user123');
      expect(drink.id, isNotEmpty);
    });

    test('should create a drink without optional notes', () {
      final drink = Drink(
        timestamp: DateTime.now(),
        drinkType: 'Small Wine (175ml)',
        units: 2.3,
        mood: 'Stressed',
        context: 'Home',
        userId: 'user123',
      );

      expect(drink.notes, isNull);
    });

    test('should generate unique IDs for different drinks', () {
      final drink1 = Drink(
        timestamp: DateTime.now(),
        drinkType: 'Beer',
        units: 2.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      );

      final drink2 = Drink(
        timestamp: DateTime.now(),
        drinkType: 'Wine',
        units: 3.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      );

      expect(drink1.id, isNot(equals(drink2.id)));
    });

    test('should serialize to JSON correctly', () {
      final timestamp = DateTime(2025, 1, 1, 20, 30);
      final drink = Drink(
        id: 'test-id',
        timestamp: timestamp,
        drinkType: 'Pint of Beer (4%)',
        units: 2.3,
        mood: 'Happy',
        context: 'Bar/Pub',
        notes: 'Test notes',
        userId: 'user123',
      );

      final json = drink.toJson();

      expect(json['id'], 'test-id');
      expect(json['timestamp'], timestamp.toIso8601String());
      expect(json['drink_type'], 'Pint of Beer (4%)');
      expect(json['units'], 2.3);
      expect(json['mood'], 'Happy');
      expect(json['context'], 'Bar/Pub');
      expect(json['notes'], 'Test notes');
      expect(json['user_id'], 'user123');
    });

    test('should deserialize from JSON correctly', () {
      final timestamp = DateTime(2025, 1, 1, 20, 30);
      final json = {
        'id': 'test-id',
        'timestamp': timestamp.toIso8601String(),
        'drink_type': 'Pint of Beer (4%)',
        'units': 2.3,
        'mood': 'Happy',
        'context': 'Bar/Pub',
        'notes': 'Test notes',
        'user_id': 'user123',
      };

      final drink = Drink.fromJson(json);

      expect(drink.id, 'test-id');
      expect(drink.timestamp, timestamp);
      expect(drink.drinkType, 'Pint of Beer (4%)');
      expect(drink.units, 2.3);
      expect(drink.mood, 'Happy');
      expect(drink.context, 'Bar/Pub');
      expect(drink.notes, 'Test notes');
      expect(drink.userId, 'user123');
    });

    test('should handle JSON with null notes', () {
      final json = {
        'id': 'test-id',
        'timestamp': DateTime.now().toIso8601String(),
        'drink_type': 'Beer',
        'units': 2.0,
        'mood': 'Happy',
        'context': 'Home',
        'user_id': 'user123',
        'notes': null,
      };

      final drink = Drink.fromJson(json);

      expect(drink.notes, isNull);
    });

    test('should round-trip through JSON serialization', () {
      final original = Drink(
        timestamp: DateTime(2025, 1, 1, 20, 30),
        drinkType: 'Large Wine (250ml)',
        units: 3.3,
        mood: 'Celebrating',
        context: 'Restaurant',
        notes: 'Birthday dinner',
        userId: 'user123',
      );

      final json = original.toJson();
      final deserialized = Drink.fromJson(json);

      expect(deserialized.id, original.id);
      expect(deserialized.timestamp, original.timestamp);
      expect(deserialized.drinkType, original.drinkType);
      expect(deserialized.units, original.units);
      expect(deserialized.mood, original.mood);
      expect(deserialized.context, original.context);
      expect(deserialized.notes, original.notes);
      expect(deserialized.userId, original.userId);
    });
  });
}
