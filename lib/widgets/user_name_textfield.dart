import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserNameTextfield extends StatefulWidget {
  final TextEditingController userNameController;
  const UserNameTextfield({super.key, required this.userNameController});

  @override
  State<UserNameTextfield> createState() => _UserNameTextfieldState();
}

class _UserNameTextfieldState extends State<UserNameTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.userNameController,
      decoration: InputDecoration(
        hintText: "Enter your Name:",
        hintStyle: GoogleFonts.itim(
          fontSize: 19,
        ),
      ),
    );
  }
}
