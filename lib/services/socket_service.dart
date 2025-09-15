import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'notification_manager.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late IO.Socket socket;
  bool _isConnected = false;

  /// Callbacks for friend status and messages
  Function(String friendId, bool isOnline)? onFriendStatusChanged;
  Function(Map<String, dynamic> message)? onMessageReceived;

  /// Initialize socket
  static Future<void> init(String userId, String socketUrl) async {
    _instance._connect(userId, socketUrl);
  }

  void _connect(String userId, String socketUrl) {
    if (_isConnected) return;

    socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableAutoConnect()
          .build(),
    );

    // --- Connected ---
    socket.onConnect((_) {
      print('✅ Socket.IO connected!');
      _isConnected = true;

      // Join personal room for this user
      socket.emit('join_user_room', userId);
      print('📥 Joined personal room: $userId');
    });

    // --- Friend status updates ---
    socket.on('statusUpdated', (data) {
      final friendId = data['userId'];
      final isOnline = data['isOnline'] ?? false;
      if (friendId != null) {
        onFriendStatusChanged?.call(friendId, isOnline);
      }
    });

    // --- Realtime notifications ---
    socket.on('new_notification', (data) {
      final notif = Map<String, dynamic>.from(data);

      // Ensure isRead exists
      if (!notif.containsKey('isRead')) {
        notif['isRead'] = false;
      }

      // Avoid duplicates
      final exists = NotificationManager.notifications.value.any(
        (n) => n['_id'] == notif['_id'],
      );

      if (!exists) {
        NotificationManager.addNotification(notif);
        print('📥 New notification: $notif');
      }
    });

    // --- Chat messages ---
    socket.on('new_message', (data) {
      final message = Map<String, dynamic>.from(data);
      onMessageReceived?.call(message);
      print('💬 New message: $message');
    });

    // --- Disconnected ---
    socket.onDisconnect((_) {
      print('❌ Disconnected from Socket.IO');
      _isConnected = false;
    });
  }

  // Join a chat room
  void joinChat(String chatId) => socket.emit('join_chat', chatId);

  // Send message through socket
  void sendMessage(String chatId, String text, {String type = "text"}) {
    socket.emit('send_message', {'chatId': chatId, 'text': text, 'type': type});
  }

  // Disconnect socket
  void disconnect() {
    socket.disconnect();
    _isConnected = false;
  }
}
