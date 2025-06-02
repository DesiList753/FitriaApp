import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                recipe['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    recipe['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.restaurant,
                          size: 60,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoCard(
                        icon: Icons.local_fire_department,
                        iconColor: Colors.orange,
                        title: 'Calorías',
                        value: '${recipe['calories']} cal',
                      ),
                      InfoCard(
                        icon: Icons.timer,
                        iconColor: Colors.blue,
                        title: 'Tiempo',
                        value: recipe['time'],
                      ),
                      InfoCard(
                        icon: Icons.fitness_center,
                        iconColor: Colors.purple,
                        title: 'Dificultad',
                        value: recipe['difficulty'],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Ingredientes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Lista simulada de ingredientes
                  ...List.generate(
                    5,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              getIngredientText(index),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Instrucciones',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Lista simulada de pasos
                  ...List.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              getInstructionText(index),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Información nutricional',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Información nutricional
                  NutritionItem(
                    nutrient: 'Proteínas',
                    amount: '18g',
                    percentage: 0.36,
                    color: Colors.red.shade400,
                  ),
                  NutritionItem(
                    nutrient: 'Carbohidratos',
                    amount: '45g',
                    percentage: 0.6,
                    color: Colors.amber.shade400,
                  ),
                  NutritionItem(
                    nutrient: 'Grasas',
                    amount: '9g',
                    percentage: 0.25,
                    color: Colors.blue.shade400,
                  ),
                  NutritionItem(
                    nutrient: 'Fibra',
                    amount: '7g',
                    percentage: 0.28,
                    color: Colors.green.shade400,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Receta agregada a tus favoritos'),
              backgroundColor: Colors.green,
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.favorite),
        label: const Text('Favorito'),
      ),
    );
  }

  String getIngredientText(int index) {
    List<String> ingredients = [
      '2 tomates medianos cortados en cubos',
      '1 pepino pelado y en rodajas',
      '1 cebolla roja en juliana',
      '100g de queso feta desmenuzado',
      'Aceitunas negras al gusto',
    ];
    return ingredients[index];
  }

  String getInstructionText(int index) {
    List<String> instructions = [
      'Lavar y cortar todos los vegetales según se indica y colocarlos en un bowl grande.',
      'Agregar el queso feta desmenuzado y las aceitunas negras.',
      'Aliñar con aceite de oliva, vinagre balsámico, sal y pimienta al gusto. Mezclar suavemente y servir frío.',
    ];
    return instructions[index];
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const InfoCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NutritionItem extends StatelessWidget {
  final String nutrient;
  final String amount;
  final double percentage;
  final Color color;

  const NutritionItem({
    super.key,
    required this.nutrient,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nutrient,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade200,
              minHeight: 8,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
