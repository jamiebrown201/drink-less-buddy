class User {
  final String id;
  final String? email;
  final bool isPremium;
  final DateTime createdAt;
  final bool hasCompletedOnboarding;
  final bool hasAcceptedTerms;
  final bool isOver18;
  final double? weeklyGoalUnits; // User's personal goal
  final Map<String, dynamic>? preferences;

  User({
    required this.id,
    this.email,
    this.isPremium = false,
    required this.createdAt,
    this.hasCompletedOnboarding = false,
    this.hasAcceptedTerms = false,
    this.isOver18 = false,
    this.weeklyGoalUnits,
    this.preferences,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'is_premium': isPremium,
      'created_at': createdAt.toIso8601String(),
      'has_completed_onboarding': hasCompletedOnboarding,
      'has_accepted_terms': hasAcceptedTerms,
      'is_over_18': isOver18,
      'weekly_goal_units': weeklyGoalUnits,
      'preferences': preferences,
    };
  }

  // Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      isPremium: json['is_premium'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      hasCompletedOnboarding: json['has_completed_onboarding'] ?? false,
      hasAcceptedTerms: json['has_accepted_terms'] ?? false,
      isOver18: json['is_over_18'] ?? false,
      weeklyGoalUnits: json['weekly_goal_units'] != null
          ? (json['weekly_goal_units'] as num).toDouble()
          : null,
      preferences: json['preferences'],
    );
  }

  // Copy with method
  User copyWith({
    String? id,
    String? email,
    bool? isPremium,
    DateTime? createdAt,
    bool? hasCompletedOnboarding,
    bool? hasAcceptedTerms,
    bool? isOver18,
    double? weeklyGoalUnits,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      isOver18: isOver18 ?? this.isOver18,
      weeklyGoalUnits: weeklyGoalUnits ?? this.weeklyGoalUnits,
      preferences: preferences ?? this.preferences,
    );
  }
}
