import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drink_less_buddy/data/repositories/drink_repository.dart';
import 'package:drink_less_buddy/core/services/storage_service.dart';
import 'package:drink_less_buddy/models/drink.dart';
import 'package:drink_less_buddy/core/utils/result.dart';

void main() {
  group('DrinkRepository', () {
    late DrinkRepository repository;
    late StorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = SharedPrefsStorageService();
      await storage.init();
      repository = DrinkRepositoryImpl(storage);
    });

    group('getAllDrinks', () {
      test('should return empty list when no drinks exist', () async {
        final result = await repository.getAllDrinks();

        expect(result.isSuccess, true);
        expect(result.value, isEmpty);
      });

      test('should return all saved drinks', () async {
        final drink1 = Drink(
          timestamp: DateTime(2024, 1, 1),
          drinkType: 'Beer',
          units: 2.0,
          mood: 'Happy',
          context: 'Home',
          userId: 'user123',
        );

        final drink2 = Drink(
          timestamp: DateTime(2024, 1, 2),
          drinkType: 'Wine',
          units: 3.0,
          mood: 'Celebrating',
          context: 'Restaurant',
          userId: 'user123',
        );

        await repository.saveDrink(drink1);
        await repository.saveDrink(drink2);

        final result = await repository.getAllDrinks();

        expect(result.isSuccess, true);
        expect(result.value, hasLength(2));
        expect(result.value[0].drinkType, 'Beer');
        expect(result.value[1].drinkType, 'Wine');
      });

      test('should deserialize drinks correctly', () async {
        final drink = Drink(
          timestamp: DateTime(2024, 1, 1, 14, 30),
          drinkType: 'Pint of Beer (4%)',
          units: 2.3,
          mood: 'Relaxed',
          context: 'Bar/Pub',
          userId: 'user123',
        );

        await repository.saveDrink(drink);

        final result = await repository.getAllDrinks();

        expect(result.isSuccess, true);
        expect(result.value.first.drinkType, 'Pint of Beer (4%)');
        expect(result.value.first.units, 2.3);
        expect(result.value.first.mood, 'Relaxed');
        expect(result.value.first.context, 'Bar/Pub');
      });
    });

    group('saveDrink', () {
      test('should save drink successfully', () async {
        final drink = Drink(
          timestamp: DateTime.now(),
          drinkType: 'Beer',
          units: 2.0,
          mood: 'Happy',
          context: 'Home',
          userId: 'user123',
        );

        final result = await repository.saveDrink(drink);

        expect(result.isSuccess, true);

        final allDrinks = await repository.getAllDrinks();
        expect(allDrinks.value, hasLength(1));
        expect(allDrinks.value.first.id, drink.id);
      });

      test('should append to existing drinks', () async {
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
          mood: 'Celebrating',
          context: 'Restaurant',
          userId: 'user123',
        );

        await repository.saveDrink(drink1);
        await repository.saveDrink(drink2);

        final result = await repository.getAllDrinks();

        expect(result.value, hasLength(2));
      });

      test('should preserve all drink properties', () async {
        final timestamp = DateTime(2024, 1, 1, 14, 30);
        final drink = Drink(
          timestamp: timestamp,
          drinkType: 'Pint of Beer (4%)',
          units: 2.3,
          mood: 'Relaxed',
          context: 'Bar/Pub',
          userId: 'user123',
        );

        await repository.saveDrink(drink);

        final result = await repository.getAllDrinks();
        final saved = result.value.first;

        expect(saved.id, drink.id);
        expect(saved.timestamp, timestamp);
        expect(saved.drinkType, 'Pint of Beer (4%)');
        expect(saved.units, 2.3);
        expect(saved.mood, 'Relaxed');
        expect(saved.context, 'Bar/Pub');
        expect(saved.userId, 'user123');
      });
    });

    group('deleteDrink', () {
      test('should delete drink by id', () async {
        final drink = Drink(
          timestamp: DateTime.now(),
          drinkType: 'Beer',
          units: 2.0,
          mood: 'Happy',
          context: 'Home',
          userId: 'user123',
        );

        await repository.saveDrink(drink);

        final deleteResult = await repository.deleteDrink(drink.id);

        expect(deleteResult.isSuccess, true);

        final allDrinks = await repository.getAllDrinks();
        expect(allDrinks.value, isEmpty);
      });

      test('should only delete specified drink', () async {
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
          mood: 'Celebrating',
          context: 'Restaurant',
          userId: 'user123',
        );

        await repository.saveDrink(drink1);
        await repository.saveDrink(drink2);

        await repository.deleteDrink(drink1.id);

        final result = await repository.getAllDrinks();

        expect(result.value, hasLength(1));
        expect(result.value.first.id, drink2.id);
      });

      test('should handle deleting non-existent drink', () async {
        final result = await repository.deleteDrink('non-existent-id');

        expect(result.isSuccess, true);

        final allDrinks = await repository.getAllDrinks();
        expect(allDrinks.value, isEmpty);
      });
    });

    group('updateDrink', () {
      test('should update existing drink', () async {
        final drink = Drink(
          timestamp: DateTime.now(),
          drinkType: 'Beer',
          units: 2.0,
          mood: 'Happy',
          context: 'Home',
          userId: 'user123',
        );

        await repository.saveDrink(drink);

        final updated = Drink(
          id: drink.id,
          timestamp: drink.timestamp,
          drinkType: 'Wine',
          units: 3.0,
          mood: 'Celebrating',
          context: 'Restaurant',
          userId: 'user123',
        );

        final updateResult = await repository.updateDrink(updated);

        expect(updateResult.isSuccess, true);

        final result = await repository.getAllDrinks();

        expect(result.value, hasLength(1));
        expect(result.value.first.drinkType, 'Wine');
        expect(result.value.first.units, 3.0);
      });

      test('should only update specified drink', () async {
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
          mood: 'Celebrating',
          context: 'Restaurant',
          userId: 'user123',
        );

        await repository.saveDrink(drink1);
        await repository.saveDrink(drink2);

        final updated = Drink(
          id: drink1.id,
          timestamp: drink1.timestamp,
          drinkType: 'Whiskey',
          units: 1.0,
          mood: 'Stressed',
          context: 'Home',
          userId: 'user123',
        );

        await repository.updateDrink(updated);

        final result = await repository.getAllDrinks();

        expect(result.value, hasLength(2));
        expect(result.value[0].drinkType, 'Whiskey');
        expect(result.value[1].drinkType, 'Wine');
      });

      test('should preserve drink ID', () async {
        final drink = Drink(
          timestamp: DateTime.now(),
          drinkType: 'Beer',
          units: 2.0,
          mood: 'Happy',
          context: 'Home',
          userId: 'user123',
        );

        await repository.saveDrink(drink);

        final updated = Drink(
          id: drink.id,
          timestamp: drink.timestamp,
          drinkType: 'Wine',
          units: 3.0,
          mood: 'Celebrating',
          context: 'Restaurant',
          userId: 'user123',
        );

        await repository.updateDrink(updated);

        final result = await repository.getAllDrinks();

        expect(result.value.first.id, drink.id);
      });
    });

    group('clearAll', () {
      test('should remove all drinks', () async {
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
          mood: 'Celebrating',
          context: 'Restaurant',
          userId: 'user123',
        );

        await repository.saveDrink(drink1);
        await repository.saveDrink(drink2);

        final clearResult = await repository.clearAll();

        expect(clearResult.isSuccess, true);

        final result = await repository.getAllDrinks();
        expect(result.value, isEmpty);
      });

      test('should handle clearing empty repository', () async {
        final result = await repository.clearAll();

        expect(result.isSuccess, true);

        final allDrinks = await repository.getAllDrinks();
        expect(allDrinks.value, isEmpty);
      });
    });

    group('getDrinksInRange', () {
      test('should return drinks within date range', () async {
        final drink1 = Drink(
          timestamp: DateTime(2024, 1, 5),
          drinkType: 'Beer',
          units: 2.0,
          mood: 'Happy',
          context: 'Home',
          userId: 'user123',
        );

        final drink2 = Drink(
          timestamp: DateTime(2024, 1, 10),
          drinkType: 'Wine',
          units: 3.0,
          mood: 'Celebrating',
          context: 'Restaurant',
          userId: 'user123',
        );

        final drink3 = Drink(
          timestamp: DateTime(2024, 1, 15),
          drinkType: 'Beer',
          units: 2.0,
          mood: 'Relaxed',
          context: 'Home',
          userId: 'user123',
        );

        await repository.saveDrink(drink1);
        await repository.saveDrink(drink2);
        await repository.saveDrink(drink3);

        final result = await repository.getDrinksInRange(
          DateTime(2024, 1, 1),
          DateTime(2024, 1, 12),
        );

        expect(result.isSuccess, true);
        expect(result.value, hasLength(2));
        expect(result.value[0].timestamp, DateTime(2024, 1, 5));
        expect(result.value[1].timestamp, DateTime(2024, 1, 10));
      });

      test('should return empty list when no drinks in range', () async {
        final drink = Drink(
          timestamp: DateTime(2024, 1, 15),
          drinkType: 'Beer',
          units: 2.0,
          mood: 'Happy',
          context: 'Home',
          userId: 'user123',
        );

        await repository.saveDrink(drink);

        final result = await repository.getDrinksInRange(
          DateTime(2024, 1, 1),
          DateTime(2024, 1, 10),
        );

        expect(result.isSuccess, true);
        expect(result.value, isEmpty);
      });

      test('should exclude boundary dates', () async {
        final startDrink = Drink(
          timestamp: DateTime(2024, 1, 1),
          drinkType: 'Beer',
          units: 2.0,
          mood: 'Happy',
          context: 'Home',
          userId: 'user123',
        );

        final middleDrink = Drink(
          timestamp: DateTime(2024, 1, 5),
          drinkType: 'Wine',
          units: 3.0,
          mood: 'Celebrating',
          context: 'Restaurant',
          userId: 'user123',
        );

        final endDrink = Drink(
          timestamp: DateTime(2024, 1, 10),
          drinkType: 'Beer',
          units: 2.0,
          mood: 'Relaxed',
          context: 'Home',
          userId: 'user123',
        );

        await repository.saveDrink(startDrink);
        await repository.saveDrink(middleDrink);
        await repository.saveDrink(endDrink);

        final result = await repository.getDrinksInRange(
          DateTime(2024, 1, 1),
          DateTime(2024, 1, 10),
        );

        expect(result.isSuccess, true);
        expect(result.value, hasLength(1));
        expect(result.value.first.timestamp, DateTime(2024, 1, 5));
      });
    });

    group('Integration scenarios', () {
      test('should handle full CRUD operations', () async {
        // Create
        final drink = Drink(
          timestamp: DateTime.now(),
          drinkType: 'Beer',
          units: 2.0,
          mood: 'Happy',
          context: 'Home',
          userId: 'user123',
        );

        await repository.saveDrink(drink);

        // Read
        var allDrinks = await repository.getAllDrinks();
        expect(allDrinks.value, hasLength(1));

        // Update
        final updated = Drink(
          id: drink.id,
          timestamp: drink.timestamp,
          drinkType: 'Wine',
          units: 3.0,
          mood: 'Celebrating',
          context: 'Restaurant',
          userId: 'user123',
        );

        await repository.updateDrink(updated);

        allDrinks = await repository.getAllDrinks();
        expect(allDrinks.value.first.drinkType, 'Wine');

        // Delete
        await repository.deleteDrink(drink.id);

        allDrinks = await repository.getAllDrinks();
        expect(allDrinks.value, isEmpty);
      });

      test('should maintain data integrity across operations', () async {
        final drinks = List.generate(
          10,
          (i) => Drink(
            timestamp: DateTime.now().subtract(Duration(days: i)),
            drinkType: 'Drink $i',
            units: i.toDouble() + 1,
            mood: 'Mood $i',
            context: 'Context $i',
            userId: 'user123',
          ),
        );

        for (final drink in drinks) {
          await repository.saveDrink(drink);
        }

        final result = await repository.getAllDrinks();
        expect(result.value, hasLength(10));

        // Verify all unique IDs
        final ids = result.value.map((d) => d.id).toSet();
        expect(ids, hasLength(10));
      });
    });
  });
}
