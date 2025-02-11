import 'package:assign_mate_app/screens/login_screen_normal.dart';
import 'package:assign_mate_app/widgets/email_id_textfield.dart';
import 'package:assign_mate_app/widgets/password_textfield.dart';
import 'package:assign_mate_app/widgets/rep_id_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? _role = 'student';

  void _handleRadioValueChange(String? value) {
    setState(() {
      _role = value;
    });
  }

  @override
  void dispose() {
    emailidController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final TextEditingController emailidController = TextEditingController();
  final TextEditingController repidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

// Function For New User
  // Future<void> createStudent() async {
  //   try {
  //     final studentCredentials =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: emailidController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );
  //     debugPrint("$studentCredentials");
  //   } on FirebaseAuthException catch (e) {
  //     print(e.toString());
  //   }
  // }

  //Function For NEW USER
  Future<void> signUpUser(String role) async {
    String email = emailidController.text.trim();
    String repId = repidController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both email and password")),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        String collection = role == "rep" ? 'Class_Rep' : 'Students';

        await FirebaseFirestore.instance
            .collection(collection)
            .doc(userCredential.user!.uid)
            .set({
          "email": email,
          "password": password,
          "repId": repId,
          "role": role, // Fixed _role issue
        });
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.message ?? "Sign up failed. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Sign Up"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Etlab ID TextField
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                  child: EmailIdButton(emailidController: emailidController),
                ),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                    child: _role == 'rep'
                        ? RepIdTextfield(repidController: repidController)
                        : Container()),
                const SizedBox(height: 20),

                // Password TextField
                PasswordTextfield(passwordController: passwordController),
                const SizedBox(height: 20),

                //Radio Buttons
                // Student Button
                Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: 'student',
                          groupValue: _role,
                          onChanged: _handleRadioValueChange,
                          activeColor: Colors.red,
                        ),
                        Text(
                          "Student",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 100), // Adds a gap between the two Button
                    // Rep Button
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: 'rep',
                          groupValue: _role,
                          onChanged: _handleRadioValueChange,
                          activeColor: Colors.red,
                        ),
                        Text(
                          "Rep",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
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
                        await signUpUser(_role!); // Creates New User
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
