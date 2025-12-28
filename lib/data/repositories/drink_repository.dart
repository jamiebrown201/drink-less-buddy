import '../../core/error/failures.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/result.dart';
import '../../core/constants/storage_keys.dart';
import '../../models/drink.dart';

/// Abstract repository for drink operations
/// Following Repository Pattern and Dependency Inversion Principle
abstract class DrinkRepository {
  Future<Result<List<Drink>>> getAllDrinks();
  Future<Result<void>> saveDrink(Drink drink);
  Future<Result<void>> deleteDrink(String drinkId);
  Future<Result<void>> updateDrink(Drink drink);
  Future<Result<void>> clearAll();
  Future<Result<List<Drink>>> getDrinksInRange(DateTime start, DateTime end);
}

/// Local implementation using StorageService
/// Can be extended with Supabase implementation for cloud sync
class DrinkRepositoryImpl implements DrinkRepository {
  final StorageService _storage;

  DrinkRepositoryImpl(this._storage);

  @override
  Future<Result<List<Drink>>> getAllDrinks() async {
    return await _storage.getJsonList(
      StorageKeys.drinksData,
      Drink.fromJson,
    );
  }

  @override
  Future<Result<void>> saveDrink(Drink drink) async {
    final drinksResult = await getAllDrinks();

    return await drinksResult.fold(
      onSuccess: (drinks) async {
        final updatedDrinks = [...drinks, drink];
        return await _saveDrinks(updatedDrinks);
      },
      onError: (failure) => Error(failure),
    );
  }

  @override
  Future<Result<void>> deleteDrink(String drinkId) async {
    final drinksResult = await getAllDrinks();

    return await drinksResult.fold(
      onSuccess: (drinks) async {
        final updatedDrinks = drinks.where((d) => d.id != drinkId).toList();
        return await _saveDrinks(updatedDrinks);
      },
      onError: (failure) => Error(failure),
    );
  }

  @override
  Future<Result<void>> updateDrink(Drink drink) async {
    final drinksResult = await getAllDrinks();

    return await drinksResult.fold(
      onSuccess: (drinks) async {
        final updatedDrinks = drinks.map((d) {
          return d.id == drink.id ? drink : d;
        }).toList();
        return await _saveDrinks(updatedDrinks);
      },
      onError: (failure) => Error(failure),
    );
  }

  @override
  Future<Result<void>> clearAll() async {
    return await _storage.remove(StorageKeys.drinksData);
  }

  @override
  Future<Result<List<Drink>>> getDrinksInRange(
    DateTime start,
    DateTime end,
  ) async {
    final drinksResult = await getAllDrinks();

    return drinksResult.map((drinks) {
      return drinks.where((drink) {
        return drink.timestamp.isAfter(start) && drink.timestamp.isBefore(end);
      }).toList();
    });
  }

  Future<Result<void>> _saveDrinks(List<Drink> drinks) async {
    return await _storage.setJsonList(
      StorageKeys.drinksData,
      drinks,
      (drink) => drink.toJson(),
    );
  }
}
