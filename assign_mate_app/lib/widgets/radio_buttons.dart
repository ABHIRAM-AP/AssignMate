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
    bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 200),
            tween: Tween<double>(begin: 1.0, end: isSelected ? 1.2 : 1.0),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Transform.rotate(
                  angle: 0.0, // 45 degrees for diamond shape
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4),
                      border:
                          Border.all(color: const Color(0xFF5A4FCF), width: 2),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: const Color(0xFF5A4FCF), blurRadius: 8)
                            ]
                          : [],
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(2),
                                color: const Color(0xFF5A4FCF),
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
