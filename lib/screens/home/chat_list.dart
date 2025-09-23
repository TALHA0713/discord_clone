import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import './user_details_screen.dart';
import './chat_screen.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<dynamic> friends = [];
  List<dynamic> chats = [];
  bool isLoading = true;

  final String defaultAvatar =
      "https://lh3.googleusercontent.com/aida-public/AB6AXuB6VlBzH2yVuaPntkoGZlABZuAWfUCqOvVe8d8OxVY16Enp7iZLTRKk4clMZmHYmpMaYegr-FKcdLaSKel8Y-wzuB6Cl8o7gE4QV-f0VrN7wF6OUtSqmD05xCRnJzuqmAM8H8Wg5MkoN2LI7NkUWYXkUh_7oMEhMOjSI_dGvKylEDt-QvckXWCkEcyE5ZwvfC4VKG9F6JGZ4SwpYGBvzJM6I0tQlvuxLWuKbtJ4-4yTAN4xhpaWBQCY5H1Htu3i8XvB4uUw04HYLTkA";

  @override
  void initState() {
    super.initState();
    loadFriendsAndChats();
  }

  Future<void> loadFriendsAndChats() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getFriends();
      if (data != null) {
        setState(() {
          friends = data['friends'] ?? [];
          chats = data['chats'] ?? [];
        });
        await ApiService.saveFriendsData(data);
      }
    } catch (e) {
      print("Error fetching friends and chats: $e");
      final savedData = await ApiService.getSavedFriends();
      if (savedData != null) {
        setState(() {
          friends = savedData['friends'] ?? [];
          chats = savedData['chats'] ?? [];
        });
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  String getLastMessage(String friendId) {
    try {
      final chat = chats.firstWhere(
        (c) =>
            c is Map<String, dynamic> &&
            !(c['isGroup'] ?? false) &&
            (c['participants'] as List<dynamic>).any(
              (p) => p['_id'] == friendId,
            ),
        orElse: () => <String, dynamic>{},
      );

      if (chat.isNotEmpty &&
          chat['messages'] != null &&
          (chat['messages'] as List).isNotEmpty) {
        final lastMsg = (chat['messages'] as List).last;
        return lastMsg['text']?.toString() ?? "No messages yet";
      }
      return "No messages yet";
    } catch (e) {
      print("Error in getLastMessage: $e");
      return "No messages yet";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        final friendId = friend['_id'].toString();
        final lastMessage = getLastMessage(friendId);
        final isOnline = friend['isOnline'] ?? false;
        final avatarUrl =
            (friend['avatar'] != null && friend['avatar'].toString().isNotEmpty)
            ? friend['avatar']
            : defaultAvatar;
        final bio = friend['bio'] ?? "";
        final memberSince = friend['memberSince'] ?? "";

        final chat = chats.firstWhere(
          (c) =>
              c is Map<String, dynamic> &&
              !(c['isGroup'] ?? false) &&
              (c['participants'] as List<dynamic>).any(
                (p) => p['_id'] == friendId,
              ),
          orElse: () => <String, dynamic>{},
        );

        return chatTile(
          context: context,
          name: friend['username'] ?? "Unknown",
          message: lastMessage,
          avatarUrl: avatarUrl,
          isOnline: isOnline,
          bio: bio,
          memberSince: memberSince,
          friendId: friendId,
          chat: chat,
        );
      },
    );
  }

  Widget chatTile({
    required BuildContext context,
    required String name,
    String? message,
    required String avatarUrl,
    bool isOnline = false,
    bool isSelected = false,
    int unreadCount = 0,
    String? bio,
    String? memberSince,
    required String friendId,
    required Map<String, dynamic> chat,
  }) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey[700] : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserDetailScreen(
                        name: name,
                        avatarUrl: avatarUrl,
                        username: name,
                        isOnline: isOnline,
                        bio: bio,
                        memberSince: memberSince,
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // If no chat exists, call API to create
                    if (chat.isEmpty ||
                        !(chat['participants'] as List).any(
                          (p) => p['_id'] == friendId,
                        )) {
                      await ApiService.create1on1Chat(friendId);
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          friendName: name,
                          friendAvatar: avatarUrl,
                          isOnline: isOnline,
                          friendId: friendId,
                          chat: chat,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (message != null)
                        Text(
                          message,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),

              if (unreadCount > 0)
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Divider(color: Colors.grey[700], thickness: 0.5, height: 0),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import './user_details_screen.dart';

// class ChatList extends StatelessWidget {
//   const ChatList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 12),
//         chatTile(
//           context: context,
//           name: "Flutter App",
//           message: "graggle: Can someone explain #4?",
//           avatarUrl:
//               "https://lh3.googleusercontent.com/aida-public/AB6AXuC1udxQG8jHp9lQsBX36Fe9JhuSK0wndqGStApffeMajBLH9FbuE4YhvpNuOXcR56WMee41X2IJE4w8752LIghx7-vas0sIOUqxdINa4m5jebZkLyO92WTecxJhBU8Otf2E1IRWBtBAcJzzA_aBkth-rpiDbocTOmnKCh_CKh_wWif6rMmG5cO0jvSlz9ZKPBEzwA1x0XieXsrvk8dAdejq4ijs_xusvq29X6i90dpIe5iBiPlHRpihX1hhBwTEPvH7_lMSRNzrobPU",
//           unreadCount: 2,
//           isSelected: true,
//         ),
//         chatTile(
//           context: context,
//           name: "Edex",
//           message: "nelly: Enjoy your trip to Spain!",
//           avatarUrl:
//               "https://lh3.googleusercontent.com/aida-public/AB6AXuDpOVKKFt_-mz_ZPtMzDreqwkmgIQBrp_0Lm29wrgO-763v02G1swLHRxFYKwmFYojxf-AKYNIvoDbOrrn0uUxuHT2g_3gIZ9W_bBVZt4g6J9QGjzl3_r_lNBwMjpbNo8uHBLgkRmfS0yyqGV2aoxnI5q8pn0WAJmGE0UeM7jNUkAQgLYLhAOzAi61rg4upmRM4fsXNLrze83sMJwCuFi6Bf5SXX1L9awFhScrToewDqnCm2UIjgOWaALRrq8qVWbFhpPqsAeE7jpkA",
//           showDot: true,
//         ),
//         chatTile(
//           context: context,
//           name: "Manan",
//           avatarUrl:
//               "https://lh3.googleusercontent.com/aida-public/AB6AXuAErgAqT5Jmos5Osmwe1MUW2jAwUyoLUBmSgJZuDeVtk8_xV90l9FPNnlg4E1aVa4noH3hIGF-KETHHdWKdhgqrzKvnzP6p2jUzcmy-qBcHdJR9UaLk3eDnCOqSoPg2dUrnZykPRAc3btXLfKQo9_Nv07q9TyMUhBJ9RryKtC9b_4fwo_S5RKl0oY_Q1XmoWhLLJAQ7WDr7rX4Ea8mfcHHfNJLOKYG7F7y0MpF3pFDgXHaKwOoxOvLsyohXcgD3sgC1Ep9DNKyElMfA",
//         ),
//         chatTile(
//           context: context,
//           name: "Scarlet",
//           avatarUrl:
//               "https://lh3.googleusercontent.com/aida-public/AB6AXuDU1rg-LuciM1SBCF7ykWXYaoZFQQytPitP0Z4SfzDJ4B0G0XcPbYehw1Ox5Tuwgp49vAxwBVsnX_TEyQYVJXkO0bzb7JdaZBaPaBTYhqQTqqTciGg2sCSNnkZ1DbhiIw-fYW4Y56KgSzxNlOCxq5QF38kPVgsAHY1I_ROjCY5rDzOLqeSG7mKOWrHpee_-hsc6LG7PzcPfkqrDXdP8DM7emQUnOAo9ySR0i5Q9XHesNFKJVKO7Uijf4s3Fbo11bVieYe06ds8yDPXs",
//         ),
//         chatTile(
//           context: context,
//           name: "MSAD",
//           avatarUrl:
//               "https://lh3.googleusercontent.com/aida-public/AB6AXuCVbLmCkOMtULtNwP-dgTt6x0uVR2_IodIUTPdZefxCiqr__QNCzUr4NREuHxXpZICYoWJqbA98eUtaGpRsdNV-ccSa5LA3z2vpErQbY0aXx_g7SXvEEz-eTOgsY1mnLKCYzaiKhnzbVVw3fxoVNcxeIe2dvBjHq0Xfp7EMCXddBs7c9bdytUhrBsZgynWigQLcKoqzEfzeV10zFgJKp5NxHF4AbAqJYZxYg0r-GIb1OogtPyxu_Eea2SXKhQWK_fSytHRIudJLXaJK",
//         ),
//         chatTile(
//           context: context,
//           name: "QUA",
//           avatarUrl:
//               "https://lh3.googleusercontent.com/aida-public/AB6AXuB6VlBzH2yVuaPntkoGZlABZuAWfUCqOvVe8d8OxVY16Enp7iZLTRKk4clMZmHYmpMaYegr-FKcdLaSKel8Y-wzuB6Cl8o7gE4QV-f0VrN7wF6OUtSqmD05xCRnJzuqmAM8H8Wg5MkoN2LI7NkUWYXkUh_7oMEhMOjSI_dGvKylEDt-QvckXWCkEcyE5ZwvfC4VKG9F6JGZ4SwpYGBvzJM6I0tQlvuxLWuKbtJ4-4yTAN4xhpaWBQCY5H1Htu3i8XvB4uUw04HYLTkA",
//         ),
//       ],
//     );
//   }

//   Widget chatTile({
//     required BuildContext context,
//     required String name,
//     String? message,
//     required String avatarUrl,
//     String? secondAvatarUrl,
//     bool isSelected = false,
//     int unreadCount = 0,
//     bool showDot = false,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.grey[700] : Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => UserDetailScreen(
//                     name: name,
//                     avatarUrl: avatarUrl,
//                   ),
//                 ),
//               );
//             },
//             child: Stack(
//               children: [
//                 secondAvatarUrl == null
//                     ? CircleAvatar(
//                         radius: 24,
//                         backgroundImage: NetworkImage(avatarUrl),
//                       )
//                     : SizedBox(
//                         width: 48,
//                         height: 48,
//                         child: Stack(
//                           children: [
//                             Positioned(
//                               left: 0,
//                               child: CircleAvatar(
//                                 radius: 18,
//                                 backgroundImage: NetworkImage(avatarUrl),
//                               ),
//                             ),
//                             Positioned(
//                               right: 0,
//                               child: CircleAvatar(
//                                 radius: 18,
//                                 backgroundImage: NetworkImage(secondAvatarUrl),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: Container(
//                     width: 12,
//                     height: 12,
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       border: Border.all(
//                         color: const Color(0xFF212328),
//                         width: 2,
//                       ),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight:
//                         isSelected ? FontWeight.bold : FontWeight.normal,
//                   ),
//                 ),
//                 if (message != null)
//                   Text(
//                     message,
//                     style: const TextStyle(color: Colors.grey, fontSize: 13),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//               ],
//             ),
//           ),
//           if (unreadCount > 0)
//             Container(
//               width: 20,
//               height: 20,
//               decoration: const BoxDecoration(
//                 color: Colors.red,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text(
//                   unreadCount.toString(),
//                   style: const TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               ),
//             ),
//           if (showDot)
//             Container(
//               width: 10,
//               height: 10,
//               margin: const EdgeInsets.only(left: 8),
//               decoration: const BoxDecoration(
//                 color: Colors.blue,
//                 shape: BoxShape.circle,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
