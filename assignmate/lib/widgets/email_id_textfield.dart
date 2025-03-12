import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailIdTextfield extends StatefulWidget {
  final TextEditingController emailidController;
  const EmailIdTextfield({super.key, required this.emailidController});

  @override
  State<EmailIdTextfield> createState() => _EmailIdTextfieldState();
}

class _EmailIdTextfieldState extends State<EmailIdTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.emailidController,
      decoration: InputDecoration(
        hintText: 'Enter Your Email:',
        hintStyle: GoogleFonts.itim(
          fontSize: 19,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
