import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssignmentSubjects extends StatefulWidget {
  const AssignmentSubjects({super.key});

  @override
  State<AssignmentSubjects> createState() => _AssignmentSubjectsState();
}

class _AssignmentSubjectsState extends State<AssignmentSubjects> {
  List<String> subjects = [
    'Graph Theory',
    'COA',
    'OS',
    'Digital Lab',
  ];

  List<DateTime> subjectDueDate = [
    DateTime.utc(2025, 11, 9),
    DateTime.utc(2025, 11, 20),
    DateTime.utc(2025, 11, 30),
    DateTime.utc(2025, 11, 10),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6.0),
          child: Card(
            margin: EdgeInsets.zero,
            color: Color.fromARGB(255, 241, 229, 249),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 2),
                child: Text(
                  DateFormat('d MMMM yyyy').format(subjectDueDate[index]),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              trailing: Icon(Icons.arrow_forward, size: 28),
            ),
          ),
        );
      },
    );
  }
}
