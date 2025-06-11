import 'package:assignmate/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
