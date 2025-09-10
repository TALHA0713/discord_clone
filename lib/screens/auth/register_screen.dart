import 'package:flutter/material.dart';
import './create_account_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPhoneSelected = true; // Toggle state
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String selectedCountryCode = "+1"; // Default US
  bool isValid = false; // Track if input is valid

  // List of country codes (you can expand this or use a package like country_picker)
  final List<String> countryCodes = ["+1", "+44", "+91", "+92", "+61"];

  void _validateInput() {
    if (isPhoneSelected) {
      final phone = _phoneController.text.trim();
      setState(() {
        // simple validation: 7-15 digits
        isValid = RegExp(r'^[0-9]{7,15}$').hasMatch(phone);
      });
    } else {
      final email = _emailController.text.trim();
      setState(() {
        // simple email regex
        isValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
      });
    }
  }

  void _nextStep() {
    if (!isValid) return;

    final inputValue = isPhoneSelected
        ? _phoneController.text.trim()
        : _emailController.text.trim();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAccountScreen(
          prefilledEmail: isPhoneSelected ? null : inputValue,
          prefilledPhone: isPhoneSelected ? inputValue : null,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateInput);
    _emailController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F22),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(height: 40),

              // Title
              const Center(
                child: Text(
                  "Enter phone or email",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Toggle Phone/Email
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2D31),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          isPhoneSelected = true;
                          _validateInput();
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isPhoneSelected
                                ? const Color(0xFF313338)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              "Phone",
                              style: TextStyle(
                                color: isPhoneSelected
                                    ? Colors.white
                                    : Colors.white54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          isPhoneSelected = false;
                          _validateInput();
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isPhoneSelected
                                ? const Color(0xFF313338)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              "Email",
                              style: TextStyle(
                                color: !isPhoneSelected
                                    ? Colors.white
                                    : Colors.white54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Phone or Email field
              if (isPhoneSelected) ...[
                const Text(
                  "Phone Number",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Dropdown for country code
                    DropdownButton<String>(
                      dropdownColor: const Color(0xFF2B2D31),
                      value: selectedCountryCode,
                      style: const TextStyle(color: Colors.white),
                      underline: const SizedBox(),
                      items: countryCodes
                          .map(
                            (code) => DropdownMenuItem(
                              value: code,
                              child: Text(
                                code,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCountryCode = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Enter phone number",
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF2B2D31),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const Text(
                  "Email",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter email address",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF2B2D31),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Privacy Policy
              // Privacy Policy
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse("https://discord.com/privacy");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: const Text(
                  "View our Privacy Policy",
                  style: TextStyle(color: Color(0xFF5865F2)),
                ),
              ),

              const Spacer(),

              // Next button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isValid
                        ? const Color(0xFF5865F2)
                        : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: isValid ? _nextStep : null, // disable if not valid
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
