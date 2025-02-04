import 'package:flutter/material.dart';

class EmailIdButton extends StatefulWidget {
  final TextEditingController emailidController;
  const EmailIdButton({super.key, required this.emailidController});

  @override
  State<EmailIdButton> createState() => _EmailIdButtonState();
}

class _EmailIdButtonState extends State<EmailIdButton> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.emailidController,
      decoration: InputDecoration(
        hintText: 'Enter Your Etlab ID:',
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
