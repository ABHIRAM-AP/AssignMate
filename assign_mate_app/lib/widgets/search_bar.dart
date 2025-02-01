import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// TextField for Searching Assignments
class SearchBarAssignments extends StatelessWidget {
  const SearchBarAssignments({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 33),
        prefixIcon: Icon(
          Icons.search,
          size: 30,
        ),
        hintText: "Search Your Assignments",
        hintStyle: GoogleFonts.roboto(fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
