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
          borderRadius: BorderRadius.circular(12),
          child: IconButton(
            icon: Icon(icon),
            color: color,
            onPressed: onTap,
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -8),
          child: Text(
            label,
            style: GoogleFonts.poppins(color: color, fontSize: 14),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2F2F2F),
      elevation: 4,
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
              color: const Color(0xFFFFD54F),
              onTap: () {
                print(
                    "Navigating to Home. isRep: ${widget.isRep}"); // Debugging log
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
              label: "Internal Calc",
              color: const Color(0xFFFFD54F),
              onTap: () {
                print("Navigating to InternalsCalc. isRep: ${widget.isRep}");
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
              color: const Color(0xFFB71C1C),
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
