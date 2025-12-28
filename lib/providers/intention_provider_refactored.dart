import 'package:flutter/foundation.dart';
import '../data/repositories/intention_repository.dart';
import '../models/intention.dart';
import '../core/error/failures.dart';

/// Provider for intention state management
/// Following Single Responsibility Principle
class IntentionProvider with ChangeNotifier {
  final IntentionRepository _repository;

  IntentionProvider(this._repository);

  List<Intention> _intentions = [];
  bool _isLoading = false;
  Failure? _error;

  // Getters
  List<Intention> get intentions => List.unmodifiable(_intentions);
  bool get isLoading => _isLoading;
  Failure? get error => _error;
  bool get hasError => _error != null;

  /// Load all intentions from repository
  Future<void> loadIntentions() async {
    _setLoading(true);
    _clearError();

    final result = await _repository.getAllIntentions();

    result.fold(
      onSuccess: (intentions) {
        _intentions = intentions;
        _setLoading(false);
      },
      onError: (failure) {
        _setError(failure);
        _setLoading(false);
      },
    );
  }

  /// Add a new intention
  Future<bool> addIntention(Intention intention) async {
    _clearError();

    final result = await _repository.saveIntention(intention);

    return result.fold(
      onSuccess: (_) {
        _intentions = [..._intentions, intention];
        notifyListeners();
        return true;
      },
      onError: (failure) {
        _setError(failure);
        return false;
      },
    );
  }

  /// Update an existing intention
  Future<bool> updateIntention(Intention intention) async {
    _clearError();

    final result = await _repository.updateIntention(intention);

    return result.fold(
      onSuccess: (_) {
        _intentions = _intentions.map((i) {
          return i.id == intention.id ? intention : i;
        }).toList();
        notifyListeners();
        return true;
      },
      onError: (failure) {
        _setError(failure);
        return false;
      },
    );
  }

  /// Mark intention as completed
  Future<bool> completeIntention(String intentionId) async {
    final intention = _intentions.firstWhere((i) => i.id == intentionId);
    final updatedIntention = intention.copyWith(isCompleted: true);
    return await updateIntention(updatedIntention);
  }

  /// Delete an intention
  Future<bool> deleteIntention(String intentionId) async {
    _clearError();

    final result = await _repository.deleteIntention(intentionId);

    return result.fold(
      onSuccess: (_) {
        _intentions = _intentions.where((i) => i.id != intentionId).toList();
        notifyListeners();
        return true;
      },
      onError: (failure) {
        _setError(failure);
        return false;
      },
    );
  }

  /// Get intentions for tomorrow
  List<Intention> getTomorrowIntentions() {
    return _intentions.where((i) => i.isForTomorrow()).toList();
  }

  /// Get intentions for today
  List<Intention> getTodayIntentions() {
    return _intentions.where((i) => i.isForToday()).toList();
  }

  /// Get incomplete intentions for today
  List<Intention> getTodayIncompleteIntentions() {
    return _intentions
        .where((i) => i.isForToday() && !i.isCompleted)
        .toList();
  }

  /// Get completion rate for today's intentions
  double getTodayCompletionRate() {
    final todayIntentions = getTodayIntentions();
    if (todayIntentions.isEmpty) return 0.0;

    final completed = todayIntentions.where((i) => i.isCompleted).length;
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
  Future<bool> clearAllIntentions() async {
    _clearError();

    final result = await _repository.clearAll();

    return result.fold(
      onSuccess: (_) {
        _intentions = [];
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
}
