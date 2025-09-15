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

  // Mark all notifications as read locally
  static void markAllRead() {
    notifications.value = notifications.value.map((n) {
      n['isRead'] = true;
      return n;
    }).toList();
  }

  // Remove notifications by list of IDs (for deleted notifications)
  static void removeNotificationsByIds(List<String> ids) {
    notifications.value = notifications.value
        .where((n) => !ids.contains(n['_id']))
        .toList();
  }
}
