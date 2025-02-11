import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RadioOptionWidget extends StatelessWidget {
  final String text;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const RadioOptionWidget({
    Key? key,
    required this.text,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: Colors.red,
        ),
        Text(
          text,
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
