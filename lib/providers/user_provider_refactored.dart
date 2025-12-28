import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../data/repositories/user_repository.dart';
import '../models/user.dart';
import '../core/error/failures.dart';

/// Provider for user state management
/// Following Single Responsibility Principle
class UserProvider with ChangeNotifier {
  final UserRepository _repository;

  UserProvider(this._repository);

  User? _user;
  bool _isLoading = false;
  Failure? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  Failure? get error => _error;
  bool get hasError => _error != null;
  bool get hasCompletedOnboarding => _user?.hasCompletedOnboarding ?? false;
  bool get isPremium => _user?.isPremium ?? false;

  /// Load user data from repository
  Future<void> loadUserData() async {
    _setLoading(true);
    _clearError();

    final result = await _repository.getUser();

    result.fold(
      onSuccess: (user) {
        if (user == null) {
          // Create new user if none exists
          _user = User(
            id: const Uuid().v4(),
            createdAt: DateTime.now(),
          );
          _saveCurrentUser();
        } else {
          _user = user;
        }
        _setLoading(false);
      },
      onError: (failure) {
        _setError(failure);
        _setLoading(false);
      },
    );
  }

  /// Confirm user age
  Future<bool> confirmAge() async {
    if (_user == null) return false;

    final updatedUser = _user!.copyWith(isOver18: true);
    return await _updateUser(updatedUser);
  }

  /// Accept terms and conditions
  Future<bool> acceptTerms() async {
    if (_user == null) return false;

    final updatedUser = _user!.copyWith(hasAcceptedTerms: true);
    return await _updateUser(updatedUser);
  }

  /// Complete onboarding
  Future<bool> completeOnboarding({double? weeklyGoal}) async {
    if (_user == null) return false;

    final updatedUser = _user!.copyWith(
      hasCompletedOnboarding: true,
      weeklyGoalUnits: weeklyGoal,
    );
    return await _updateUser(updatedUser);
  }

  /// Update weekly goal
  Future<bool> updateWeeklyGoal(double goal) async {
    if (_user == null) return false;

    // Validate goal
    if (goal <= 0) {
      _setError(const ValidationFailure('Goal must be greater than 0'));
      return false;
    }

    _clearError();

    final result = await _repository.updateWeeklyGoal(goal);

    return result.fold(
      onSuccess: (_) {
        _user = _user!.copyWith(weeklyGoalUnits: goal);
        notifyListeners();
        return true;
      },
      onError: (failure) {
        _setError(failure);
        return false;
      },
    );
  }

  /// Upgrade to premium
  Future<bool> upgradeToPremium() async {
    if (_user == null) return false;

    _clearError();

    final result = await _repository.upgradeToPremium();

    return result.fold(
      onSuccess: (_) {
        _user = _user!.copyWith(isPremium: true);
        notifyListeners();
        return true;
      },
      onError: (failure) {
        _setError(failure);
        return false;
      },
    );
  }

  /// Clear all user data
  Future<bool> clearUserData() async {
    _clearError();

    final result = await _repository.deleteUser();

    return result.fold(
      onSuccess: (_) {
        _user = null;
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

  Future<bool> _updateUser(User user) async {
    _clearError();

    final result = await _repository.saveUser(user);

    return result.fold(
      onSuccess: (_) {
        _user = user;
        notifyListeners();
        return true;
      },
      onError: (failure) {
        _setError(failure);
        return false;
      },
    );
  }

  Future<void> _saveCurrentUser() async {
    if (_user != null) {
      await _repository.saveUser(_user!);
    }
  }

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
