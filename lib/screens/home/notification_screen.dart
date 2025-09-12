import 'package:flutter/material.dart';
import 'home_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Predefined avatar colors like Discord
  Color getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    // Dummy notification data
    final List<Map<String, dynamic>> notifications = [
      {
        "title": "Talha",
        "subtitle": "Hey! Are you joining the call?",
        "time": "2m ago",
        "isUnread": true,
      },
      {
        "title": "Gaming Server",
        "subtitle": "New message in #general",
        "time": "10m ago",
        "isUnread": false,
      },
      {
        "title": "John Doe",
        "subtitle": "Let's play later!",
        "time": "1h ago",
        "isUnread": true,
      },
      {
        "title": "Study Group",
        "subtitle": "Reminder: Meeting at 5 PM",
        "time": "2h ago",
        "isUnread": false,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF2F3136), // Discord dark background
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF36393F),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final String name = notification['title'];
          final String initials = _getInitials(name);
          final Color avatarColor = getAvatarColor(name);

          return InkWell(
            onTap: () {
              // Navigate to specific chat or server
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Opening ${notification['title']}...")),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: notification['isUnread']
                    ? const Color(0xFF393C43) // Highlight unread
                    : Colors.transparent,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circle Avatar with Initials
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: avatarColor,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title, Subtitle, and Time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notification['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(
                              notification['time'],
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification['subtitle'],
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper to get initials from a name
  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.length > 1) {
      return (words[0][0] + words[1][0]).toUpperCase();
    } else {
      return words[0][0].toUpperCase();
    }
  }
}
