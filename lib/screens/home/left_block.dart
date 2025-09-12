import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class LeftBlock extends StatelessWidget {
  const LeftBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      color: const Color(0xFF202225),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Top Messages Icon
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.forum, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          // Short divider
          Container(
            width: 20,
            height: 1,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          // Scrollable server GIFs
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  serverGif('assets/images/1.gif'),
                  const SizedBox(height: 15),
                  serverGif('assets/images/2.gif'),
                  const SizedBox(height: 15),
                  serverGif('assets/images/3.gif'),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          // Discover icon
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 8),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF5865F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.explore, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  // Simple GIF loader without controller
  Widget serverGif(String path) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Gif(
        image: AssetImage(path),
        autostart: Autostart.loop,
        placeholder: (context) =>
            const Center(child: CircularProgressIndicator()),
        fit: BoxFit.cover,
      ),
    );
  }
}
