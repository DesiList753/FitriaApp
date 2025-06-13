import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../onboarding/question_screen.dart';
import '../main_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Cuál es tu objetivo principal?',
      'options': [
        'Perder peso',
        'Ganar masa muscular',
        'Mantener mi peso',
        'Mejorar mi alimentación'
      ],
      'image': 'lib/assets/images/goal.png',
    },
    {
      'question': '¿Qué tipo de dieta prefieres?',
      'options': [
        'Sin restricciones',
        'Vegetariana',
        'Vegana',
        'Baja en carbohidratos'
      ],
      'image': 'lib/assets/images/diet.jpg',
    },
    {
      'question': '¿Cuántas comidas haces al día?',
      'options': [
        '2 comidas',
        '3 comidas',
        '4 comidas',
        '5 o más comidas'
      ],
      'image': 'lib/assets/images/meals.jpg',
    },
    {
      'question': '¿Con qué frecuencia haces ejercicio?',
      'options': [
        'Nunca',
        '1-2 veces por semana',
        '3-4 veces por semana',
        'Todos los días'
      ],
      'image': 'lib/assets/images/exercise.jpg',
    },
  ];

  final List<String?> _answers = [null, null, null, null];

  void _nextPage([String? answer]) async {
    if (answer != null) {
      _answers[_currentPage] = answer;
    }
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _completeOnboarding();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainNavigation(),
        ),
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'onboardingCompleted': true,
          'objetivo': _answers[0],
          'tipoDieta': _answers[1],
          'comidasPorDia': _answers[2],
          'frecuenciaEjercicio': _answers[3],
        },
        SetOptions(merge: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset(
              'lib/assets/images/logo.webp',
              height: 28,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error loading logo: $error');
                return const SizedBox(
                  height: 28,
                  width: 28,
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              'Fitria',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _completeOnboarding();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainNavigation(),
                ),
              );
            },
            child: Text(
              'Saltar',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                return QuestionScreen(
                  question: _questions[index]['question'],
                  options: _questions[index]['options'],
                  imageAsset: _questions[index]['image'],
                  onOptionSelected: (option) {
                    _nextPage(option);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _totalPages,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentPage
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
