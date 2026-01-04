import 'package:drink_less_buddy/core/error/failures.dart';
import 'package:drink_less_buddy/core/utils/result.dart';
import 'package:drink_less_buddy/models/drink.dart';
import 'package:drink_less_buddy/models/intention.dart';
import 'package:drink_less_buddy/models/user.dart';
import 'package:drink_less_buddy/providers/drink_provider_refactored.dart';
import 'package:drink_less_buddy/providers/intention_provider_refactored.dart';
import 'package:drink_less_buddy/providers/user_provider_refactored.dart';
import 'package:drink_less_buddy/data/repositories/drink_repository.dart';
import 'package:drink_less_buddy/data/repositories/intention_repository.dart';
import 'package:drink_less_buddy/data/repositories/user_repository.dart';

/// Mock DrinkProvider for testing
class MockDrinkProvider extends DrinkProvider {
  MockDrinkProvider() : super(MockDrinkRepository());

  @override
  List<Drink> get drinks => _mockDrinks;

  @override
  bool get isLoading => false;

  @override
  Failure? get error => null;

  final List<Drink> _mockDrinks = [
    Drink(
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      drinkType: 'Pint of Beer (4%)',
      units: 2.3,
      mood: 'Happy',
      context: 'Home',
      userId: 'test-user',
    ),
    Drink(
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      drinkType: 'Large Wine (250ml)',
      units: 3.3,
      mood: 'Stressed',
      context: 'Restaurant',
      userId: 'test-user',
    ),
  ];
}

/// Mock IntentionProvider for testing
class MockIntentionProvider extends IntentionProvider {
  MockIntentionProvider() : super(MockIntentionRepository());

  @override
  List<Intention> get intentions => _mockIntentions;

  @override
  bool get isLoading => false;

  @override
  Failure? get error => null;

  final List<Intention> _mockIntentions = [
    Intention(
      createdAt: DateTime.now(),
      intentionDate: DateTime.now().add(const Duration(days: 1)),
      activity: 'Morning workout',
      time: '8:00 AM',
      reason: 'Stay healthy',
      userId: 'test-user',
    ),
  ];
}

/// Mock UserProvider for testing
class MockUserProvider extends UserProvider {
  MockUserProvider() : super(MockUserRepository());

  @override
  User? get user => _mockUser;

  @override
  bool get isLoading => false;

  @override
  Failure? get error => null;

  @override
  bool get hasCompletedOnboarding => true;

  final User _mockUser = User(
    id: 'test-user',
    createdAt: DateTime.now(),
    weeklyGoalUnits: 14.0,
    isPremium: false,
    hasCompletedOnboarding: true,
    hasAcceptedTerms: true,
    isOver18: true,
  );
}

/// Mock DrinkRepository for testing
class MockDrinkRepository implements DrinkRepository {
  final List<Drink> _drinks = [];

  @override
  Future<Result<List<Drink>>> getAllDrinks() async {
    return Success(_drinks);
  }

  @override
  Future<Result<void>> saveDrink(Drink drink) async {
    _drinks.add(drink);
    return const Success(null);
  }

  @override
  Future<Result<void>> deleteDrink(String id) async {
    _drinks.removeWhere((d) => d.id == id);
    return const Success(null);
  }

  @override
  Future<Result<void>> updateDrink(Drink drink) async {
    final index = _drinks.indexWhere((d) => d.id == drink.id);
    if (index != -1) {
      _drinks[index] = drink;
      return const Success(null);
    }
    return Error(StorageFailure('Drink not found'));
  }

  @override
  Future<Result<void>> clearAll() async {
    _drinks.clear();
    return const Success(null);
  }

  @override
  Future<Result<List<Drink>>> getDrinksInRange(DateTime start, DateTime end) async {
    final filtered = _drinks.where((d) {
      return d.timestamp.isAfter(start) && d.timestamp.isBefore(end);
    }).toList();
    return Success(filtered);
  }
}

/// Mock IntentionRepository for testing
class MockIntentionRepository implements IntentionRepository {
  final List<Intention> _intentions = [];

  @override
  Future<Result<List<Intention>>> getAllIntentions() async {
    return Success(_intentions);
  }

  @override
  Future<Result<void>> saveIntention(Intention intention) async {
    _intentions.add(intention);
    return const Success(null);
  }

  @override
  Future<Result<void>> deleteIntention(String id) async {
    _intentions.removeWhere((i) => i.id == id);
    return const Success(null);
  }

  @override
  Future<Result<void>> updateIntention(Intention intention) async {
    final index = _intentions.indexWhere((i) => i.id == intention.id);
    if (index != -1) {
      _intentions[index] = intention;
      return const Success(null);
    }
    return Error(StorageFailure('Intention not found'));
  }

  @override
  Future<Result<void>> clearAll() async {
    _intentions.clear();
    return const Success(null);
  }

  @override
  Future<Result<List<Intention>>> getIntentionsForDate(DateTime date) async {
    final targetDay = DateTime(date.year, date.month, date.day);
    final filtered = _intentions.where((i) {
      final intentionDay = DateTime(
        i.intentionDate.year,
        i.intentionDate.month,
        i.intentionDate.day,
      );
      return intentionDay.isAtSameMomentAs(targetDay);
    }).toList();
    return Success(filtered);
  }
}

/// Mock UserRepository for testing
class MockUserRepository implements UserRepository {
  User? _user;

  @override
  Future<Result<User?>> getUser() async {
    return Success(_user);
  }

  @override
  Future<Result<void>> saveUser(User user) async {
    _user = user;
    return const Success(null);
  }

  @override
  Future<Result<void>> deleteUser() async {
    _user = null;
    return const Success(null);
  }

  @override
  Future<Result<void>> updateWeeklyGoal(double goal) async {
    if (_user == null) {
      return const Error(StorageFailure('User not found'));
    }
    _user = _user!.copyWith(weeklyGoalUnits: goal);
    return const Success(null);
  }

  @override
  Future<Result<void>> upgradeToPremium() async {
    if (_user == null) {
      return const Error(StorageFailure('User not found'));
    }
    _user = _user!.copyWith(isPremium: true);
    return const Success(null);
  }
}
