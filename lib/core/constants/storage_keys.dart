/// Storage keys for local persistence
/// Centralized to avoid magic strings and typos
class StorageKeys {
  StorageKeys._(); // Private constructor to prevent instantiation

  // User data
  static const String userData = 'user_data';

  // Drink data
  static const String drinksData = 'drinks_data';

  // Intention data
  static const String intentionsData = 'intentions_data';

  // Settings
  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String weeklyGoal = 'weekly_goal';
  static const String isPremium = 'is_premium';
}
