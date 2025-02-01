import 'package:assign_mate_app/widgets/assignment_subjects.dart';
import 'package:assign_mate_app/widgets/search_bar.dart';
import 'package:assign_mate_app/widgets/util_tab.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AssignmentsScreen extends StatefulWidget {
  final bool isRep;
  const AssignmentsScreen({super.key, required this.isRep});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    "Welcome\nUser!!",
                    style: GoogleFonts.roboto(
                        letterSpacing: 0,
                        fontSize: 39,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: IconButton(
                    onPressed: () {},
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Icon(
                        Icons.photo,
                        size: 43,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Material(
                elevation: 8,
                shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
                borderRadius: BorderRadius.circular(24),
                child: SearchBarAssignments(), // Textfield
              ),
            ),
            Expanded(
              child: AssignmentSubjects(),
            ),
            if (widget.isRep) ...[
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        style: ButtonStyle(
                          elevation: WidgetStatePropertyAll(8),
                          backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 241, 229, 249),
                          ),
                        ),
                        onPressed: () {
                          // Action for adding an assignment
                        },
                        icon: Icon(Icons.add, size: 30), // Add Button Icon
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: UtilTab(), // Home, Bookmark, Settings Tab
            ),
          ],
        ),
      ),
    );
  }
}
