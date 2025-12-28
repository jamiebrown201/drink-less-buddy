import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/drink.dart';
import 'dart:convert';

class DrinkProvider with ChangeNotifier {
  List<Drink> _drinks = [];
  bool _isLoading = false;

  List<Drink> get drinks => _drinks;
  bool get isLoading => _isLoading;

  /// Load drinks from local storage
  Future<void> loadDrinks() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final drinksJson = prefs.getString('drinks_data');

    if (drinksJson != null) {
      final List<dynamic> decoded = json.decode(drinksJson);
      _drinks = decoded.map((d) => Drink.fromJson(d)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Save drinks to local storage
  Future<void> _saveDrinks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_drinks.map((d) => d.toJson()).toList());
    await prefs.setString('drinks_data', encoded);
  }

  /// Log a new drink
  Future<void> logDrink(Drink drink) async {
    _drinks.add(drink);
    await _saveDrinks();
    notifyListeners();
  }

  /// Delete a drink
  Future<void> deleteDrink(String drinkId) async {
    _drinks.removeWhere((d) => d.id == drinkId);
    await _saveDrinks();
    notifyListeners();
  }

  /// Get drinks for a specific date range
  List<Drink> getDrinksInRange(DateTime start, DateTime end) {
    return _drinks.where((drink) {
      return drink.timestamp.isAfter(start) && drink.timestamp.isBefore(end);
    }).toList();
  }

  /// Get drinks for current week
  List<Drink> getCurrentWeekDrinks() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekMidnight = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );
    final endOfWeek = startOfWeekMidnight.add(const Duration(days: 7));

    return getDrinksInRange(startOfWeekMidnight, endOfWeek);
  }

  /// Get total units for current week
  double getCurrentWeekUnits() {
    return getCurrentWeekDrinks().fold(0.0, (sum, drink) => sum + drink.units);
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

    final moodCounts = <String, int>{};
    for (final drink in _drinks) {
      moodCounts[drink.mood] = (moodCounts[drink.mood] ?? 0) + 1;
    }

    return moodCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Get most common context
  String? getMostCommonContext() {
    if (_drinks.isEmpty) return null;

    final contextCounts = <String, int>{};
    for (final drink in _drinks) {
      contextCounts[drink.context] = (contextCounts[drink.context] ?? 0) + 1;
    }

    return contextCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Get context breakdown (percentage of drinks in each context)
  Map<String, double> getContextBreakdown() {
    if (_drinks.isEmpty) return {};

    final contextCounts = <String, int>{};
    for (final drink in _drinks) {
      contextCounts[drink.context] = (contextCounts[drink.context] ?? 0) + 1;
    }

    final total = _drinks.length;
    return contextCounts.map(
      (context, count) => MapEntry(context, (count / total) * 100),
    );
  }

  /// Get mood breakdown
  Map<String, double> getMoodBreakdown() {
    if (_drinks.isEmpty) return {};

    final moodCounts = <String, int>{};
    for (final drink in _drinks) {
      moodCounts[drink.mood] = (moodCounts[drink.mood] ?? 0) + 1;
    }

    final total = _drinks.length;
    return moodCounts.map(
      (mood, count) => MapEntry(mood, (count / total) * 100),
    );
  }

  /// Get average units per drinking session
  double getAverageUnitsPerSession() {
    if (_drinks.isEmpty) return 0.0;

    // Group drinks by day
    final drinksByDay = <String, List<Drink>>{};
    for (final drink in _drinks) {
      final dateKey =
          '${drink.timestamp.year}-${drink.timestamp.month}-${drink.timestamp.day}';
      drinksByDay[dateKey] = [...(drinksByDay[dateKey] ?? []), drink];
    }

    // Calculate average
    final totalSessions = drinksByDay.length;
    final totalUnits = _drinks.fold(0.0, (sum, drink) => sum + drink.units);

    return totalUnits / totalSessions;
  }

  /// Clear all drink data
  Future<void> clearAllDrinks() async {
    _drinks = [];
    await _saveDrinks();
    notifyListeners();
  }
}
