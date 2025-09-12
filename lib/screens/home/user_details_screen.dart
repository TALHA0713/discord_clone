import 'dart:async';
import 'package:discord_clone/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatefulWidget {
  final String name;
  final String? username;
  final String avatarUrl;

  const UserDetailScreen({
    super.key,
    required this.name,
    this.username,
    required this.avatarUrl,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  double progress = 0.0;
  Timer? timer;

  final int songDuration = 207; // total seconds (3:27)
  int currentTime = 0;

  @override
  void initState() {
    super.initState();

    // simulate playing track
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (currentTime < songDuration) {
        setState(() {
          currentTime++;
          progress = currentTime / songDuration;
        });
      } else {
        timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString();
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    const darkGray = Color(0xFF23272A);
    const gray = Color(0xFF2C2F33);
    const lightGray = Color(0xFFB9BBBE);
    const statusGreen = Color(0xFF43B581);

    return Scaffold(
      backgroundColor: darkGray,
       appBar: AppBar(
        backgroundColor: const Color(0xFF36393F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text(
          'User Detail',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // -------- Banner Section --------
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  color: Colors.green.shade300,
                  child: Image.network(
                    "https://picsum.photos/800/200",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Avatar + Actions Row
                  Transform.translate(
                    offset: const Offset(0, -60),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: darkGray, width: 4),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  widget.avatarUrl.isNotEmpty
                                      ? widget.avatarUrl
                                      : "https://picsum.photos/200",
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: statusGreen,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: darkGray, width: 4),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Transform.translate(
                          offset: const Offset(15, 70),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.paid, color: Colors.pinkAccent),
                              SizedBox(width: 12),
                              Icon(Icons.favorite_border, color: Colors.red),
                              SizedBox(width: 12),
                              Icon(Icons.change_history, color: Colors.blue),
                              SizedBox(width: 12),
                              Icon(Icons.more_horiz, color: Colors.grey),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // -------- User Info --------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: gray,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.username != null && widget.username!.isNotEmpty)
                      Text(
                        widget.username!,
                        style: const TextStyle(color: lightGray, fontSize: 16),
                      ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: darkGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: const [
                          Text("🌴", style: TextStyle(fontSize: 24)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "just doing some frog fractions",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Clears in 49 minutes",
                                  style: TextStyle(
                                    color: lightGray,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.close, color: lightGray),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // -------- Spotify Section (with running bar) --------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: gray,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Listening on Spotify",
                      style: TextStyle(
                        color: lightGray,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://picsum.photos/64",
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dear Friend",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "by Saeko Suzuki",
                                style: TextStyle(color: lightGray),
                              ),
                              Text(
                                "on Keroro Gunsou OST",
                                style: TextStyle(color: lightGray),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.music_note,
                          color: Colors.green,
                          size: 32,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade700,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatTime(currentTime),
                              style: const TextStyle(
                                color: lightGray,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              formatTime(songDuration),
                              style: const TextStyle(
                                color: lightGray,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // -------- About Me Section --------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: gray,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About Me",
                      style: TextStyle(
                        color: lightGray,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "hello! i am cheddar and i am on the computer",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // -------- Member Since Section --------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: gray,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "Member Since: Jan 2024",
                  style: TextStyle(color: lightGray, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
