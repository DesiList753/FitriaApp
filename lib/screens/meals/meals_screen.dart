import 'package:flutter/material.dart';
import 'recipe_detail_screen.dart';
import '../../services/recipe_service.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recetas'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Desayunos'),
              Tab(text: 'Almuerzos'),
              Tab(text: 'Meriendas'),
              Tab(text: 'Cenas'),
              Tab(text: 'Snacks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FirestoreMealCategoryList(category: 'Desayunos'),
            FirestoreMealCategoryList(category: 'Almuerzos'),
            FirestoreMealCategoryList(category: 'Meriendas'),
            FirestoreMealCategoryList(category: 'Cenas'),
            FirestoreMealCategoryList(category: 'Snacks'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: FirestoreMealSearchDelegate(),
            );
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}

class FirestoreMealCategoryList extends StatelessWidget {
  final String category;
  FirestoreMealCategoryList({required this.category});
  final RecipeService _recipeService = RecipeService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _recipeService.getRecipesByType(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final recipes = snapshot.data ?? [];
        if (recipes.isEmpty) {
          return const Center(child: Text('No hay recetas para esta categoría.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return RecipeCard(
              recipe: recipes[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: recipes[index]),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final VoidCallback onTap;

  const RecipeCard({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: recipe['image'] != null && recipe['image'].toString().startsWith('http')
                  ? Image.network(
                      recipe['image'],
                      fit: BoxFit.cover,
                      height: 140,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 140,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Imagen no disponible',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : (recipe['image'] != null && recipe['image'].toString().isNotEmpty)
                      ? Image.asset(
                          recipe['image'],
                          fit: BoxFit.cover,
                          height: 140,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 140,
                              width: double.infinity,
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.restaurant,
                                size: 60,
                                color: Colors.white,
                              ),
                            );
                          },
                        )
                      : Container(
                          height: 140,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.restaurant,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Chip(
                            backgroundColor: Colors.green.shade50,
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  size: 16,
                                  color: Colors.orange.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${recipe['calories']} cal',
                                  style: TextStyle(color: Colors.green.shade900),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Chip(
                            backgroundColor: Colors.blue.shade50,
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timer,
                                  size: 16,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  recipe['time'],
                                  style: TextStyle(color: Colors.blue.shade900),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FirestoreMealSearchDelegate extends SearchDelegate {
  final RecipeService _recipeService = RecipeService();

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _recipeService.getAllRecipes(),
      builder: (context, snapshot) {
        final allMeals = snapshot.data ?? [];
        final results = allMeals.where((meal) {
          final name = meal['name'].toString().toLowerCase();
          final ingredients = (meal['ingredients'] as List<dynamic>?)?.join(' ').toLowerCase() ?? '';
          final types = (meal['types'] as List<dynamic>?)?.join(' ').toLowerCase() ?? '';
          return name.contains(query.toLowerCase()) ||
              ingredients.contains(query.toLowerCase()) ||
              types.contains(query.toLowerCase());
        }).toList();
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) => RecipeCard(
            recipe: results[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: results[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
