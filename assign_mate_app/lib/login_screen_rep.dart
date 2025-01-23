import 'package:assign_mate_app/login_screen_normal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreenRep extends StatelessWidget {
  const LoginScreenRep({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Etlab ID TextField
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter Your Etlab ID:',
                ),
              ),
              const SizedBox(height: 20),

              // Password TextField
              TextField(
                obscureText: true, // Hides password input
                decoration: const InputDecoration(
                  hintText: 'Enter Password',
                ),
              ),
              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: double.infinity, // Matches the width of the parent
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Not A Student? I'm A Rep Link
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreenNormal(),
                    ),
                  );
                },
                child: const Text("Not A Rep? I'm A Student"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
