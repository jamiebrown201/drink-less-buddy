import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get hasCompletedOnboarding => _user?.hasCompletedOnboarding ?? false;
  bool get isPremium => _user?.isPremium ?? false;

  /// Load user data from local storage
  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');

    if (userJson != null) {
      _user = User.fromJson(json.decode(userJson));
    } else {
      // Create new user
      _user = User(
        id: const Uuid().v4(),
        createdAt: DateTime.now(),
      );
      await _saveUserData();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Save user data to local storage
  Future<void> _saveUserData() async {
    if (_user == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(_user!.toJson()));
  }

  /// Complete age verification
  Future<void> confirmAge() async {
    if (_user == null) return;

    _user = _user!.copyWith(isOver18: true);
    await _saveUserData();
    notifyListeners();
  }

  /// Accept terms and conditions
  Future<void> acceptTerms() async {
    if (_user == null) return;

    _user = _user!.copyWith(hasAcceptedTerms: true);
    await _saveUserData();
    notifyListeners();
  }

  /// Complete onboarding
  Future<void> completeOnboarding({double? weeklyGoal}) async {
    if (_user == null) return;

    _user = _user!.copyWith(
      hasCompletedOnboarding: true,
      weeklyGoalUnits: weeklyGoal,
    );
    await _saveUserData();
    notifyListeners();
  }

  /// Update weekly goal
  Future<void> updateWeeklyGoal(double goal) async {
    if (_user == null) return;

    _user = _user!.copyWith(weeklyGoalUnits: goal);
    await _saveUserData();
    notifyListeners();
  }

  /// Upgrade to premium
  Future<void> upgradeToPremium() async {
    if (_user == null) return;

    // In production, this would verify payment via Stripe
    _user = _user!.copyWith(isPremium: true);
    await _saveUserData();
    notifyListeners();
  }

  /// Clear all user data (for testing/logout)
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    _user = null;
    notifyListeners();
  }
}
