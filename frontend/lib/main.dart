import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/screens/chatbot_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'models/mood_provider.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/logs_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Gemini with your actual API key (DO NOT expose this publicly)
  Gemini.init(apiKey: "AIzaSyD4OL9n18zDRxT3AhX060fOo14Fw5KfiYg"); // ← <-- Put your Gemini key here

  // Initialize notifications
  await NotificationService.initialize();

  // Daily reminders
  NotificationService.scheduleDailyNotification(
    id: 1,
    title: '💧 Hydration Reminder',
    body: 'Time to drink water!',
    hour: 10,
    minute: 0,
  );

  NotificationService.scheduleDailyNotification(
    id: 2,
    title: '🧘 Self-care Break',
    body: 'Take a 5-minute break to relax.',
    hour: 14,
    minute: 0,
  );

  NotificationService.scheduleDailyNotification(
    id: 3,
    title: '🚶 Walk Reminder',
    body: 'Time to take a short walk!',
    hour: 17,
    minute: 30,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => MoodProvider(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'MindSpace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF4CAF50),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4CAF50),
          secondary: Color(0xFF81C784),
          surface: Colors.white,
          error: Color(0xFFE57373),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Color(0xFF2E3A59),
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2E3A59)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2E3A59),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/logs': (context) => LogsScreen(),
        '/chatbot': (context) => const ChatBotPage(),
      },
    );
  }
}
