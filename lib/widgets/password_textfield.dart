import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordTextfield extends StatefulWidget {
  final TextEditingController passwordController;
  const PasswordTextfield({super.key, required this.passwordController});

  @override
  State<PasswordTextfield> createState() => _PasswordTextfieldState();
}

class _PasswordTextfieldState extends State<PasswordTextfield> {
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.visiblePassword,
      controller: widget.passwordController,
      obscureText: _isObscured,
      decoration: InputDecoration(
        hintText: 'Enter Password',
        hintStyle: GoogleFonts.itim(
          fontSize: 19,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
          icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
        ),
      ),
    );
  }
}
