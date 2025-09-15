import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'socket_service.dart';
import '../config.dart';

class ApiService {
  static final storage = FlutterSecureStorage();
  static String? _cachedBaseUrl;
  static String? _cachedSocketUrl;

  static Future<void> init() async {
    _cachedBaseUrl = await Config.baseUrl;
    _cachedSocketUrl = await Config.socketUrl;
  }

  static String get baseUrl {
    if (_cachedBaseUrl == null) {
      throw Exception(
        "ApiService not initialized. Call ApiService.init() first.",
      );
    }
    return _cachedBaseUrl!;
  }

  static String get socketUrl {
    if (_cachedSocketUrl == null) {
      throw Exception(
        "ApiService not initialized. Call ApiService.init() first.",
      );
    }
    return _cachedSocketUrl!;
  }

  // ---------------- Token Storage ----------------
  static Future<void> saveToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  static Future<bool> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        // Clear local data
        await storage.delete(key: 'jwt_token');
        await storage.delete(key: 'user_data');
        return true;
      } else {
        print('Logout failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Logout error: $e');
    }
    return false;
  }

  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<void> saveUserData(Map<String, dynamic> user) async {
    await storage.write(key: 'user_data', value: jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getSavedUserData() async {
    final jsonString = await storage.read(key: 'user_data');
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  // Save the entire friends + chats data
  static Future<void> saveFriendsData(Map<String, dynamic> data) async {
    await storage.write(key: 'friends_data', value: jsonEncode(data));
  }

  // Load the saved friends + chats data
  static Future<Map<String, dynamic>?> getSavedFriends() async {
    final jsonString = await storage.read(key: 'friends_data');
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  // ---------------- Auth ----------------
  static Future<Map<String, dynamic>?> login(
    String emailOrPhone,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'emailOrPhone': emailOrPhone, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data['token'];
        final userId = data['userId'];

        if (token == null || userId == null) {
          print("Error: Missing token or userId in response.");
          return null;
        }

        await saveToken(token);

        final userData = await getCurrentUser();
        if (userData != null) {
          await saveUserData(userData);

          // ✅ connect socket using cached socketUrl
          await SocketService.init(userId, socketUrl);

          return {'token': token, 'user': userData};
        }
      }
    } catch (e) {
      print('Login error: $e');
    }
    return null;
  }

  static Future<bool> register(
    String username,
    String emailOrPhone,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'emailOrPhone': emailOrPhone,
          'password': password,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  static Future<bool> forgotPassword(String emailOrPhone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'emailOrPhone': emailOrPhone}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Forgot password error: $e');
      return false;
    }
  }

  static Future<bool> resetPassword(String token, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'newPassword': newPassword}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }

  // ---------------- User ----------------
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        // Save full user data locally
        await saveUserData(userData);

        return userData;
      } else {
        print('Failed to fetch current user. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Get current user error: $e');
    }
    return null;
  }

  static Future<List<dynamic>?> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: await getHeaders(),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      print('Get all users error: $e');
    }
    return null;
  }

  static Future<bool> updateProfile({
    String? avatar,
    String? statusText,
    String? bio, // NEW
  }) async {
    try {
      final body = {};
      if (avatar != null) body['avatar'] = avatar;
      if (statusText != null) body['statusText'] = statusText;
      if (bio != null) body['bio'] = bio; // NEW

      final response = await http.put(
        Uri.parse('$baseUrl/users/me/update-profile'),
        headers: await getHeaders(),
        body: jsonEncode(body),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  // Logout
  static Future<bool> logoutUser() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: await getHeaders(),
      );
      if (response.statusCode == 200) {
        await logout(); // clear token
        return true;
      }
    } catch (e) {
      print('Logout error: $e');
    }
    return false;
  }

  // Fetch friends
  static Future<Map<String, dynamic>?> getFriends() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/me/friends'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> friendsData = jsonDecode(response.body);
        await saveFriendsData(friendsData);
        return friendsData;
      } else {
        print('Failed to fetch friends. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Get friends error: $e');
    }
    return null;
  }

  static Future<bool> deleteStatus() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/me/delete-status'),
        headers: await getHeaders(),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Delete status error: $e');
      return false;
    }
  }

  // ---------------- Friend Requests ----------------
  static Future<Map<String, dynamic>> sendFriendRequest(String username) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$username/send-request'),
        headers: await getHeaders(),
      );

      final data = jsonDecode(response.body);
      return data; // Map<String, dynamic> from backend
    } catch (e) {
      print('Send friend request error: $e');
      return {'message': 'Server error', 'status': 'error'};
    }
  }

  static Future<List<dynamic>?> getFriendRequests() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/me/friend-requests'),
        headers: await getHeaders(),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      print('Get friend requests error: $e');
    }
    return null;
  }

  static Future<bool> acceptFriendRequest(String requesterId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$requesterId/accept-request'),
        headers: await getHeaders(),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Accept friend request error: $e');
      return false;
    }
  }

  static Future<bool> rejectFriendRequest(String requesterId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$requesterId/reject-request'),
        headers: await getHeaders(),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Reject friend request error: $e');
      return false;
    }
  }

  // ---------------- Notifications ----------------
  // Fetch notifications from backend
  static Future<List<dynamic>?> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: await getHeaders(),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      print('Get notifications error: $e');
    }
    return null;
  }

  // Mark all notifications as read
  static Future<bool> markAllNotificationsRead() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notifications/mark-read'),
        headers: await getHeaders(),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Mark all notifications read error: $e');
      return false;
    }
  }

  // ---------------- Chats ----------------
  static Future<Map<String, dynamic>?> create1on1Chat(String friendId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chats/$friendId'),
        headers: await getHeaders(),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      print('Create 1-on-1 chat error: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> createGroupChat(
    String name,
    List<String> participantIds,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chats/group'),
        headers: await getHeaders(),
        body: jsonEncode({'name': name, 'participantIds': participantIds}),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      print('Create group chat error: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> addUserToGroup(
    String chatId,
    String userId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chats/$chatId/add-user'),
        headers: await getHeaders(),
        body: jsonEncode({'userId': userId}),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      print('Add user to group error: $e');
    }
    return null;
  }

  static Future<List<dynamic>?> getAllChats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chats'),
        headers: await getHeaders(),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      print('Get all chats error: $e');
    }
    return null;
  }

  static Future<bool> sendMessage(
    String chatId,
    String text, {
    String type = "text",
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chats/$chatId/messages'),
        headers: await getHeaders(),
        body: jsonEncode({'text': text, 'type': type}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Send message error: $e');
      return false;
    }
  }
}
