import 'package:flutter/material.dart';

class QuestionScreen extends StatelessWidget {
  final String question;
  final List<String> options;
  final String imageAsset;
  final Function(String) onOptionSelected;

  const QuestionScreen({
    Key? key,
    required this.question,
    required this.options,
    required this.imageAsset,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image section with proper error handling
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Image(
                image: AssetImage(imageAsset),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Log error to help debugging
                  debugPrint('Error loading image: $imageAsset');
                  debugPrint('Error details: $error');
                  return Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No se pudo cargar: $imageAsset',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            question,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ...options.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onOptionSelected(option),
                    child: Text(option),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
