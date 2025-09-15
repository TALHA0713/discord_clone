// import 'package:flutter/material.dart';
// import '../home/home_screen.dart';
// import 'login_screen.dart';

// class CreateAccountScreen extends StatefulWidget {
//   final String? prefilledEmail;
//   final String? prefilledPhone;
//   const CreateAccountScreen({
//     super.key,
//     this.prefilledEmail,
//     this.prefilledPhone,
//   });

//   @override
//   State<CreateAccountScreen> createState() => _CreateAccountScreenState();
// }

// class _CreateAccountScreenState extends State<CreateAccountScreen> {
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _displayNameController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();

//   String? selectedMonth;
//   String? selectedDay;
//   String? selectedYear;

//   bool emailExists = false;
//   bool phoneExists = false;

//   final List<String> months = [
//     "January",
//     "February",
//     "March",
//     "April",
//     "May",
//     "June",
//     "July",
//     "August",
//     "September",
//     "October",
//     "November",
//     "December",
//   ];
//   final List<String> days = List.generate(31, (i) => "${i + 1}");
//   final List<String> years = List.generate(50, (i) => "${1970 + i}");

//   final List<String> dummyEmails = ["phibi@discordapp.com", "test@example.com"];
//   final List<String> dummyPhones = ["1234567890", "9876543210"];

//   @override
//   void initState() {
//     super.initState();

//     if (widget.prefilledEmail != null) {
//       _emailController.text = widget.prefilledEmail!;
//       if (dummyEmails.contains(widget.prefilledEmail!.trim())) {
//         emailExists = true;
//       }
//     }

//     if (widget.prefilledPhone != null) {
//       _phoneController.text = widget.prefilledPhone!;
//       if (dummyPhones.contains(widget.prefilledPhone!.trim())) {
//         phoneExists = true;
//       }
//     }
//   }

//   void _continue() {
//     final email = _emailController.text.trim();
//     final phone = _phoneController.text.trim();

//     if (email.isNotEmpty && dummyEmails.contains(email)) {
//       setState(() => emailExists = true);
//       return;
//     }
//     if (phone.isNotEmpty && dummyPhones.contains(phone)) {
//       setState(() => phoneExists = true);
//       return;
//     }

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const HomeScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: const Color(0xFF2B2D31),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.only(
//               left: 24,
//               right: 24,
//               top: 24,
//               bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//             ),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1E1F22),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   const Center(
//                     child: Text(
//                       "Create an account",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // ---- Conditionally render email OR phone ----
//                   if (widget.prefilledPhone != null) ...[
//                     Text(
//                       phoneExists ? "PHONE - Already registered" : "PHONE",
//                       style: TextStyle(
//                         color: phoneExists ? Colors.red : Colors.white70,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     TextField(
//                       controller: _phoneController,
//                       style: const TextStyle(color: Colors.white),
//                       keyboardType: TextInputType.phone,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: const Color(0xFF2B2D31),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(
//                             color: phoneExists
//                                 ? Colors.red
//                                 : Colors.transparent,
//                           ),
//                         ),
//                       ),
//                       onChanged: (_) {
//                         setState(() => phoneExists = false);
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                   ] else ...[
//                     Text(
//                       emailExists ? "EMAIL - Already registered" : "EMAIL",
//                       style: TextStyle(
//                         color: emailExists ? Colors.red : Colors.white70,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     TextField(
//                       controller: _emailController,
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: const Color(0xFF2B2D31),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(
//                             color: emailExists
//                                 ? Colors.red
//                                 : Colors.transparent,
//                           ),
//                         ),
//                       ),
//                       onChanged: (_) {
//                         setState(() => emailExists = false);
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                   ],

//                   // Display Name
//                   const Text(
//                     "DISPLAY NAME",
//                     style: TextStyle(color: Colors.white70, fontSize: 12),
//                   ),
//                   const SizedBox(height: 6),
//                   TextField(
//                     controller: _displayNameController,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color(0xFF2B2D31),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Username
//                   const Text(
//                     "USERNAME *",
//                     style: TextStyle(color: Colors.white70, fontSize: 12),
//                   ),
//                   const SizedBox(height: 6),
//                   TextField(
//                     controller: _usernameController,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color(0xFF2B2D31),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Password
//                   const Text(
//                     "PASSWORD *",
//                     style: TextStyle(color: Colors.white70, fontSize: 12),
//                   ),
//                   const SizedBox(height: 6),
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color(0xFF2B2D31),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Date of Birth
//                   // const Text(
//                   //   "DATE OF BIRTH *",
//                   //   style: TextStyle(color: Colors.white70, fontSize: 12),
//                   // ),
//                   // const SizedBox(height: 6),
//                   // Row(
//                   //   children: [
//                   //     SizedBox(
//                   //       width: 100, // width of month dropdown
//                   //       child: DropdownButtonFormField<String>(
//                   //         value: selectedMonth,
//                   //         dropdownColor: const Color(0xFF2B2D31),
//                   //         decoration: const InputDecoration(
//                   //           isDense: true,
//                   //           contentPadding: EdgeInsets.symmetric(
//                   //             horizontal: 8,
//                   //             vertical: 12,
//                   //           ),
//                   //           filled: true,
//                   //           fillColor: Color(0xFF2B2D31),
//                   //           border: OutlineInputBorder(),
//                   //         ),
//                   //         hint: const Text(
//                   //           "Month",
//                   //           style: TextStyle(color: Colors.white54),
//                   //         ),
//                   //         items: months
//                   //             .map(
//                   //               (m) => DropdownMenuItem(
//                   //                 value: m,
//                   //                 child: Text(
//                   //                   m,
//                   //                   style: const TextStyle(color: Colors.white),
//                   //                 ),
//                   //               ),
//                   //             )
//                   //             .toList(),
//                   //         onChanged: (val) =>
//                   //             setState(() => selectedMonth = val),
//                   //       ),
//                   //     ),
//                   //     const SizedBox(width: 8),
//                   //     SizedBox(
//                   //       width: 60, // width of day dropdown
//                   //       child: DropdownButtonFormField<String>(
//                   //         value: selectedDay,
//                   //         dropdownColor: const Color(0xFF2B2D31),
//                   //         decoration: const InputDecoration(
//                   //           isDense: true,
//                   //           contentPadding: EdgeInsets.symmetric(
//                   //             horizontal: 8,
//                   //             vertical: 12,
//                   //           ),
//                   //           filled: true,
//                   //           fillColor: Color(0xFF2B2D31),
//                   //           border: OutlineInputBorder(),
//                   //         ),
//                   //         hint: const Text(
//                   //           "Day",
//                   //           style: TextStyle(color: Colors.white54),
//                   //         ),
//                   //         items: days
//                   //             .map(
//                   //               (d) => DropdownMenuItem(
//                   //                 value: d,
//                   //                 child: Text(
//                   //                   d,
//                   //                   style: const TextStyle(color: Colors.white),
//                   //                 ),
//                   //               ),
//                   //             )
//                   //             .toList(),
//                   //         onChanged: (val) => setState(() => selectedDay = val),
//                   //       ),
//                   //     ),
//                   //     const SizedBox(width: 8),
//                   //     SizedBox(
//                   //       width: 80, // width of year dropdown
//                   //       child: DropdownButtonFormField<String>(
//                   //         value: selectedYear,
//                   //         dropdownColor: const Color(0xFF2B2D31),
//                   //         decoration: const InputDecoration(
//                   //           isDense: true,
//                   //           contentPadding: EdgeInsets.symmetric(
//                   //             horizontal: 8,
//                   //             vertical: 12,
//                   //           ),
//                   //           filled: true,
//                   //           fillColor: Color(0xFF2B2D31),
//                   //           border: OutlineInputBorder(),
//                   //         ),
//                   //         hint: const Text(
//                   //           "Year",
//                   //           style: TextStyle(color: Colors.white54),
//                   //         ),
//                   //         items: years
//                   //             .map(
//                   //               (y) => DropdownMenuItem(
//                   //                 value: y,
//                   //                 child: Text(
//                   //                   y,
//                   //                   style: const TextStyle(color: Colors.white),
//                   //                 ),
//                   //               ),
//                   //             )
//                   //             .toList(),
//                   //         onChanged: (val) =>
//                   //             setState(() => selectedYear = val),
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                   const SizedBox(height: 24),

//                   // Continue Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _continue,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF5865F2),
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                       ),
//                       child: const Text("Continue"),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Links
//                   const Text(
//                     "By registering, you agree to the service's Terms of Service and Privacy Policy.",
//                     style: TextStyle(color: Colors.white54, fontSize: 12),
//                   ),
//                   const SizedBox(height: 12),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (_) => const LoginScreen()),
//                       );
//                     },
//                     child: const Text(
//                       "Already have an account?",
//                       style: TextStyle(
//                         color: Color(0xFF5865F2),
//                         fontSize: 14,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../../services/api_service.dart';

