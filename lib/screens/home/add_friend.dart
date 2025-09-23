import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String? _responseMessage; // Message from backend
  bool _isSuccess = false; // True if success, false if error
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF36393F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F3136),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Friend',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration
                    Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBMupg1dtbSfcY1feKz_iJNjpCc1s9zdsFetjyGJsRdgzHa2W5QB_CvBpqwP2hoiRDAuGiqapzH_fUVmmk8M8I_Va4WdG4Ov-lJEC1e6zQ5sYoUp5RBjUA_Z10m165g4t_BrNgfWx9He3I3unLdZo3_lIkg32mPam17ZgrHB8Ku_nn_uI7ti5-IFgPzeAkUMIxbu6-bOT5-Nhn9U4Z6pY_dMayjvAgXUs7MJf1_w1bLn_cZl4ViyojjGadThlrJ7mnNwNSSb_TPmxRv',
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'Add your friend on Discord',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      'You will need both their username and a tag. Keep in mind that username is case sensitive.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFB9BBBE), fontSize: 14),
                    ),
                    const SizedBox(height: 24),

                    // Username Input Field
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username and Tag',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF202225),
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.indigo,
                            width: 2,
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),

                    // Response message from backend
                    if (_responseMessage != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _responseMessage!,
                          style: TextStyle(
                            color: _isSuccess ? Colors.green : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    if (_responseMessage != null) const SizedBox(height: 24),

                    // Send Friend Request Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                final username = _usernameController.text
                                    .trim();
                                if (username.isEmpty) return;

                                setState(() {
                                  _isLoading = true;
                                  _responseMessage = null;
                                });

                                final result =
                                    await ApiService.sendFriendRequest(
                                      username,
                                    );

                                setState(() {
                                  _isLoading = false;
                                  _responseMessage =
                                      result['message'] ?? 'Error';
                                  // Success if status key is not error
                                  _isSuccess =
                                      !(result['status'] != null &&
                                          result['status'] == 'error');
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Send Friend Request',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
