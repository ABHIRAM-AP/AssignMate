import 'package:assignmate/screens/assignments_screen.dart';
import 'package:assignmate/services/firebase_auth_services.dart';
import 'package:assignmate/widgets/app_title.dart';
import 'package:assignmate/widgets/email_id_textfield.dart';
import 'package:assignmate/widgets/login_button.dart';
import 'package:assignmate/widgets/password_textfield.dart';
import 'package:assignmate/widgets/sign_up_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      _authService.saveUserToken();
      if (userCredential.user == null) {
        showSnackBar("Login failed. Please try again.");
        return;
      }

      String? role = await _authService.getUserRole(userCredential.user!.uid);

      if (role == 'rep' || role == 'student') {
        bool isRep = role == 'rep';

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isRep', isRep);
        if (!mounted) return;

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
                    const AppTitle(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0)
                          .copyWith(bottom: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Email Field
                          EmailIdTextfield(
                              emailidController: emailidController),
                          const SizedBox(height: 20),

                          // Password Field
                          PasswordTextfield(
                              passwordController: passwordController),
                          const SizedBox(height: 30),

                          // Login Button
                          LoginButton(
                              isLoading: _isLoading, onPressed: loginUser),
                          const SizedBox(height: 15),

                          // Sign Up Button
                          const SignUpButton(),
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
