import 'package:assign_mate_app/screens/assignments_screen.dart';
import 'package:assign_mate_app/screens/internals_calc.dart';
import 'package:assign_mate_app/screens/login_screen_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UtilTab extends StatefulWidget {
  const UtilTab({super.key});

  @override
  State<UtilTab> createState() => _UtilTabState();
}

class _UtilTabState extends State<UtilTab> {
  String userRole = "student"; // Default role

  @override
  void initState() {
    super.initState();
    _getUserRole(); // Fetch user role when widget loads
  }

  Future<void> _getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userRole = userDoc['role'] ?? "student"; // Default to student
        });
      }
    }
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
        padding: const EdgeInsets.only(top: 18.0, bottom: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssignmentsScreen(
                          isRep: userRole == "rep",
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.home,
                    color: Color(0xFFFFD54F),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Home",
                  style: TextStyle(
                    color: Color(0xFFFFD54F),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InternalsCalc(),
                      ),
                    );
                  },
                  child: Icon(Icons.calculate, color: Color(0xFFFFD54F)),
                ),
                Text("Internal Calc",
                    style: TextStyle(color: Color(0xFFFFD54F))),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Icon(Icons.logout, color: Color(0xFFB71C1C)),
                ),
                Text("Log Out", style: TextStyle(color: Color(0xFFB71C1C))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
