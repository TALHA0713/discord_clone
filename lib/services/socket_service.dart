import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'notification_manager.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late IO.Socket socket;
  bool _isConnected = false;

  /// Callbacks
  Function(String friendId, bool isOnline)? onFriendStatusChanged;
  Function(Map<String, dynamic> message)? onMessageReceived;

  /// Currently open chat (chatId), used to mark messages read automatically
  String? _currentOpenChatId;

  /// Initialize socket
  static Future<void> init(String userId, String socketUrl) async {
    _instance._connect(userId, socketUrl);
  }

  /// Set the currently open chat
  void setCurrentOpenChat(String? chatId) {
    _currentOpenChatId = chatId;

    // Mark messages as read for this chat
    if (chatId != null) {
      NotificationManager.markChatRead(chatId);
    }
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

      // Join personal room
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

    // --- Notifications ---
    socket.on('new_notification', (data) {
      final notif = Map<String, dynamic>.from(data);
      if (!notif.containsKey('isRead')) notif['isRead'] = false;
      NotificationManager.addNotification(notif);
      print('📥 New notification: $notif');
    });

    // --- Chat messages ---
    socket.on('new_message', (data) {
      final message = Map<String, dynamic>.from(data);

      // 1️⃣ Real-time callback to UI
      onMessageReceived?.call(message);

      // 2️⃣ If chat is not open, add to notifications
      if (_currentOpenChatId != message['chatId']) {
        NotificationManager.addMessageNotification(message);
      } else {
        // Mark message as read if chat is open
        NotificationManager.markChatRead(message['chatId']);
      }

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

  // Send message
  void sendMessage(String chatId, String text, {String type = "text"}) {
    socket.emit('send_message', {'chatId': chatId, 'text': text, 'type': type});
  }

  // Disconnect socket
  void disconnect() {
    socket.disconnect();
    _isConnected = false;
  }
}
