import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  final String friendName;
  final String friendAvatar;
  final bool isOnline;
  final String friendId; // friend's ID
  final Map<String, dynamic> chat; // chat object

  const ChatScreen({
    super.key,
    required this.friendName,
    required this.friendAvatar,
    required this.isOnline,
    required this.friendId,
    required this.chat,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  bool _showScrollToBottom = false;

  late List<Map<String, dynamic>> _messages;
  late String myId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Determine myId safely
    myId = "";
    if (widget.chat.isNotEmpty &&
        widget.chat['participants'] != null &&
        widget.chat['participants'] is List) {
      final participants = List<Map<String, dynamic>>.from(
        widget.chat['participants'],
      );
      try {
        final you = participants.firstWhere(
          (p) => p['_id'] != widget.friendId,
          orElse: () => {'_id': ''},
        );
        myId = you['_id'] ?? '';
      } catch (e) {
        myId = '';
      }
    }

    // Load messages safely
    _messages = [];
    if (widget.chat.isNotEmpty &&
        widget.chat['messages'] != null &&
        widget.chat['messages'] is List) {
      _messages = List<Map<String, dynamic>>.from(widget.chat['messages']);
    }

    // Listen to real-time messages for this chat
    SocketService().onMessageReceived = (message) {
      if (message['chatId'] == widget.chat['_id']) {
        setState(() {
          _messages.add(message);
        });
        _scrollToBottom();
      }
    };

    // Set current open chat for SocketService
    SocketService().setCurrentOpenChat(widget.chat['_id']);

    // Join chat room
    SocketService().joinChat(widget.chat['_id']);

    _scrollController.addListener(() {
      if (_scrollController.offset <
          _scrollController.position.maxScrollExtent - 200) {
        setState(() => _showScrollToBottom = true);
      } else {
        setState(() => _showScrollToBottom = false);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  DateTime _parseTime(dynamic time) {
    if (time is DateTime) return time;
    if (time is String) return DateTime.tryParse(time) ?? DateTime.now();
    return DateTime.now();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  // ---------------- SEND MESSAGE ----------------
  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final tempMessage = {
      "sender": myId,
      "text": text.trim(),
      "createdAt": DateTime.now().toIso8601String(),
      "chatId": widget.chat['_id'],
    };

    setState(() {
      _messages.add(tempMessage);
    });

    _textController.clear();
    _scrollToBottom();

    // 1️⃣ Send via Socket (real-time)
    SocketService().sendMessage(widget.chat['_id'], text.trim());

    // 2️⃣ Save to backend (for persistence)
    final success = await ApiService.sendMessage(
      widget.chat['_id'],
      text.trim(),
    );

    if (!success) {
      // Optionally handle unsent messages
      print("Failed to save message to backend");
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (DateUtils.isSameDay(date, now)) return "Today";
    if (DateUtils.isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return "Yesterday";
    }
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF36393F),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF2F3136),
          elevation: 4,
          titleSpacing: 0,
          title: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.friendAvatar),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.friendName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.isOnline ? "Online" : "Offline",
                    style: TextStyle(
                      color: widget.isOnline ? Colors.green : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.call, color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.videocam, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              itemCount: _messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildProfileSection();

                final msg = _messages[index - 1];
                final prevMsg = index > 1 ? _messages[index - 2] : null;

                final showDateDivider =
                    prevMsg == null ||
                    _formatDate(_parseTime(prevMsg["createdAt"])) !=
                        _formatDate(_parseTime(msg["createdAt"]));

                final isMe = msg["sender"] == myId;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateDivider)
                      _buildDateDivider(
                        _formatDate(_parseTime(msg["createdAt"])),
                      ),
                    _buildMessage(
                      senderName: isMe ? "You" : widget.friendName,
                      senderImage: isMe
                          ? "https://ui-avatars.com/api/?background=0D8ABC&color=fff&name=You"
                          : widget.friendAvatar,
                      time: DateFormat(
                        "hh:mm a",
                      ).format(_parseTime(msg["createdAt"])),
                      message: msg["text"].toString(),
                      isMe: isMe,
                    ),
                  ],
                );
              },
            ),
          ),
          _buildBottomBar(),
        ],
      ),
      floatingActionButton: _showScrollToBottom
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF2F3136),
              mini: true,
              onPressed: _scrollToBottom,
              child: const Icon(Icons.arrow_downward, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(widget.friendAvatar),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.friendName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "This is the very beginning of your legendary conversation.",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDivider(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          date,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildMessage({
    required String senderName,
    required String senderImage,
    required String time,
    required String message,
    required bool isMe,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(senderImage),
            ),
          if (!isMe) const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blueAccent : Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 12),
          if (isMe)
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(senderImage),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8),
        color: const Color(0xFF2F3136),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.grey, size: 30),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                onSubmitted: _sendMessage,
                decoration: InputDecoration(
                  hintText: "Message @${widget.friendName}...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF40444B),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.blueAccent),
              onPressed: () => _sendMessage(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}
