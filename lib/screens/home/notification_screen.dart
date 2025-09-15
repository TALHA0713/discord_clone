import 'package:flutter/material.dart';
import '../../services/notification_manager.dart';
import '../../services/socket_service.dart';
import '../../services/api_service.dart';
import '../home/home_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    _listenRealtimeNotifications();
    _markAllAsRead(); // mark all read on open
  }

  // Fetch notifications from backend
  Future<void> _fetchNotifications() async {
    try {
      final List<dynamic>? notifs = await ApiService.getNotifications();

      final List<Map<String, dynamic>> updated = (notifs ?? [])
          .map((n) => Map<String, dynamic>.from(n))
          .toList();

      for (var notif in updated) {
        if (notif['from'] != null) {
          notif['from'] = {
            '_id': notif['from']['_id'] ?? "unknown_id",
            'username': notif['from']['username'] ?? "Unknown",
          };
        }
        notif['status'] ??= "pending"; // Ensure status exists
        notif['isRead'] ??= false;
      }

      NotificationManager.notifications.value = updated;
    } catch (e) {
      print("Failed to fetch notifications: $e");
    }
  }

  // Listen for realtime notifications
  void _listenRealtimeNotifications() {
    SocketService().socket.on('new_notification', (data) {
      final notif = Map<String, dynamic>.from(data);

      notif['message'] ??= notif['subtitle'] ?? "Unknown";
      notif['from'] ??= {
        '_id': notif['fromId'] ?? notif['userId'] ?? "unknown_id",
        'username': notif['title'] ?? "Unknown",
      };
      notif['status'] ??= "pending";
      notif['isRead'] ??= false;

      NotificationManager.addNotification(notif);
      print("Realtime notification received: $notif");
    });
  }

  // Mark all notifications as read
  Future<void> _markAllAsRead() async {
    final success = await ApiService.markAllNotificationsRead();
    if (success) {
      final updated = NotificationManager.notifications.value.map((notif) {
        notif['isRead'] = true;
        return notif;
      }).toList();
      NotificationManager.notifications.value = updated;
    }
  }

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
    return Scaffold(
      backgroundColor: const Color(0xFF2F3136),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF36393F),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.white),
            tooltip: "Mark all read",
            onPressed: _markAllAsRead,
          ),
        ],
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
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: NotificationManager.notifications,
        builder: (context, notifications, _) {
          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                "No notifications yet",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final fromUser = notification['from'] ?? {};
              final String name = fromUser['username'] ?? "Unknown";
              final String id = fromUser['_id'] ?? "";
              final String initials = _getInitials(name);
              final Color avatarColor = getAvatarColor(name);
              final String type = notification['type'] ?? "";
              final String status = notification['status'] ?? "pending";
              final bool isRead = notification['isRead'] ?? false;

              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF393C43),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isRead ? Colors.transparent : Colors.blue,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 28,
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['message'] ?? "Unknown",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notification['createdAt'] != null
                                      ? DateTime.parse(
                                          notification['createdAt'],
                                        ).toLocal().toString().split('.')[0]
                                      : "",
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 12,
                                  ),
                                ),
                                // ✅ Show tick/cross only if friend request is pending
                                if (type == 'friend_request' &&
                                    status == 'pending' &&
                                    id.isNotEmpty)
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        onPressed: () async {
                                          final success =
                                              await ApiService.acceptFriendRequest(
                                                id,
                                              );
                                          if (success) {
                                            setState(() {
                                              NotificationManager
                                                      .notifications
                                                      .value[index]['status'] =
                                                  'accepted';
                                              NotificationManager
                                                      .notifications
                                                      .value[index]['isRead'] =
                                                  true;
                                            });
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          final success =
                                              await ApiService.rejectFriendRequest(
                                                id,
                                              );
                                          if (success) {
                                            setState(() {
                                              NotificationManager
                                                      .notifications
                                                      .value[index]['status'] =
                                                  'rejected';
                                              NotificationManager
                                                      .notifications
                                                      .value[index]['isRead'] =
                                                  true;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.length > 1) {
      return (words[0][0] + words[1][0]).toUpperCase();
    } else {
      return words[0][0].toUpperCase();
    }
  }
}
