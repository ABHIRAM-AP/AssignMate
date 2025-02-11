import 'package:flutter/material.dart';

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
      ),
      keyboardType: TextInputType.number,
    );
  }
}
