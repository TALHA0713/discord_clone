import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'screens/auth/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ only initialize API (baseUrl etc.)
  await ApiService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Discord Clone',
      theme: ThemeData.dark(),
      home: const WelcomeScreen(),
    );
  }
}
