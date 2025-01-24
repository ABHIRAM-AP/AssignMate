import 'package:assign_mate_app/assignments_screen.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreenNormal extends StatelessWidget {
  const LoginScreenNormal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AssignmentsScreen(isClassRep: false),
                  ),
                );
              },
              child: const Text('Login as Student'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AssignmentsScreen(isClassRep: true),
                  ),
                );
              },
              child: const Text('Login as Class Rep'),
            ),
          ],
        ),
      ),
    );
  }
}
