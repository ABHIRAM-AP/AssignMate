import 'package:assign_mate_app/screens/login_screen_normal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    emailidController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> createStudent() async {
    try {
      final studentCredentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailidController.text.trim(),
        password: passwordController.text.trim(),
      );
      debugPrint("$studentCredentials");
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // "Sign In" text at the top-left
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 20),
              child: Text(
                "Sign Up",
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Centered Login Form
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Etlab ID TextField
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                    child: TextField(
                      controller: emailidController,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Etlab ID:',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password TextField
                  TextField(
                    controller: passwordController,
                    obscureText: true, // Hides password input
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity, // Matches the width of the parent
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () async {
                        try {
                          await createStudent();
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to create student: $e')),
                          );
                        }
                      },
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
