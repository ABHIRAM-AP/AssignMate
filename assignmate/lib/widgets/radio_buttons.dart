import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RadioOptionWidget extends StatelessWidget {
  final String text;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const RadioOptionWidget({
    super.key,
    required this.text,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: const Color(0xFFCCD5AE),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFCCD5AE), width: 2),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFD4A373),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: const Color(0xFF606C38),
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}
