import 'package:flutter/material.dart';
import 'settings_screen.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F3136),
      appBar: AppBar(
        backgroundColor: const Color(0xFF36393F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
        title: const Text('Language', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text('Language Settings', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
