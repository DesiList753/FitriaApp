import 'package:flutter/material.dart';
import 'dart:async';
import '../screens/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 162, 135, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://i.imgur.com/7OOih26.png',
                  height: 120,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 120,
                      width: 120,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    width: 120,
                    color: Colors.white.withOpacity(0.2),
                    child: const Icon(
                      Icons.fitness_center,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Fitria",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Tu camino hacia la salud",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
