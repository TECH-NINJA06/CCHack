import 'package:flutter/material.dart';

class OnboardingQuestionsScreen extends StatefulWidget {
  const OnboardingQuestionsScreen({super.key});

  @override
  State<OnboardingQuestionsScreen> createState() => _OnboardingQuestionsScreenState();
}

class _OnboardingQuestionsScreenState extends State<OnboardingQuestionsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? mood, stressLevel, sleepQuality;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Questions')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Let's get to know you!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Question 1
              const Text("How are you feeling today?"),
              DropdownButtonFormField<String>(
                value: mood,
                onChanged: (val) => setState(() => mood = val),
                items: ["Happy", "Sad", "Anxious", "Tired", "Excited"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                validator: (val) => val == null ? "Please choose an option" : null,
              ),

              const SizedBox(height: 20),

              // Question 2
              const Text("How would you rate your current stress level?"),
              DropdownButtonFormField<String>(
                value: stressLevel,
                onChanged: (val) => setState(() => stressLevel = val),
                items: ["Low", "Moderate", "High", "Overwhelmed"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                validator: (val) => val == null ? "Please choose an option" : null,
              ),

              const SizedBox(height: 20),

              // Question 3
              const Text("How did you sleep last night?"),
              DropdownButtonFormField<String>(
                value: sleepQuality,
                onChanged: (val) => setState(() => sleepQuality = val),
                items: ["Great", "Okay", "Poor"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                validator: (val) => val == null ? "Please choose an option" : null,
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // You can save this info or navigate to home screen
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
