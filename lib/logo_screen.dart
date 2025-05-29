import 'package:flutter/material.dart';

class LogoScreen extends StatelessWidget {
  const LogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/images/logo.webp',
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Error loading logo: $error');
                  return const SizedBox(
                    height: 150,
                    width: 150,
                  );
                },
              ),
              Text('Fitria',style: TextStyle(fontSize: 50, color: Color.fromRGBO(51, 54, 63, 1)),),
            ],
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(50, 162, 135, 1),
    );
  }
}
