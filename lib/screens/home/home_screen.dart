import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../models/meal.dart';
import '../../services/meal_service.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es_CL', null); // Cambia a español de Chile
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipOval(
              child: Image(
                image: AssetImage('assets/Logo.png'),
                height: 32,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 32,
                    width: 32,
                  );
                },
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 32,
                  width: 32,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Fitria'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<String>(
                    future: _getUserName(),
                    builder: (context, snapshot) {
                      final name = snapshot.data ?? '';
                      return Text(
                        name.isNotEmpty ? '¡Hola, $name!' : '¡Hola!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  Text(
                    _capitalize(DateFormat('EEEE d MMMM', 'es_CL').format(DateTime.now()))!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'Recomendaciones de hoy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PrioRecomendationWidget(),
              SecRecomendationWidget(),
              const SizedBox(height: 10),
              const Text(
                'Restaurantes saludables cercanos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Icon(
                    Icons.map,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Consejos del día',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DailyTipCard(),
              const SizedBox(height: 5),
              const Text(
                'Resumen de calorías',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              CaloriesWidget(),
              const SizedBox(height: 15),
              const Text(
                'Resumen de macronutrientes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              MacrosWidget(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return doc.data()?['name'] ?? '';
    }
    return '';
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

class CaloriesWidget extends StatelessWidget {
  final MealService _mealService = MealService();
  final int caloriesGoal = 2000;

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return StreamBuilder<List<Meal>>(
      stream: _mealService.getMealsForDate(today),
      builder: (context, snapshot) {
        int totalCalories = 0;
        if (snapshot.hasData) {
          totalCalories = snapshot.data!.fold(0, (sum, meal) => sum + meal.calories);
        }
        int remaining = caloriesGoal - totalCalories;
        return Row(
          children: [
            Expanded(
              child: CalorieCard(
                title: 'Consumidas',
                value: '$totalCalories',
                color: Colors.blue.shade300,
                icon: Icons.restaurant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CalorieCard(
                title: 'Quemadas',
                value: '420', // Puedes conectar con datos reales de ejercicio si los tienes
                color: Colors.red.shade300,
                icon: Icons.local_fire_department,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CalorieCard(
                title: 'Restantes',
                value: '$remaining',
                color: Colors.green.shade300,
                icon: Icons.hourglass_bottom,
              ),
            ),
          ],
        );
      },
    );
  }
}

class PrioRecomendationWidget extends StatelessWidget {
  @override 
    Widget build(BuildContext context) {
      return Row(
        children: [
          Expanded(
            child: RecomendCard(
              title: 'Desayuno \nRecomendado',
              image: 'https://www.buenoyvegano.com/wp-content/uploads/2017/09/muesli_-MaraZe_shutterstock.com_jpg.jpg',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RecomendCard(
              title: 'Almuerzo \nRecomendado',
              image: 'https://www.petalatino.com/wp-content/uploads/broccoli-cheese-pasta-602x455.jpg',
            ),
          ),
        ],
      );
    }
  }

class SecRecomendationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RecomendCard(
            title: 'Merienda \nRecomendado',
            image: 'https://recetasveganas.net/wp-content/uploads/2014/02/desayuno-merienda.jpg',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RecomendCard(
            title: 'Cena \nRecomendado',
            image: 'https://i.blogs.es/3ffb88/1366_2000/1200_800.jpeg',
          ),
        ),
        Expanded(
          child: RecomendCard(
            title: 'Snack \nRecomendado',
            image: 'https://delantaldealces.com/wp-content/uploads/2016/10/chips-boniato-1.jpg',
          ),
        ),
      ],
    );
  }
}

class CalorieCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const CalorieCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecomendCard extends StatelessWidget {
  final String title;
  final String image;

  const RecomendCard({
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            image,
            height: 90,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DailyTipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lightbulb,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Intenta beber al menos 8 vasos de agua hoy para mantener una buena hidratación.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MacrosWidget extends StatelessWidget {
  final MealService _mealService = MealService();

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserGoals(),
      builder: (context, snapshot) {
        int proteinGoal = 100;
        int carbsGoal = 250;
        int fatGoal = 70;
        if (snapshot.hasData && snapshot.data != null) {
          proteinGoal = snapshot.data!['proteinGoal'] ?? 100;
          carbsGoal = snapshot.data!['carbsGoal'] ?? 250;
          fatGoal = snapshot.data!['fatGoal'] ?? 70;
        }
        return StreamBuilder<List<Meal>>(
          stream: _mealService.getMealsForDate(today),
          builder: (context, snap) {
            int totalProtein = 0;
            int totalCarbs = 0;
            int totalFat = 0;
            if (snap.hasData) {
              for (final meal in snap.data!) {
                totalProtein += meal.protein;
                totalCarbs += meal.carbs;
                totalFat += meal.fat;
              }
            }
            return Row(
              children: [
                Expanded(
                  child: CalorieCard(
                    title: 'Proteínas',
                    value: '$totalProtein/$proteinGoal g',
                    color: Colors.red.shade300,
                    icon: Icons.fitness_center,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalorieCard(
                    title: 'Carbohidratos',
                    value: '$totalCarbs/$carbsGoal g',
                    color: Colors.amber.shade300,
                    icon: Icons.bubble_chart,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalorieCard(
                    title: 'Grasas',
                    value: '$totalFat/$fatGoal g',
                    color: Colors.blue.shade300,
                    icon: Icons.opacity,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _getUserGoals() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return doc.data();
    }
    return null;
  }
}
