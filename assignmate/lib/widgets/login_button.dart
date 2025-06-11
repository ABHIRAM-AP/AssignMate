import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const LoginButton(
      {super.key, r, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 264,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // onPressed means loginUser()
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                "Login",
                style: GoogleFonts.itim(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
