import 'package:assign_mate_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  List<String> subjects = [
    'Graph Theory',
    'COA',
    'OS',
    'Digital Lab',
  ];
  List<dynamic> subjectdueDate = [
    DateTime.utc(2025, 11, 9),
    DateTime.utc(2025, 11, 20),
    DateTime.utc(2025, 11, 30),
    DateTime.utc(2025, 11, 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
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
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Material(
                elevation: 8,
                shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
                borderRadius: BorderRadius.circular(24),
                child: SearchBarAssignments(), // Textfield
              ),
            ),
            // const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      color: Color.fromARGB(255, 209, 179, 232),
                      elevation: 8,
                      child: ListTile(
                        leading: Icon(
                          color: Colors.black,
                          Icons.flag_circle,
                          size: 35,
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            subjects[index],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0, top: 2),
                          child: Text(
                            DateFormat('d,EEEE,MMMM').format(
                              subjectdueDate[index],
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          size: 28,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
