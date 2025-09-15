import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ChatAvatarsBar extends StatefulWidget {
  const ChatAvatarsBar({super.key});

  @override
  State<ChatAvatarsBar> createState() => _ChatAvatarsBarState();
}

class _ChatAvatarsBarState extends State<ChatAvatarsBar> {
  bool _loading = true;
  List<dynamic> _onlineFriends = [];

  // Default avatar (always used since backend has no image)
  final String defaultAvatar =
      "https://lh3.googleusercontent.com/aida-public/AB6AXuDU1rg-LuciM1SBCF7ykWXYaoZFQQytPitP0Z4SfzDJ4B0G0XcPbYehw1Ox5Tuwgp49vAxwBVsnX_TEyQYVJXkO0bzb7JdaZBaPaBTYhqQTqqTciGg2sCSNnkZ1DbhiIw-fYW4Y56KgSzxNlOCxq5QF38kPVgsAHY1I_ROjCY5rDzOLqeSG7mKOWrHpee_-hsc6LG7PzcPfkqrDXdP8DM7emQUnOAo9ySR0i5Q9XHesNFKJVKO7Uijf4s3Fbo11bVieYe06ds8yDPXs";

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    setState(() => _loading = true);

    final data = await ApiService.getFriends();
    if (data != null && data['friends'] != null) {
      final friends = data['friends'] as List<dynamic>;
      // Use isOnline instead of status
      final online = friends.where((f) => f['isOnline'] == true).toList();

      setState(() {
        _onlineFriends = online;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_onlineFriends.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            "No friends online",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _onlineFriends.length,
        itemBuilder: (context, index) {
          return Container(
            width: 90,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(defaultAvatar),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
