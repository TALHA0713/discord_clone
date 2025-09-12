import 'package:flutter/material.dart';

class ChatAvatarsBar extends StatelessWidget {
  const ChatAvatarsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  "https://randomuser.me/api/portraits/men/${index + 5}.jpg",
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
