import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mood_provider.dart';

class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);
    
    final moods = [
      {'emoji': '😊', 'name': 'Happy', 'color': const Color(0xFF4ECDC4)},
      {'emoji': '😢', 'name': 'Sad', 'color': const Color(0xFF96CEB4)},
      {'emoji': '😐', 'name': 'Okay', 'color': const Color(0xFFFFD93D)},
      {'emoji': '😡', 'name': 'Angry', 'color': const Color(0xFFFF6B6B)},
      {'emoji': '😰', 'name': 'Anxious', 'color': const Color(0xFFFFA726)},
      {'emoji': '😴', 'name': 'Tired', 'color': const Color(0xFF9575CD)},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Mood'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How are you feeling right now?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select the mood that best describes how you feel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: moods.length,
                  itemBuilder: (context, index) {
                    final mood = moods[index];
                    final isSelected = moodProvider.mood == '${mood['emoji']} ${mood['name']}';
                    
                    return GestureDetector(
                      onTap: () {
                        moodProvider.updateMood('${mood['emoji']} ${mood['name']}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Mood set to ${mood['name']}'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected 
                              // ignore: deprecated_member_use
                              ? (mood['color'] as Color).withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected 
                                ? (mood['color'] as Color)
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  // ignore: deprecated_member_use
                                  ? (mood['color'] as Color).withOpacity(0.3)
                                  // ignore: deprecated_member_use
                                  : Colors.black.withOpacity(0.05),
                              blurRadius: isSelected ? 15 : 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              mood['emoji'] as String,
                              style: const TextStyle(fontSize: 48),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              mood['name'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected 
                                    ? (mood['color'] as Color)
                                    : const Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
