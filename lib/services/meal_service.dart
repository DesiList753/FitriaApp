import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/meal.dart';

class MealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _mealsCollection(String date) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('meals')
        .doc(date)
        .collection('items');
  }

  Future<void> addMeal(String date, Meal meal) async {
    await _mealsCollection(date).add(meal.toMap());
  }

  Future<void> updateMeal(String date, Meal meal) async {
    await _mealsCollection(date).doc(meal.id).update(meal.toMap());
  }

  Future<void> deleteMeal(String date, String mealId) async {
    await _mealsCollection(date).doc(mealId).delete();
  }

  Stream<List<Meal>> getMealsForDate(String date) {
    return _mealsCollection(date).snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Meal.fromFirestore(doc)).toList()
    );
  }
}
