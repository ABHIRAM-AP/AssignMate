import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:assign_mate_app/widgets/search_bar.dart';
import 'package:assign_mate_app/widgets/util_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:assign_mate_app/models/assignment.dart';

class AssignmentsScreen extends StatefulWidget {
  final bool isRep;

  const AssignmentsScreen({super.key, required this.isRep});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  String? userName;
  late final TextEditingController assignmentController;
  late final TextEditingController dateController;
  final List<Assignment> assignments = [];

  @override
  void initState() {
    super.initState();
    fetchUserName();
    assignmentController = TextEditingController();
    dateController = TextEditingController();
  }

  Future<void> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        setState(() {
          userName = "Not Logged In";
        });
        return;
      }
      String extractedName = user.email!.split('@')[0];
      extractedName =
          extractedName[0].toUpperCase() + extractedName.substring(1);
      setState(() {
        userName = extractedName;
      });
    } catch (e) {
      setState(() {
        userName = "Error Occurred";
      });
    }
  }

  Future<void> uploadAssignmentToDatabase(String name, DateTime dueDate) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      await FirebaseFirestore.instance.collection("Assignment_Subjects").add({
        "Title": name,
        "Date": Timestamp.fromDate(dueDate),
        "repId": user.uid,
      });
    } catch (e) {
      print("Firestore error: $e");
    }
  }

  void _addassignment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF8B0000),
          title: Text(
            "Enter Assignment Details",
            style: GoogleFonts.orbitron(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFD54F),
            ),
          ),
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
                readOnly: true, // Prevents manual input
                decoration: InputDecoration(
                  labelText: "Pick Due Date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      dateController.text = formattedDate;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                    ),
                    backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
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
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                    ),
                    backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
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

  Widget _buildAssignmentData(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6.0),
      child: Card(
        color: const Color(0xFFFFF3E0),
        elevation: 8,
        child: ListTile(
          contentPadding: EdgeInsets.all(15),
          title: Text(
            data['Title'],
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "Due Date: ${DateFormat('d-EE-MMM').format(
              (data['Date'] as Timestamp).toDate(),
            )}",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 38),
              child: Align(
                alignment: Alignment.topLeft,
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    ColorizeAnimatedText(
                      "Welcome\n${userName ?? 'Loading...'}",
                      textStyle: GoogleFonts.orbitron(
                        fontSize: (userName != null && userName!.length >= 7)
                            ? 35
                            : 39,
                        fontWeight: FontWeight.bold,
                      ),
                      colors: [
                        Color(0xFFB71C1C), // Iron Man Red
                        Color(0xFFFFD600), // Gold
                        Color(0xFF263238), // Dark Charcoal
                        Color(0xFF00E5FF), // Arc Reactor Blue
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Assignment_Subjects')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No Assignments Available",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data();
                      return widget.isRep
                          ? Dismissible(
                              onDismissed: (direction) async {
                                await FirebaseFirestore.instance
                                    .collection('Assignment_Subjects')
                                    .doc(doc.id)
                                    .delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Assignment Deleted",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              key: Key(doc.id),
                              child: _buildAssignmentData(data))
                          : _buildAssignmentData(data);
                    },
                  );
                },
              ),
            ),
            if (widget.isRep)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, bottom: 20),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      _addassignment();
                    },
                    child: Icon(Icons.add, size: 30, color: Colors.black),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: UtilTab(isRep: widget.isRep),
        ),
      ),
    );
  }
}
