import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RepIdTextfield extends StatefulWidget {
  final TextEditingController repidController;
  const RepIdTextfield({
    super.key,
    required this.repidController,
  });

  @override
  State<RepIdTextfield> createState() => _RepIdTextfieldState();
}

class _RepIdTextfieldState extends State<RepIdTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.repidController,
      decoration: InputDecoration(
        hintText: 'Enter Your Rep ID:',
        hintStyle: GoogleFonts.itim(
          fontSize: 19,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
