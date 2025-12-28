import 'package:uuid/uuid.dart';

class Drink {
  final String id;
  final DateTime timestamp;
  final String drinkType;
  final double units;
  final String mood;
  final String context;
  final String? notes;
  final String userId;

  Drink({
    String? id,
    required this.timestamp,
    required this.drinkType,
    required this.units,
    required this.mood,
    required this.context,
    this.notes,
    required this.userId,
  }) : id = id ?? const Uuid().v4();

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'drink_type': drinkType,
      'units': units,
      'mood': mood,
      'context': context,
      'notes': notes,
      'user_id': userId,
    };
  }

  // Create from JSON
  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      drinkType: json['drink_type'],
      units: (json['units'] as num).toDouble(),
      mood: json['mood'],
      context: json['context'],
      notes: json['notes'],
      userId: json['user_id'],
    );
  }

  // Copy with method
  Drink copyWith({
    String? id,
    DateTime? timestamp,
    String? drinkType,
    double? units,
    String? mood,
    String? context,
    String? notes,
    String? userId,
  }) {
    return Drink(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      drinkType: drinkType ?? this.drinkType,
      units: units ?? this.units,
      mood: mood ?? this.mood,
      context: context ?? this.context,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
    );
  }
}
