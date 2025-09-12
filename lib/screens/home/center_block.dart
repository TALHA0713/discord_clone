import 'package:flutter/material.dart';
import 'chat_avatars_bar.dart';
import 'chat_list.dart';

class CenterBlock extends StatelessWidget {
  const CenterBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ChatAvatarsBar(),
        Expanded(child: ChatList()),
      ],
    );
  }
}
