import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/screens/home_screen.dart';

class QnAScreen extends StatefulWidget {
  const QnAScreen({super.key});

  @override
  State<QnAScreen> createState() => _QnAScreenState();
}

class _QnAScreenState extends State<QnAScreen> {
  String? _stressLevel;
  String? _sleepQuality;
  String? _emotionTendency;
  bool? _focusIssue;

  bool _isSubmitting = false;

  final List<String> stressOptions = ['low', 'medium', 'high'];
  final List<String> sleepOptions = ['good', 'average', 'poor'];
  final List<String> emotionOptions = ['happy', 'sad', 'calm', 'anxious', 'angry'];

  void _submit() async {
    if (_stressLevel == null || _sleepQuality == null || _emotionTendency == null || _focusIssue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions')),
      );
      return;
    }
    print('Current Firebase user: ${FirebaseAuth.instance.currentUser}');

    // setState(() => _isSubmitting = true);

    // final uid = FirebaseAuth.instance.currentUser?.uid;
    // if (uid == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('User not logged in')),
    //   );
    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    // }

    // await FirebaseFirestore.instance
    //     .collection('hackathons')
    //     .doc('CChack')
    //     .collection('users')
    //     .doc(uid)
    //     .set({
    //   'mental_state': {
    //     'stress_level': _stressLevel,
    //     'sleep_quality': _sleepQuality,
    //     'emotion_tendency': _emotionTendency,
    //     'focus_issue': _focusIssue,
    //   }
    // }, SetOptions(merge: true));

    // setState(() => _isSubmitting = false);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mental Health QnA')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuestion<String>(
              title: '1. How stressed have you been lately?',
              options: stressOptions,
              groupValue: _stressLevel,
              onChanged: (val) => setState(() => _stressLevel = val),
            ),
            _buildQuestion<String>(
              title: '2. How would you rate your sleep quality?',
              options: sleepOptions,
              groupValue: _sleepQuality,
              onChanged: (val) => setState(() => _sleepQuality = val),
            ),
            _buildQuestion<String>(
              title: '3. What emotion best describes you recently?',
              options: emotionOptions,
              groupValue: _emotionTendency,
              onChanged: (val) => setState(() => _emotionTendency = val),
            ),
            _buildQuestion<String>(
              title: '4. Have you had trouble focusing on tasks?',
              options: const ['Yes', 'No'],
              groupValue: _focusIssue == null ? null : _focusIssue! ? 'Yes' : 'No',
              onChanged: (val) => setState(() => _focusIssue = val == 'Yes'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save & Continue', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion<T>({
    required String title,
    required List options,
    required dynamic groupValue,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ...options.map<Widget>((opt) => RadioListTile<String>(
              title: Text(opt),
              value: opt,
              groupValue: groupValue,
              onChanged: onChanged,
            )),
      ],
    );
  }
}
