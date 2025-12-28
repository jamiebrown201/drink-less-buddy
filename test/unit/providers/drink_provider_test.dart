import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/models/drink.dart';
import 'package:drink_less_buddy/providers/drink_provider_refactored.dart';
import '../../helpers/mock_providers.dart';

void main() {
  group('DrinkProvider', () {
    late DrinkProvider provider;
    late MockDrinkRepository repository;

    setUp(() {
      repository = MockDrinkRepository();
      provider = DrinkProvider(repository);
    });

    test('should start with empty drinks list', () {
      expect(provider.drinks, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });

    test('should load drinks successfully', () async {
      // Add mock data
      await repository.saveDrink(Drink(
        timestamp: DateTime.now(),
        drinkType: 'Beer',
        units: 2.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      ));

      await provider.loadDrinks();

      expect(provider.drinks, hasLength(1));
      expect(provider.drinks.first.drinkType, 'Beer');
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });

    test('should log a drink successfully', () async {
      final drink = Drink(
        timestamp: DateTime.now(),
        drinkType: 'Wine',
        units: 3.0,
        mood: 'Celebrating',
        context: 'Restaurant',
        userId: 'user123',
      );

      final success = await provider.logDrink(drink);

      expect(success, true);
      expect(provider.drinks, contains(drink));
      expect(provider.error, isNull);
    });

    test('should delete a drink successfully', () async {
      final drink = Drink(
        timestamp: DateTime.now(),
        drinkType: 'Beer',
        units: 2.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      );

      await provider.logDrink(drink);
      expect(provider.drinks, hasLength(1));

      final success = await provider.deleteDrink(drink.id);

      expect(success, true);
      expect(provider.drinks, isEmpty);
    });

    test('should calculate current week units correctly', () async {
      final now = DateTime.now();
      final today = Drink(
        timestamp: now,
        drinkType: 'Beer',
        units: 2.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      );

      final yesterday = Drink(
        timestamp: now.subtract(const Duration(days: 1)),
        drinkType: 'Wine',
        units: 3.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      );

      final lastWeek = Drink(
        timestamp: now.subtract(const Duration(days: 8)),
        drinkType: 'Beer',
        units: 2.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      );

      await provider.logDrink(today);
      await provider.logDrink(yesterday);
      await provider.logDrink(lastWeek);

      final weekUnits = provider.getCurrentWeekUnits();

      expect(weekUnits, 5.0); // Should only include today and yesterday
    });

    test('should get most common mood', () async {
      await provider.logDrink(Drink(
        timestamp: DateTime.now(),
        drinkType: 'Beer',
        units: 2.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      ));

      await provider.logDrink(Drink(
        timestamp: DateTime.now(),
        drinkType: 'Wine',
        units: 3.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      ));

      await provider.logDrink(Drink(
        timestamp: DateTime.now(),
        drinkType: 'Beer',
        units: 2.0,
        mood: 'Stressed',
        context: 'Home',
        userId: 'user123',
      ));

      final mostCommon = provider.getMostCommonMood();

      expect(mostCommon, 'Happy');
    });

    test('should get most common context', () async {
      await provider.logDrink(Drink(
        timestamp: DateTime.now(),
        drinkType: 'Beer',
        units: 2.0,
        mood: 'Happy',
        context: 'Bar/Pub',
        userId: 'user123',
      ));

      await provider.logDrink(Drink(
        timestamp: DateTime.now(),
        drinkType: 'Wine',
        units: 3.0,
        mood: 'Happy',
        context: 'Bar/Pub',
        userId: 'user123',
      ));

      await provider.logDrink(Drink(
        timestamp: DateTime.now(),
        drinkType: 'Beer',
        units: 2.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      ));

      final mostCommon = provider.getMostCommonContext();

      expect(mostCommon, 'Bar/Pub');
    });

    test('should calculate average units per session', () async {
      await provider.logDrink(Drink(
        timestamp: DateTime.now(),
        drinkType: 'Beer',
        units: 2.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      ));

      await provider.logDrink(Drink(
        timestamp: DateTime.now(),
        drinkType: 'Wine',
        units: 4.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      ));

      final average = provider.getAverageUnitsPerSession();

      expect(average, 3.0);
    });

    test('should clear all drinks', () async {
      await provider.logDrink(Drink(
        timestamp: DateTime.now(),
        drinkType: 'Beer',
        units: 2.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      ));

      expect(provider.drinks, hasLength(1));

      await provider.clearAllDrinks();

      expect(provider.drinks, isEmpty);
    });

    test('should notify listeners when drinks change', () async {
      var notified = false;
      provider.addListener(() {
        notified = true;
      });

      await provider.logDrink(Drink(
        timestamp: DateTime.now(),
        drinkType: 'Beer',
        units: 2.0,
        mood: 'Happy',
        context: 'Home',
        userId: 'user123',
      ));

      expect(notified, true);
    });
  });
}
