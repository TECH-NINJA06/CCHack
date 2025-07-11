import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int maxScore;
  final String testTitle;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.maxScore,
    required this.testTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percentage = (score / maxScore) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Result'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                testTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your Score: $score / $maxScore',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                'Percentage: ${percentage.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
     ),
    );
  }
}