import 'package:flutter/material.dart';

class NotificationManager {
  // List of notifications
  static ValueNotifier<List<Map<String, dynamic>>> notifications =
      ValueNotifier([]);

  // Add notification if it doesn't exist yet
  static void addNotification(Map<String, dynamic> notif) {
    final exists = notifications.value.any((n) => n['_id'] == notif['_id']);
    if (!exists) {
      notifications.value = [...notifications.value, notif];
    } else {
      // Update existing notification (for example: if marked read)
      notifications.value = notifications.value.map((n) {
        if (n['_id'] == notif['_id']) {
          return {...n, ...notif};
        }
        return n;
      }).toList();
    }
  }

  // Add message as notification if user is offline or chat not open
  static void addMessageNotification(Map<String, dynamic> message) {
    final notif = {
      '_id': message['_id'],
      'text': message['text'],
      'senderId': message['senderId'],
      'chatId': message['chatId'],
      'type': message['type'] ?? 'text',
      'isRead': false,
      'timestamp': message['createdAt'] ?? DateTime.now().toIso8601String(),
    };
    addNotification(notif);
  }

  // Mark all notifications as read locally
  static void markAllRead() {
    notifications.value = notifications.value.map((n) {
      n['isRead'] = true;
      return n;
    }).toList();
  }

  // Mark all notifications for a specific chat as read
  static void markChatRead(String chatId) {
    notifications.value = notifications.value.map((n) {
      if (n['chatId'] == chatId) n['isRead'] = true;
      return n;
    }).toList();
  }

  // Remove notifications by list of IDs (for deleted notifications)
  static void removeNotificationsByIds(List<String> ids) {
    notifications.value = notifications.value
        .where((n) => !ids.contains(n['_id']))
        .toList();
  }

  // Get unread notifications count
  static int getUnreadCount() {
    return notifications.value.where((n) => n['isRead'] == false).length;
  }

  // Get unread messages for a specific chat
  static List<Map<String, dynamic>> getUnreadMessagesForChat(String chatId) {
    return notifications.value
        .where((n) => n['chatId'] == chatId && n['isRead'] == false)
        .toList();
  }
}
