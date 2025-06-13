import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final String id;
  final String name;
  final String time; // e.g. '08:30'
  final List<String> foods;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  Meal({
    required this.id,
    required this.name,
    required this.time,
    required this.foods,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory Meal.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Meal(
      id: doc.id,
      name: data['name'] ?? '',
      time: data['time'] ?? '',
      foods: List<String>.from(data['foods'] ?? []),
      calories: data['calories'] ?? 0,
      protein: data['protein'] ?? 0,
      carbs: data['carbs'] ?? 0,
      fat: data['fat'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
      'foods': foods,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }
}
