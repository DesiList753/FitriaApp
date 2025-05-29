

import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image(
              image: AssetImage('./assets/Logo.png'),
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
                  const Text(
                    '¡Hola, Isabel!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Martes, 15 de Agosto',
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
            ],
          ),
        ),
      ),
    );
  }
}

class CaloriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CalorieCard(
            title: 'Consumidas',
            value: '1450',
            color: Colors.blue.shade300,
            icon: Icons.restaurant,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CalorieCard(
            title: 'Quemadas',
            value: '420',
            color: Colors.red.shade300,
            icon: Icons.local_fire_department,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CalorieCard(
            title: 'Restantes',
            value: '850',
            color: Colors.green.shade300,
            icon: Icons.hourglass_bottom,
          ),
        ),
      ],
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
