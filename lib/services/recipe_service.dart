import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _recipesCollection =>
      _firestore.collection('recipes');

  Future<void> addRecipe(Map<String, dynamic> recipe) async {
    await _recipesCollection.add(recipe);
  }

  Future<void> updateRecipe(String id, Map<String, dynamic> recipe) async {
    await _recipesCollection.doc(id).update(recipe);
  }

  Future<void> deleteRecipe(String id) async {
    await _recipesCollection.doc(id).delete();
  }

  Stream<List<Map<String, dynamic>>> getAllRecipes() {
    return _recipesCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList());
  }

  // Filtrar recetas por tipo
  Stream<List<Map<String, dynamic>>> getRecipesByType(String type) {
    return _recipesCollection
        .where('types', arrayContains: type)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }
}
