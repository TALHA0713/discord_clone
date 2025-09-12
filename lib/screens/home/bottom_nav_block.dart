import 'package:flutter/material.dart';
import 'notification_screen.dart';
import '../settings/settings_screen.dart';

class BottomNavBlock extends StatefulWidget {
  const BottomNavBlock({super.key});

  @override
  State<BottomNavBlock> createState() => _BottomNavBlockState();
}

class _BottomNavBlockState extends State<BottomNavBlock> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NotificationScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF36393F),
      selectedItemColor: const Color(0xFF5865F2),
      unselectedItemColor: Colors.white54,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "Notification",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
    );
  }
}
