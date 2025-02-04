import 'package:assign_mate_app/widgets/photo_button.dart';
import 'package:assign_mate_app/widgets/search_bar.dart';
import 'package:assign_mate_app/widgets/util_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Assignment {
  final String name;
  final DateTime dueDate;
  Assignment(this.name, this.dueDate);
}

class AssignmentsScreen extends StatefulWidget {
  final String? userName;
  final bool isRep;

  const AssignmentsScreen(
      {super.key, required this.isRep, required this.userName});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  final List<Assignment> assignments = []; // List to hold assignments

  final TextEditingController assignmentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Future<void> uploadAssignmentToDatabase(String name, DateTime dueDate) async {
    try {
      DocumentReference assignmentRef = await FirebaseFirestore.instance
          .collection("Assignment_Subjects")
          .add({
        "Title": name,
        "Date": Timestamp.fromDate(dueDate),
      });

      print("Successfully uploaded: ${assignmentRef.id}");
    } catch (e) {
      print("Firestore error: $e");
    }
  }

  void _addassignment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Assignment Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: TextField(
                  controller: assignmentController,
                  decoration: InputDecoration(labelText: "Enter Assignment"),
                ),
              ),
              TextField(
                controller: dateController,
                decoration:
                    InputDecoration(labelText: "Enter Date (YYYY-MM-DD)"),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    String name = assignmentController.text.trim();
                    String dateString = dateController.text.trim();

                    if (name.isNotEmpty && dateString.isNotEmpty) {
                      try {
                        DateTime dueDate = DateTime.parse(dateString);

                        await uploadAssignmentToDatabase(name, dueDate);

                        setState(() {
                          assignments.add(Assignment(name, dueDate));
                        });

                        Navigator.of(context).pop();
                        assignmentController.clear();
                        dateController.clear();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Invalid date format. Use YYYY-MM-DD.")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill in all fields")),
                      );
                    }
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

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
                    "Welcome\n${widget.userName}!!",
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
                  child: PhotoButton(),
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
                child:
                    SearchBarAssignments(), // Textfield for searching assignments
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 6.0),
                    child: Card(
                      elevation: 8,
                      child: ListTile(
                        title: Text(assignments[index].name),
                        subtitle: Text(DateFormat('d, EEEE, MMMM')
                            .format(assignments[index].dueDate)),
                        trailing: Icon(Icons.arrow_forward, size: 28),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.isRep) ...[
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, top: 10),
                  child: IconButton(
                    style: ButtonStyle(
                      iconColor: WidgetStatePropertyAll(Colors.black),
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: _addassignment, // Show dialog when pressed
                    icon: Icon(Icons.add, size: 30),
                  ),
                ),
              ),
            ],
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: UtilTab(), // Home, Bookmark, Logout Tab
            ),
          ],
        ),
      ),
    );
  }
}
