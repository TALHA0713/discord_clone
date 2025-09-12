import 'package:flutter/material.dart';
import 'left_block.dart';
import 'top_block.dart';
import 'center_block.dart';
// import 'bottom_block.dart';
import 'bottom_nav_block.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF36393F),
      body: SafeArea(
        child: Row(
          children: [
            // Server list
            const LeftBlock(),
            // Chat / main area
            Expanded(
              child: Column(
                children: const [
                  // Top bar with title + search + input
                  TopBlock(),
                  // Chat messages
                  Expanded(child: CenterBlock()),
                  // Message input
                  // BottomBlock(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBlock(),
    );
  }
}
