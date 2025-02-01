import 'package:flutter/material.dart';

class Assignment {
  final String name;
  final DateTime dueDate;
  Assignment(this.name, this.dueDate);
}

class Addassignment extends StatefulWidget {
  const Addassignment({super.key});

  @override
  State<Addassignment> createState() => _AddassignmentState();
}

class _AddassignmentState extends State<Addassignment> {
  final List<Assignment> assignments = []; // List to hold assignments
  final TextEditingController assignmentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  void addassignment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Assignment Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: assignmentController,
                decoration: InputDecoration(labelText: "Enter Assignment"),
              ),
              TextField(
                controller: dateController,
                decoration:
                    InputDecoration(labelText: "Enter Date (YYYY-MM-DD)"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String name = assignmentController.text;
                String dateString = dateController.text;

                if (name.isNotEmpty && dateString.isNotEmpty) {
                  DateTime? dueDate = DateTime.tryParse(dateString);
                  if (dueDate != null) {
                    setState(() {
                      assignments.add(Assignment(name, dueDate));
                    });
                    Navigator.of(context).pop();
                    assignmentController.clear();
                    dateController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Invalid date format")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill in all fields")),
                  );
                }
              },
              child: Text("Submit"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
