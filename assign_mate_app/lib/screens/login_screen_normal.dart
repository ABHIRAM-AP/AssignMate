import 'package:assign_mate_app/screens/assignments_screen.dart';
import 'package:assign_mate_app/screens/sign_up.dart';
import 'package:assign_mate_app/widgets/email_id_textfield.dart';
import 'package:assign_mate_app/widgets/password_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailidController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailidController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Future<void> loginStudent() async {
  //   String email = emailidController.text.trim();
  //   String password = passwordController.text.trim();
  //   if (email.isEmpty || password.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please enter both email and password")),
  //     );
  //     return;
  //   }
  //   try {
  //     final studentCredentials =
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     if (studentCredentials.user != null) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const AssignmentsScreen(isRep: false),
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Login failed. Please try again.")),
  //       );
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.message ?? "Login failed. Please try again.")),
  //     );
  //   }
  // }

//Login Function
  Future<void> loginUser() async {
    String email = emailidController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both email and password")),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed. Please try again.")),
        );
        return;
      }

      DocumentSnapshot repDoc = await FirebaseFirestore.instance
          .collection('Class_Rep')
          .doc(userCredential.user!.uid)
          .get();

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Students')
          .doc(userCredential.user!.uid)
          .get();

      String? name;
      if (email.contains("@")) {
        List<String> emailParts = email.split("@");
        name = emailParts[0];
        name = name[0].toUpperCase() + name.substring(1);
      }

      if (repDoc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentsScreen(isRep: true),
          ),
        );
      } else if (userDoc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentsScreen(isRep: false),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User document not found in Firestore")),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed. Please try again.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Sign In"),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        centerTitle: true, // Center the title in AppBar
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Email TextField
                EmailIdButton(emailidController: emailidController),
                const SizedBox(height: 20),

                // Password TextField
                PasswordTextfield(passwordController: passwordController),
                const SizedBox(height: 30),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () async {
                      await loginUser();
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
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
