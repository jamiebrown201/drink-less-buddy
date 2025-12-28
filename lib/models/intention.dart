import 'package:uuid/uuid.dart';

/// Represents an intention for the next day - activities the user wants to do hangover-free
/// This is a key evidence-based feature: prospective planning reduces consumption
class Intention {
  final String id;
  final DateTime createdAt;
  final DateTime intentionDate; // The date this intention is for
  final String activity;
  final String? time; // e.g., "Morning", "9:00 AM", "Afternoon"
  final String? reason; // Why this matters to the user
  final bool isCompleted;
  final String userId;

  Intention({
    String? id,
    required this.createdAt,
    required this.intentionDate,
    required this.activity,
    this.time,
    this.reason,
    this.isCompleted = false,
    required this.userId,
  }) : id = id ?? const Uuid().v4();

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'intention_date': intentionDate.toIso8601String(),
      'activity': activity,
      'time': time,
      'reason': reason,
      'is_completed': isCompleted,
      'user_id': userId,
    };
  }

  // Create from JSON
  factory Intention.fromJson(Map<String, dynamic> json) {
    return Intention(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      intentionDate: DateTime.parse(json['intention_date']),
      activity: json['activity'],
      time: json['time'],
      reason: json['reason'],
      isCompleted: json['is_completed'] ?? false,
      userId: json['user_id'],
    );
  }

  // Copy with method
  Intention copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? intentionDate,
    String? activity,
    String? time,
    String? reason,
    bool? isCompleted,
    String? userId,
  }) {
    return Intention(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      intentionDate: intentionDate ?? this.intentionDate,
      activity: activity ?? this.activity,
      time: time ?? this.time,
      reason: reason ?? this.reason,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }

  /// Check if this intention is for tomorrow
  bool isForTomorrow() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final intentionDay = DateTime(
      intentionDate.year,
      intentionDate.month,
      intentionDate.day,
    );
    return intentionDay.isAtSameMomentAs(tomorrow);
  }

  /// Check if this intention is for today
  bool isForToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final intentionDay = DateTime(
      intentionDate.year,
      intentionDate.month,
      intentionDate.day,
    );
    return intentionDay.isAtSameMomentAs(today);
  }
}
