import 'package:flutter/material.dart';
import 'recipe_detail_screen.dart';

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
            MealCategoryList(category: 'Desayunos'),
            MealCategoryList(category: 'Almuerzos'),
            MealCategoryList(category: 'Meriendas'),
            MealCategoryList(category: 'Cenas'),
            MealCategoryList(category: 'Snacks'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Implementar búsqueda de recetas
            showSearch(
              context: context,
              delegate: MealSearchDelegate(),
            );
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}

class MealCategoryList extends StatelessWidget {
  final String category;
  
  MealCategoryList({required this.category});
  
  final List<Map<String, dynamic>> meals = [
    {
      'name': 'Ensalada mediterránea',
      'calories': '320',
      'time': '15 min',
      'image': 'assets/images/meal1.jpg',
      'difficulty': 'Fácil',
    },
    {
      'name': 'Bowl de quinoa con vegetales',
      'calories': '420',
      'time': '25 min',
      'image': 'assets/images/meal2.jpg',
      'difficulty': 'Media',
    },
    {
      'name': 'Wrap de pollo y aguacate',
      'calories': '380',
      'time': '20 min',
      'image': 'assets/images/meal3.jpg',
      'difficulty': 'Fácil',
    },
    {
      'name': 'Smoothie de frutas',
      'calories': '220',
      'time': '5 min',
      'image': 'assets/images/meal4.jpg',
      'difficulty': 'Fácil',
    },
    {
      'name': 'Pasta integral con verduras',
      'calories': '450',
      'time': '30 min',
      'image': 'assets/images/meal5.jpg',
      'difficulty': 'Media',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        return RecipeCard(
          recipe: meals[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(recipe: meals[index]),
              ),
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

  const RecipeCard({
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
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
              child: Image.asset(
                recipe['image'],
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
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
                      Chip(
                        backgroundColor: Colors.green.shade50,
                        label: Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              size: 16,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${recipe['calories']} cal',
                              style: TextStyle(
                                color: Colors.green.shade900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        backgroundColor: Colors.blue.shade50,
                        label: Row(
                          children: [
                            Icon(
                              Icons.timer,
                              size: 16,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              recipe['time'],
                              style: TextStyle(
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        backgroundColor: Colors.green.shade50,
                        label: Text(
                          recipe['difficulty'],
                          style: TextStyle(
                            color: Colors.green.shade900,
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

class MealSearchDelegate extends SearchDelegate<String> {
  final List<String> suggestions = [
    'Ensalada mediterránea',
    'Bowl de quinoa',
    'Wrap de pollo',
    'Smoothie de frutas',
    'Pasta integral',
    'Tortilla de espinacas',
    'Yogur con granola',
    'Salmón al horno',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> results = suggestions
        .where((suggestion) =>
            suggestion.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = query.isEmpty
        ? []
        : suggestions
            .where((suggestion) =>
                suggestion.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            query = suggestionList[index];
            showResults(context);
          },
        );
      },
    );
  }
}
