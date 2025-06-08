import 'package:assignmate/screens/assignments_screen.dart';
import 'package:assignmate/screens/sign_up.dart';
import 'package:assignmate/services/firebase_auth_services.dart';
import 'package:assignmate/widgets/email_id_textfield.dart';
import 'package:assignmate/widgets/password_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    emailidController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Future<void> saveUserToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('User is ${user}\nToken:${fcmToken}');
    if (fcmToken != null) {
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(user?.uid)
          .update({
        'fcmToken': fcmToken,
      });
    }
  }

  Future<void> loginUser() async {
    String email = emailidController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnackBar("Email and password cannot be empty.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      saveUserToken();
      if (userCredential.user == null) {
        showSnackBar("Login failed. Please try again.");
        return;
      }

      String? role = await _authService.getUserRole(userCredential.user!.uid);

      if (role == 'rep' || role == 'student') {
        bool isRep = role == 'rep';

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isRep', isRep);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentsScreen(),
          ),
        );
      } else {
        showSnackBar("User document not found in Firestore.");
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message ?? "Login failed. Please try again.");
    } catch (e) {
      showSnackBar("Something went wrong. Please try again.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Log In",
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "AssignMate",
                      style: GoogleFonts.itim(
                        color: Color(0xFFBC6C25),
                        fontSize: 58,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0)
                          .copyWith(bottom: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          EmailIdTextfield(
                              emailidController: emailidController),
                          const SizedBox(height: 20),
                          PasswordTextfield(
                              passwordController: passwordController),
                          const SizedBox(height: 30),

                          // Login Button
                          SizedBox(
                            width: 264,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : loginUser,
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text(
                                      "Login",
                                      style: GoogleFonts.itim(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Navigation to Sign Up Page
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Don't have an account? Sign Up",
                                style: GoogleFonts.itim(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  color: const Color(0xFF283618),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
