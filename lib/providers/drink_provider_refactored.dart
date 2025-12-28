import 'package:flutter/foundation.dart';
import '../data/repositories/drink_repository.dart';
import '../models/drink.dart';
import '../core/error/failures.dart';

/// Provider for drink state management
/// Following Single Responsibility - only manages state, delegates data ops to repository
class DrinkProvider with ChangeNotifier {
  final DrinkRepository _repository;

  DrinkProvider(this._repository);

  List<Drink> _drinks = [];
  bool _isLoading = false;
  Failure? _error;

  // Getters
  List<Drink> get drinks => List.unmodifiable(_drinks);
  bool get isLoading => _isLoading;
  Failure? get error => _error;
  bool get hasError => _error != null;

  /// Load all drinks from repository
  Future<void> loadDrinks() async {
    _setLoading(true);
    _clearError();

    final result = await _repository.getAllDrinks();

    result.fold(
      onSuccess: (drinks) {
        _drinks = drinks;
        _setLoading(false);
      },
      onError: (failure) {
        _setError(failure);
        _setLoading(false);
      },
    );
  }

  /// Log a new drink
  Future<bool> logDrink(Drink drink) async {
    _clearError();

    final result = await _repository.saveDrink(drink);

    return result.fold(
      onSuccess: (_) {
        _drinks = [..._drinks, drink];
        notifyListeners();
        return true;
      },
      onError: (failure) {
        _setError(failure);
        return false;
      },
    );
  }

  /// Delete a drink
  Future<bool> deleteDrink(String drinkId) async {
    _clearError();

    final result = await _repository.deleteDrink(drinkId);

    return result.fold(
      onSuccess: (_) {
        _drinks = _drinks.where((d) => d.id != drinkId).toList();
        notifyListeners();
        return true;
      },
      onError: (failure) {
        _setError(failure);
        return false;
      },
    );
  }

  /// Get drinks within a date range
  List<Drink> getDrinksInRange(DateTime start, DateTime end) {
    return _drinks.where((drink) {
      return drink.timestamp.isAfter(start) && drink.timestamp.isBefore(end);
    }).toList();
  }

  /// Get drinks for current week
  List<Drink> getCurrentWeekDrinks() {
    final now = DateTime.now();
    final startOfWeek = _getStartOfWeek(now);
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    return getDrinksInRange(startOfWeek, endOfWeek);
  }

  /// Get total units for current week
  double getCurrentWeekUnits() {
    return getCurrentWeekDrinks()
        .fold(0.0, (sum, drink) => sum + drink.units);
  }

  /// Get total units for a specific date
  double getUnitsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getDrinksInRange(startOfDay, endOfDay)
        .fold(0.0, (sum, drink) => sum + drink.units);
  }

  /// Get most common mood
  String? getMostCommonMood() {
    if (_drinks.isEmpty) return null;
    return _getMostFrequent(_drinks.map((d) => d.mood));
  }

  /// Get most common context
  String? getMostCommonContext() {
    if (_drinks.isEmpty) return null;
    return _getMostFrequent(_drinks.map((d) => d.context));
  }

  /// Get context breakdown as percentages
  Map<String, double> getContextBreakdown() {
    if (_drinks.isEmpty) return {};
    return _getBreakdown(_drinks.map((d) => d.context));
  }

  /// Get mood breakdown as percentages
  Map<String, double> getMoodBreakdown() {
    if (_drinks.isEmpty) return {};
    return _getBreakdown(_drinks.map((d) => d.mood));
  }

  /// Get average units per drinking session
  double getAverageUnitsPerSession() {
    if (_drinks.isEmpty) return 0.0;

    // Group drinks by day
    final drinksByDay = <String, List<Drink>>{};
    for (final drink in _drinks) {
      final dateKey = _getDateKey(drink.timestamp);
      drinksByDay.putIfAbsent(dateKey, () => []).add(drink);
    }

    final totalSessions = drinksByDay.length;
    final totalUnits = _drinks.fold(0.0, (sum, drink) => sum + drink.units);

    return totalUnits / totalSessions;
  }

  /// Clear all drinks
  Future<bool> clearAllDrinks() async {
    _clearError();

    final result = await _repository.clearAll();

    return result.fold(
      onSuccess: (_) {
        _drinks = [];
        notifyListeners();
        return true;
      },
      onError: (failure) {
        _setError(failure);
        return false;
      },
    );
  }

  // Private helper methods

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(Failure failure) {
    _error = failure;
    notifyListeners();
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  DateTime _getStartOfWeek(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  String _getMostFrequent(Iterable<String> items) {
    final counts = <String, int>{};
    for (final item in items) {
      counts[item] = (counts[item] ?? 0) + 1;
    }
    return counts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  Map<String, double> _getBreakdown(Iterable<String> items) {
    final counts = <String, int>{};
    for (final item in items) {
      counts[item] = (counts[item] ?? 0) + 1;
    }

    final total = items.length;
    return counts.map(
      (key, count) => MapEntry(key, (count / total) * 100),
    );
  }
}
