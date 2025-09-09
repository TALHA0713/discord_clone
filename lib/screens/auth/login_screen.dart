// import 'package:flutter/material.dart';
// import '../home/home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   void _login() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const HomeScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF313338), // Background color
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             width: 420, // Discord fixed width style
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Title
//                 const Text(
//                   "Welcome back!",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 6),
//                 const Text(
//                   "We're so excited to see you again!",
//                   style: TextStyle(fontSize: 14, color: Colors.white70),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 28),

//                 // Email label
//                 const Text(
//                   "EMAIL OR PHONE NUMBER",
//                   style: TextStyle(
//                     color: Colors.white60,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 6),

//                 // Email field
//                 TextField(
//                   controller: _emailController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: const Color(0xFF1E1F22),
//                     hintText: "Email or Phone Number",
//                     hintStyle: const TextStyle(color: Colors.white38),
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: 14,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 6),

//                 // // Password label
//                 // const Text(
//                 //   "PASSWORD",
//                 //   style: TextStyle(
//                 //     color: Colors.white60,
//                 //     fontSize: 12,
//                 //     fontWeight: FontWeight.bold,
//                 //     letterSpacing: 0.5,
//                 //   ),
//                 // ),
//                 // const SizedBox(height: 6),

//                 // Password field
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: _obscurePassword,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: const Color(0xFF1E1F22),
//                     hintText: "Password",
//                     hintStyle: const TextStyle(color: Colors.white38),
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: 14,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide.none,
//                     ),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscurePassword
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                         color: Colors.white38,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscurePassword = !_obscurePassword;
//                         });
//                       },
//                     ),
//                   ),
//                 ),

//                 // const SizedBox(height: 8),

//                 // Forgot password
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: TextButton(
//                     onPressed: () {},
//                     style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                     child: const Text(
//                       "Forgot your password?",
//                       style: TextStyle(color: Color(0xFF5865F2), fontSize: 13),
//                     ),
//                   ),
//                 ),
//                 // const SizedBox(height: 8),

//                 // Login button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 48,
//                   child: ElevatedButton(
//                     onPressed: _login,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF5865F2),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                     child: const Text(
//                       "Log In",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // const SizedBox(height: 20),

//                 // // Bottom "Register"
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: [
//                 //     const Text(
//                 //       "Need an account?",
//                 //       style: TextStyle(color: Colors.white70),
//                 //     ),
//                 //     TextButton(
//                 //       onPressed: () {
//                 //         // TODO: Navigate to Register screen
//                 //       },
//                 //       child: const Text(
//                 //         "Register",
//                 //         style: TextStyle(
//                 //           color: Color(0xFF5865F2),
//                 //           fontWeight: FontWeight.bold,
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF313338),
      appBar: AppBar(
        backgroundColor: const Color(0xFF313338),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0, // removes default left padding
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(width: 8),
              Icon(Icons.arrow_back_ios, size: 16, color: Colors.white),
              SizedBox(width: 2),
              Text("Back", style: TextStyle(fontSize: 14, color: Colors.white)),
            ],
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 420,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const Text(
                  "Welcome back!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                const Text(
                  "We're so excited to see you again!",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // Email
                const Text(
                  "EMAIL OR PHONE NUMBER",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1E1F22),
                    hintText: "Email or Phone Number",
                    hintStyle: const TextStyle(color: Colors.white38),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1E1F22),
                    hintText: "Password",
                    hintStyle: const TextStyle(color: Colors.white38),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white38,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                // const SizedBox(height: 8),

                // Forgot password
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(color: Color(0xFF5865F2), fontSize: 13),
                    ),
                  ),
                ),
                // const SizedBox(height: 16),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5865F2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 16,
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
    );
  }
}
