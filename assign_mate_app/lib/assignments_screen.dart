import 'package:flutter/material.dart';

class AssignmentsScreen extends StatelessWidget {
  final bool isClassRep;
  const AssignmentsScreen({super.key, required this.isClassRep});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignments"),
        actions: isClassRep
            ? [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ]
            : null,
      ),
    );
  }
}
