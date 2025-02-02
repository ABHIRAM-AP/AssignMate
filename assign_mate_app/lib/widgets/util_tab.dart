import 'package:assign_mate_app/screens/login_screen_normal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UtilTab extends StatelessWidget {
  const UtilTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 18.0, bottom: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home),
            Icon(Icons.bookmark_border),
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut(); // Logs out the user
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
