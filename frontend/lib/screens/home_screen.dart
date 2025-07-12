import 'package:flutter/material.dart';
import 'journal_screen.dart';
import 'assessment_screen.dart';
import 'home_content.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(), 
    const JournalScreen(),
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
                label: 'Journal',
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

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Notifications'));
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
      },
      {
        'title': 'Meditation for Beginners',
        'description': 'Meditation can help reduce stress and anxiety. Learn how to start with just 5 minutes a day.',
        'readTime': '3 min read',
        'category': 'Mindfulness',
        'color': const Color(0xFF9F7AEA),
      },
      {
        'title': 'How to Deal with Burnout',
        'description': 'Feeling exhausted all the time? Learn the signs of burnout and ways to recover from it.',
        'readTime': '7 min read',
        'category': 'Recovery',
        'color': const Color.fromARGB(255, 112, 209, 79),
      },
      {
        'title': 'The Power of Gratitude',
        'description': 'Practicing gratitude daily can shift your mindset and improve your emotional well-being.',
        'readTime': '4 min read',
        'category': 'Positivity',
        'color': const Color(0xFF4FD1C7),
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
                        // Handle blog tap
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