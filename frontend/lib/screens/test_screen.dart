import 'package:flutter/material.dart';
import 'test_questions.dart';
import 'result_screen.dart'; // ✅ THIS IS NECESSARY


class TestScreen extends StatefulWidget {
  final String testKey;
  TestScreen({required this.testKey});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with TickerProviderStateMixin {
  int currentQuestion = 0;
  int score = 0;
  int? selectedOptionIndex;

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final Map<String, Map<String, dynamic>> testThemes = {
    'depression': {
      'primary': Color(0xFF6B73FF),
      'secondary': Color(0xFF9DD5FF),
      'background': Color(0xFFF6F8FF),
      'icon': Icons.psychology_outlined,
    },
    'anxiety': {
      'primary': Color(0xFFFF6B9D),
      'secondary': Color(0xFFFFB347),
      'background': Color(0xFFFFF6F8),
      'icon': Icons.favorite_border,
    },
    'stress': {
      'primary': Color(0xFFFF9500),
      'secondary': Color(0xFFFFD700),
      'background': Color(0xFFFFF8F0),
      'icon': Icons.speed_outlined,
    },
    'self_esteem': {
      'primary': Color(0xFF32D74B),
      'secondary': Color(0xFF66E5A3),
      'background': Color(0xFFF0FFF4),
      'icon': Icons.self_improvement_outlined,
    },
  };

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    if (selectedOptionIndex != null) {
      final test = testData[widget.testKey]!;
      final question = test['questions'][currentQuestion];

      setState(() {
        score += (question['scores'] as List<int>)[selectedOptionIndex!];
        selectedOptionIndex = null;

        if (currentQuestion < test['questions'].length - 1) {
          currentQuestion++;
          _slideController.reset();
          _fadeController.reset();
          _slideController.forward();
          _fadeController.forward();
        } else {
          int maxScore = test['questions'].fold<int>(
            0,
            (sum, q) => sum + (q['scores'] as List<int>).reduce((a, b) => a > b ? a : b),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResultScreen(
                score: score,
                maxScore: maxScore,
                testTitle: test['title'],
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final test = testData[widget.testKey]!;
    final question = test['questions'][currentQuestion];
    final theme = testThemes[widget.testKey] ?? testThemes['depression']!;
    final progress = (currentQuestion + 1) / test['questions'].length;

    return Scaffold(
      backgroundColor: theme['background'],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, test, theme, progress),
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildQuestionCard(question, theme),
                        const SizedBox(height: 24),
                        _buildOptionsSection(question, theme),
                        const SizedBox(height: 32),
                        _buildNavigationButton(test, theme),
                        const SizedBox(height: 20),
                        _buildProgressText(test),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> test, Map<String, dynamic> theme, double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme['background'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: theme['primary'],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Question ${currentQuestion + 1} of ${test['questions'].length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme['primary'], theme['secondary']],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  theme['icon'],
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme['primary'], theme['secondary']],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question, Map<String, dynamic> theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme['primary'].withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme['primary'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.quiz,
                  color: theme['primary'],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Question ${currentQuestion + 1}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme['primary'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question['question'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection(Map<String, dynamic> question, Map<String, dynamic> theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your answer:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(question['options'].length, (index) {
          final isSelected = selectedOptionIndex == index;
          return TweenAnimationBuilder(
            duration: Duration(milliseconds: 100 + (index * 50)),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset((1 - value) * 50, 0),
                child: Opacity(
                  opacity: value,
                  child: _buildOptionTile(
                    question['options'][index],
                    isSelected,
                    () => setState(() => selectedOptionIndex = index),
                    theme,
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildOptionTile(String text, bool selected, VoidCallback onTap, Map<String, dynamic> theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected ? theme['primary'].withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? theme['primary'] : Colors.grey.shade300,
                width: selected ? 2 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: theme['primary'].withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? theme['primary'] : Colors.transparent,
                    border: Border.all(
                      color: selected ? theme['primary'] : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: selected
                      ? Icon(Icons.check, color: Colors.white, size: 12)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected ? theme['primary'] : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(Map<String, dynamic> test, Map<String, dynamic> theme) {
    final isLastQuestion = currentQuestion == test['questions'].length - 1;
    final isEnabled = selectedOptionIndex != null;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? _nextQuestion : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? theme['primary'] : Colors.grey.shade300,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: isEnabled ? 4 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastQuestion ? 'Complete Assessment' : 'Next Question',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Icon(isLastQuestion ? Icons.check_circle : Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressText(Map<String, dynamic> test) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${currentQuestion + 1} of ${test['questions'].length} questions completed',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}