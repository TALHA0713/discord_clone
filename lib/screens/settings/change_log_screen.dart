import 'package:flutter/material.dart';
import 'settings_screen.dart';

class ChangeLogScreen extends StatelessWidget {
  const ChangeLogScreen({super.key});

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
        title: const Text('Change Log', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text('Change Log', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
