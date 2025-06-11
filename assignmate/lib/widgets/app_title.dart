import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "AssignMate",
      style: GoogleFonts.itim(
        color: const Color(0xFFBC6C25),
        fontSize: 58,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
