import 'package:assign_mate_app/screens/assignments_screen.dart';
import 'package:assign_mate_app/screens/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      // Attempt to log in
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Successfully logged in
        // print('User logged in: ${userCredential.user!.email}');

        // Get the user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          // Document exists, now fetch the role
          String userRole = userDoc['role'];
          // print('User role from Firestore: $userRole');
          List<String> emailParts = emailidController.text.split("@");
          String name = emailParts[0];
          name = name[0].toUpperCase() + name.substring(1);
          // Compare the fetched role with the selected role

          if (userRole == 'rep') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AssignmentsScreen(
                  isRep: true,
                  userName: name,
                ),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AssignmentsScreen(
                  isRep: false,
                  userName: name,
                ),
              ),
            );
          }
        } else {
          print('User document not found in Firestore');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User document not found in Firestore")),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Firebase authentication error
      // print('FirebaseAuthException: ${e.code}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed. Please try again.")),
      );
    } catch (e) {
      // General error
      // print('Error: $e');
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
                TextField(
                  controller: emailidController,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Etlab ID:',
                  ),
                ),

                const SizedBox(height: 20),

                // Password TextField
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                  ),
                ),
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