class CreateAccountScreen extends StatefulWidget {
  final String? prefilledEmail;
  final String? prefilledPhone;

  const CreateAccountScreen({
    super.key,
    this.prefilledEmail,
    this.prefilledPhone,
  });

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool emailExists = false;
  bool phoneExists = false;
  bool _loading = false;

  final List<String> dummyEmails = ["phibi@discordapp.com", "test@example.com"];
  final List<String> dummyPhones = ["1234567890", "9876543210"];

  @override
  void initState() {
    super.initState();

    // Pre-fill values if coming from RegisterScreen
    if (widget.prefilledEmail != null) {
      _emailController.text = widget.prefilledEmail!;
      if (dummyEmails.contains(widget.prefilledEmail!.trim())) {
        emailExists = true;
      }
    }

    if (widget.prefilledPhone != null) {
      _phoneController.text = widget.prefilledPhone!;
      if (dummyPhones.contains(widget.prefilledPhone!.trim())) {
        phoneExists = true;
      }
    }
  }

  Future<void> _registerUser() async {
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Basic validation
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final emailOrPhone = email.isNotEmpty ? email : phone;

    setState(() => _loading = true);

    final success = await ApiService.register(username, emailOrPhone, password);

    setState(() => _loading = false);

    if (!mounted) return;

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully! Please log in."),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to LoginScreen after short delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to create account. Please try again."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF2B2D31),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1F22),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Center(
                    child: Text(
                      "Create an account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ---- Conditionally render email OR phone ----
                  if (widget.prefilledPhone != null) ...[
                    Text(
                      phoneExists ? "PHONE - Already registered" : "PHONE",
                      style: TextStyle(
                        color: phoneExists ? Colors.red : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _phoneController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF2B2D31),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: phoneExists
                                ? Colors.red
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      onChanged: (_) {
                        setState(() => phoneExists = false);
                      },
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    Text(
                      emailExists ? "EMAIL - Already registered" : "EMAIL",
                      style: TextStyle(
                        color: emailExists ? Colors.red : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF2B2D31),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: emailExists
                                ? Colors.red
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      onChanged: (_) {
                        setState(() => emailExists = false);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Display Name
                  const Text(
                    "DISPLAY NAME",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _displayNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2B2D31),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Username
                  const Text(
                    "USERNAME *",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2B2D31),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  const Text(
                    "PASSWORD *",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2B2D31),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5865F2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Continue"),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Links
                  const Text(
                    "By registering, you agree to the service's Terms of Service and Privacy Policy.",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Color(0xFF5865F2),
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
