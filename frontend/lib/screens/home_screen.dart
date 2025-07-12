import 'package:flutter/material.dart';
import 'package:frontend/screens/gratitude_screen.dart';
import 'journal_screen.dart';
import 'assessment_screen.dart';
import 'home_content.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:math';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(), 
    const GratitudeEntryScreen(),
    const NotificationScreen(),
    const BlogScreen(),
    AssessmentScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color(0xFF6B73FF),
            unselectedItemColor: Colors.grey[400],
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_rounded),
                label: 'Gratitude',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_rounded),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article_rounded),
                label: 'Blogs',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.checklist_rounded),
                label: 'Assessments',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<String> suggestions = [];
  List<bool> completedTasks = [];
  bool isLoading = true;
  bool hasError = false;
  bool usingFallback = false;

  // Static fallback suggestions
  final List<List<String>> fallbackSuggestions = [
    [
      'Take 5 deep breaths and focus on your breathing',
      'Step outside for 10 minutes of fresh air',
      'Write down 3 things you\'re grateful for today'
    ],
    [
      'Do some gentle stretching or yoga poses',
      'Listen to your favorite calming music',
      'Call or text someone you care about'
    ],
    [
      'Drink a glass of water and stay hydrated',
      'Take a short walk around your neighborhood',
      'Practice mindfulness for 5 minutes'
    ],
    [
      'Organize a small space in your home',
      'Read a few pages of an inspiring book',
      'Take a warm shower or bath to relax'
    ],
    [
      'Do a quick body scan to release tension',
      'Write in a journal about your feelings',
      'Look at photos that make you smile'
    ],
    [
      'Practice saying positive affirmations',
      'Spend time in nature, even if just watching trees',
      'Do something creative like drawing or crafting'
    ],
    [
      'Limit social media for the next hour',
      'Make yourself a healthy snack',
      'Practice progressive muscle relaxation'
    ]
  ];

  @override
  void initState() {
    super.initState();
    _getSuggestions();
  }

  Future<void> _getSuggestions() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
        usingFallback = false;
      });

      final gemini = Gemini.instance;

      final prompt = '''
Suggest 3 short, practical self-care tips for improving mental health. 
Return them as a numbered list like:
1. Do breathing exercise
2. Take a short walk
3. Write something you're grateful for
''';

      final response = await gemini.text(prompt);
      final text = response?.output ?? '';

      if (text.isEmpty) {
        throw Exception('Empty response from Gemini');
      }

      final extracted = _parseSuggestions(text);
      
      if (extracted.isEmpty) {
        throw Exception('No suggestions could be parsed');
      }

      setState(() {
        suggestions = extracted;
        completedTasks = List.filled(extracted.length, false);
        isLoading = false;
        hasError = false;
        usingFallback = false;
      });
    } catch (e) {
      debugPrint('Gemini error: $e');
      // Use fallback suggestions instead of showing error
      _useFallbackSuggestions();
    }
  }

  void _useFallbackSuggestions() {
    final random = Random();
    final selectedTips = fallbackSuggestions[random.nextInt(fallbackSuggestions.length)];
    
    setState(() {
      suggestions = selectedTips;
      completedTasks = List.filled(selectedTips.length, false);
      isLoading = false;
      hasError = false;
      usingFallback = true;
    });
  }

  void _toggleTask(int index) {
    setState(() {
      completedTasks[index] = !completedTasks[index];
    });
    
    // Check if all tasks are completed
    if (completedTasks.every((completed) => completed)) {
      _showCongratsDialog();
    }
  }

  void _showCongratsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF667EEA),
                        const Color(0xFF764BA2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.celebration,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Congratulations!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You\'ve completed all your wellness tasks today. Keep up the great work!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF718096),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _getSuggestions(); // Get new suggestions
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF667EEA),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Get New Tips',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF667EEA),
                          side: const BorderSide(color: Color(0xFF667EEA)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  List<String> _parseSuggestions(String raw) {
    final lines = raw.split('\n');
    final parsed = lines
        .where((line) => line.trim().isNotEmpty && line.contains(RegExp(r'^\d+')))
        .map((line) => line.replaceAll(RegExp(r'^\d+\.?\s*'), '').trim())
        .where((line) => line.isNotEmpty)
        .toList();
    
    // Fallback if parsing fails
    if (parsed.isEmpty) {
      return lines
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.trim())
          .toList();
    }
    
    return parsed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF667EEA),
                  const Color(0xFF764BA2),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: _getSuggestions,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Daily Wellness Tips',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      usingFallback 
                        ? 'Curated wellness checklist for you' 
                        : 'Personalized wellness checklist for you',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Content Section
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
  if (isLoading) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
          ),
          SizedBox(height: 16),
          Text(
            'Getting your wellness tips...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  if (hasError) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFED7D7),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFFE53E3E),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Unable to load suggestions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your internet connection and try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF718096),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _getSuggestions,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667EEA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  if (suggestions.isEmpty) {
    return const Center(
      child: Text(
        'No suggestions available',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF718096),
        ),
      ),
    );
  }

  // Remove extra `Expanded` widget here and return a Column directly
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF667EEA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.track_changes,
                color: Color(0xFF667EEA),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress: ${completedTasks.where((c) => c).length}/${completedTasks.length} completed',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: completedTasks.isEmpty
                        ? 0
                        : completedTasks.where((c) => c).length / completedTasks.length,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final isCompleted = completedTasks[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCompleted ? const Color(0xFF48BB78) : Colors.grey[200]!,
                  width: isCompleted ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _toggleTask(index),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isCompleted ? const Color(0xFF48BB78) : Colors.transparent,
                            border: Border.all(
                              color: isCompleted ? const Color(0xFF48BB78) : Colors.grey[400]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: isCompleted
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            suggestions[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isCompleted
                                  ? const Color(0xFF48BB78)
                                  : const Color(0xFF2D3748),
                              decoration:
                                  isCompleted ? TextDecoration.lineThrough : null,
                              height: 1.5,
                            ),
                          ),
                        ),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF48BB78).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Done!',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF48BB78),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

}
class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blogs = [
      {
        'title': '5 Ways to Improve Your Mental Health',
        'description': 'Simple tips like getting enough sleep, staying active, and talking to someone you trust can help boost your mood.',
        'readTime': '5 min read',
        'category': 'Wellness',
        'color': const Color(0xFF6B73FF),
        'content': '''Mental health is just as important as physical health, yet it's often overlooked in our busy lives. Here are five evidence-based ways to improve your mental well-being:

**1. Prioritize Quality Sleep**
Getting 7-9 hours of quality sleep each night is crucial for mental health. Poor sleep can increase stress hormones and make it harder to cope with daily challenges. Create a consistent bedtime routine and avoid screens before bed.

**2. Stay Physically Active**
Exercise releases endorphins, which are natural mood boosters. Even a 15-minute walk can help reduce anxiety and improve your mood. Find activities you enjoy - dancing, hiking, swimming, or yoga.

**3. Connect with Others**
Human connection is vital for mental health. Talk to friends, family, or a therapist about your feelings. Don't isolate yourself when you're struggling - reach out for support.

**4. Practice Mindfulness**
Being present in the moment can help reduce anxiety about the future and regret about the past. Try meditation, deep breathing, or simply paying attention to your surroundings.

**5. Maintain a Healthy Diet**
What you eat affects how you feel. A balanced diet rich in omega-3 fatty acids, whole grains, and fresh fruits and vegetables can support brain health and mood regulation.

Remember, improving mental health is a journey, not a destination. Be patient with yourself and celebrate small victories along the way.''',
      },
      {
        'title': 'Meditation for Beginners',
        'description': 'Meditation can help reduce stress and anxiety. Learn how to start with just 5 minutes a day.',
        'readTime': '3 min read',
        'category': 'Mindfulness',
        'color': const Color(0xFF9F7AEA),
        'content': '''Meditation might seem intimidating, but it's actually quite simple. Here's how to start your meditation journey:

**Getting Started**
Find a quiet, comfortable space where you won't be disturbed. You don't need special equipment - just yourself and a few minutes of time.

**Basic Technique**
1. Sit comfortably with your back straight
2. Close your eyes or soften your gaze
3. Focus on your breath - feel the air entering and leaving your nostrils
4. When your mind wanders (and it will), gently return your attention to your breath
5. Start with just 5 minutes and gradually increase

**Common Challenges**
- "I can't stop thinking": This is normal! The goal isn't to stop thoughts, but to notice them without judgment
- "I don't have time": Even 2-3 minutes can be beneficial
- "I'm not doing it right": There's no perfect meditation - be kind to yourself

**Benefits You May Notice**
- Reduced stress and anxiety
- Better sleep quality
- Improved focus and concentration
- Greater emotional regulation
- Increased self-awareness

**Making It a Habit**
Try meditating at the same time each day. Many people find morning meditation sets a positive tone for the day. Use apps like Headspace or Calm if you prefer guided meditations.

Remember, meditation is a practice - be patient with yourself as you develop this valuable skill.''',
      },
      {
        'title': 'How to Deal with Burnout',
        'description': 'Feeling exhausted all the time? Learn the signs of burnout and ways to recover from it.',
        'readTime': '7 min read',
        'category': 'Recovery',
        'color': const Color.fromARGB(255, 112, 209, 79),
        'content': '''Burnout is more than just feeling tired - it's a state of physical, emotional, and mental exhaustion caused by prolonged stress. Here's how to recognize and recover from it:

**Signs of Burnout**
- Chronic fatigue that rest doesn't fix
- Feeling cynical or detached from work/activities
- Reduced productivity and motivation
- Physical symptoms like headaches or insomnia
- Emotional exhaustion and irritability

**Immediate Recovery Steps**
1. **Acknowledge the Problem**: Recognizing burnout is the first step to recovery
2. **Set Boundaries**: Learn to say no to additional commitments
3. **Take Time Off**: If possible, take a break from work or stressful activities
4. **Prioritize Self-Care**: Focus on sleep, nutrition, and gentle exercise

**Long-term Recovery Strategies**
- **Reassess Your Priorities**: What truly matters to you?
- **Develop Coping Skills**: Learn stress management techniques
- **Build Support Networks**: Connect with friends, family, or support groups
- **Consider Professional Help**: Therapists can provide valuable tools and perspective

**Prevention Tips**
- Regular breaks throughout the day
- Maintain work-life balance
- Practice stress-reduction techniques
- Set realistic goals and expectations
- Celebrate small accomplishments

**When to Seek Help**
If burnout symptoms persist despite self-care efforts, or if you're experiencing thoughts of self-harm, please reach out to a mental health professional immediately.

Recovery from burnout takes time - be patient with yourself and remember that seeking help is a sign of strength, not weakness.''',
      },
      {
        'title': 'The Power of Gratitude',
        'description': 'Practicing gratitude daily can shift your mindset and improve your emotional well-being.',
        'readTime': '4 min read',
        'category': 'Positivity',
        'color': const Color(0xFF4FD1C7),
        'content': '''Gratitude is more than just saying "thank you" - it's a powerful practice that can transform your mental health and overall well-being.

**What is Gratitude?**
Gratitude is the practice of recognizing and appreciating the positive aspects of your life, no matter how small. It's about shifting focus from what's lacking to what's abundant.

**Science-Backed Benefits**
Research shows that regular gratitude practice can:
- Increase happiness and life satisfaction
- Reduce symptoms of depression and anxiety
- Improve sleep quality
- Strengthen relationships
- Boost immune system function
- Increase resilience during difficult times

**Simple Gratitude Practices**
1. **Gratitude Journal**: Write down 3 things you're grateful for each day
2. **Gratitude Letters**: Write thank-you notes to people who've impacted your life
3. **Mindful Appreciation**: Take a moment to really notice and appreciate small pleasures
4. **Gratitude Meditation**: Focus on feelings of appreciation during meditation
5. **Sharing Gratitude**: Express appreciation to others verbally

**Making It Stick**
- Start small - even one thing per day counts
- Be specific rather than general
- Focus on people rather than things when possible
- Notice the feeling of gratitude, not just the thought
- Practice consistently, even on difficult days

**Gratitude During Tough Times**
It's not about ignoring problems or pretending everything is perfect. Instead, it's about finding small lights in the darkness - perhaps gratitude for a friend's support, a moment of peace, or your own strength in facing challenges.

**Getting Started Today**
Right now, think of three things you're grateful for. Feel the appreciation in your body. Notice how this simple practice can shift your mood and perspective.

Gratitude is a muscle that gets stronger with practice. Start today and watch how it transforms your relationship with life.''',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text(
          'Mental Health Blogs',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF4A5568)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Color(0xFF4A5568)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Featured Articles',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover insights and tips for better mental wellness',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          // Blog list
          Expanded(
            child: ListView.builder(
              itemCount: blogs.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                final blog = blogs[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailScreen(
                              title: blog['title']! as String,
                              content: blog['content']! as String,
                              category: blog['category']! as String,
                              readTime: blog['readTime']! as String,
                              color: blog['color']! as Color,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category and read time
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: blog['color'] as Color,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    blog['category'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.schedule,
                                        size: 12,
                                        color: Color(0xFF718096),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        blog['readTime']! as String,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF718096),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Title
                            Text(
                              blog['title']! as String,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Description
                            Text(
                              blog['description']! as String,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF4A5568),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Read more button
                            Row(
                              children: [
                                Text(
                                  'Read Article',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: blog['color'] as Color,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: blog['color'] as Color,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Article Detail Screen
class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final String category;
  final String readTime;
  final Color color;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.category,
    required this.readTime,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Color(0xFF4A5568)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF4A5568)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 12,
                              color: Color(0xFF718096),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              readTime,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF718096),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2D3748),
                  height: 1.6,
                ),
              ),
            ),
            
            // Action buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border, size: 18),
                      label: const Text('Like Article'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.comment_outlined, size: 18),
                      label: const Text('Comments'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color,
                        side: BorderSide(color: color),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}