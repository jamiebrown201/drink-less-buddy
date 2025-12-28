import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/intention.dart';
import 'dart:convert';

/// Provider for managing daily intentions
/// Evidence-based feature: prospective planning reduces consumption by 31-33%
class IntentionProvider with ChangeNotifier {
  List<Intention> _intentions = [];
  bool _isLoading = false;

  List<Intention> get intentions => _intentions;
  bool get isLoading => _isLoading;

  /// Load intentions from local storage
  Future<void> loadIntentions() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final intentionsJson = prefs.getString('intentions_data');

    if (intentionsJson != null) {
      final List<dynamic> decoded = json.decode(intentionsJson);
      _intentions = decoded.map((i) => Intention.fromJson(i)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Save intentions to local storage
  Future<void> _saveIntentions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_intentions.map((i) => i.toJson()).toList());
    await prefs.setString('intentions_data', encoded);
  }

  /// Add a new intention
  Future<void> addIntention(Intention intention) async {
    _intentions.add(intention);
    await _saveIntentions();
    notifyListeners();
  }

  /// Update an intention
  Future<void> updateIntention(Intention intention) async {
    final index = _intentions.indexWhere((i) => i.id == intention.id);
    if (index != -1) {
      _intentions[index] = intention;
      await _saveIntentions();
      notifyListeners();
    }
  }

  /// Mark intention as completed
  Future<void> completeIntention(String intentionId) async {
    final index = _intentions.indexWhere((i) => i.id == intentionId);
    if (index != -1) {
      _intentions[index] = _intentions[index].copyWith(isCompleted: true);
      await _saveIntentions();
      notifyListeners();
    }
  }

  /// Delete an intention
  Future<void> deleteIntention(String intentionId) async {
    _intentions.removeWhere((i) => i.id == intentionId);
    await _saveIntentions();
    notifyListeners();
  }

  /// Get intentions for tomorrow
  List<Intention> getTomorrowIntentions() {
    return _intentions.where((i) => i.isForTomorrow()).toList();
  }

  /// Get intentions for today
  List<Intention> getTodayIntentions() {
    return _intentions.where((i) => i.isForToday()).toList();
  }

  /// Get all incomplete intentions for today
  List<Intention> getTodayIncompleteIntentions() {
    return _intentions
        .where((i) => i.isForToday() && !i.isCompleted)
        .toList();
  }

  /// Get completion rate for today's intentions
  double getTodayCompletionRate() {
    final todayIntentions = getTodayIntentions();
    if (todayIntentions.isEmpty) return 0.0;

    final completed =
        todayIntentions.where((i) => i.isCompleted).length;
    return (completed / todayIntentions.length) * 100;
  }

  /// Check if user has intentions for tomorrow
  bool hasTomorrowIntentions() {
    return getTomorrowIntentions().isNotEmpty;
  }

  /// Get intentions for a specific date
  List<Intention> getIntentionsForDate(DateTime date) {
    final targetDay = DateTime(date.year, date.month, date.day);
    return _intentions.where((i) {
      final intentionDay = DateTime(
        i.intentionDate.year,
        i.intentionDate.month,
        i.intentionDate.day,
      );
      return intentionDay.isAtSameMomentAs(targetDay);
    }).toList();
  }

  /// Clear all intentions
  Future<void> clearAllIntentions() async {
    _intentions = [];
    await _saveIntentions();
    notifyListeners();
  }
}
