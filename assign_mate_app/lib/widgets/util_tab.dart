import 'package:assign_mate_app/screens/assignments_screen.dart';
import 'package:assign_mate_app/screens/internals_calc.dart';
import 'package:assign_mate_app/screens/login_screen_normal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UtilTab extends StatefulWidget {
  final bool isRep;

  const UtilTab({super.key, required this.isRep});

  @override
  State<UtilTab> createState() => _UtilTabState();
}

class _UtilTabState extends State<UtilTab> {
  Widget _buildUtilItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFBC6C25),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: const Color(0xFFBC6C25),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildUtilItem(
              icon: Icons.home,
              label: "Home",
              color: const Color(0xFFFAEDCD),
              onTap: () {
                print("Navigating to Home. isRep: ${widget.isRep}");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AssignmentsScreen(isRep: widget.isRep),
                  ),
                );
              },
            ),
            _buildUtilItem(
              icon: Icons.calculate,
              label: "Internals",
              color: const Color(0xFFFAEDCD),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InternalsCalc(isRep: widget.isRep),
                  ),
                );
              },
            ),
            _buildUtilItem(
              icon: Icons.logout,
              label: "Log Out",
              color: const Color(0xFFFAEDCD),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
