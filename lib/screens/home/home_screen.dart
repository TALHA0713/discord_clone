import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF36393F),
      appBar: AppBar(
        title: const Text("Discord Clone"),
        backgroundColor: const Color(0xFF202225),
      ),
      body: const Center(
        child: Text(
          "Home Screen (Servers & Channels will go here)",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
