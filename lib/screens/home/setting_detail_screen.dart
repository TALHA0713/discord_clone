import 'package:flutter/material.dart';
import '../settings/settings_screen.dart';

class SettingDetailScreen extends StatelessWidget {
  final String title;
  final Widget? child;
  const SettingDetailScreen({super.key, required this.title, this.child});

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
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      body: child ?? Center(
        child: Text(
          '$title Page',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
