import 'package:flutter/material.dart';

class QuestionScreen extends StatelessWidget {
  final String question;
  final List<String> options;
  final String imageAsset;
  final Function(String) onOptionSelected;

  const QuestionScreen({
    super.key,
    required this.question,
    required this.options,
    required this.imageAsset,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageAsset,
            height: 150,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                width: 150,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
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
