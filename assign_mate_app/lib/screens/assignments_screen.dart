import 'package:assign_mate_app/widgets/photo_button.dart';
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
  String? userEmail;
  String? userName;
  late final TextEditingController assignmentController;
  late final TextEditingController dateController;
  final List<Assignment> assignments = []; // List to hold assignments

  @override
  void initState() {
    super.initState();
    fetchUserName();
    assignmentController = TextEditingController();
    dateController = TextEditingController();
  }

  // Function For Fetching UserName for Displaying Welcome Message //
  Future<void> fetchUserName() async {
    try {
      // Get the currently logged in user from FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        setState(() {
          userName = "Not Logged In";
        });
        return;
      }

      String email = user.email!;
      String extractedName = email.split('@')[0];

      extractedName = extractedName[0].toUpperCase() +
          extractedName.substring(1); // For Welcome ""

      setState(() {
        userName = extractedName;
      });

      print("Extracted user name: $userName");
    } catch (e) {
      print("Error extracting user name: $e");
      setState(() {
        userName = "Error Occurred";
      });
    }
  }

  // Function to Upload Assignment to FireStore //
  Future<void> uploadAssignmentToDatabase(String name, DateTime dueDate) async {
    try {
      User? user =
          FirebaseAuth.instance.currentUser; // Fetches the current User
      if (user == null) {
        print("User not logged in");
        return;
      }
      DocumentReference assignmentRef = await FirebaseFirestore.instance
          .collection("Assignment_Subjects")
          .add({
        "Title": name,
        "Date": Timestamp.fromDate(dueDate),
        "repId": user.uid,
      });

      print("Successfully uploaded: ${assignmentRef.id}");
    } catch (e) {
      print("Firestore error: $e");
    }
  }

  // Function to fetch the assignment details from the AlertDialog and return to FireStore
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Expanded(
                      child: Text(
                        "Welcome ${userName ?? 'Loading...'}",
                        style: GoogleFonts.roboto(
                          letterSpacing: 0,
                          fontSize: (userName != null && userName!.length >= 7)
                              ? 35
                              : 39,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                //   child: PhotoButton(),
                // ),
              ],
            ),
            const SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 30),
            //   child: Material(
            //     elevation: 8,
            //     shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
            //     borderRadius: BorderRadius.circular(24),
            //     child:
            //         // SearchBarAssignments(), // Textfield for searching assignments
            //   ),
            // ),

            // Displays The Assignments from FireStore
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Assignment_Subjects')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No Assignments Available"));
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data();

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 6.0),
                        child: Card(
                          elevation: 8,
                          child: ListTile(
                            title: Text(data['Title']),
                            subtitle: Text(data['Date'] != null
                                ? DateFormat('d, EEEE, MMMM').format(
                                    (data['Date'] as Timestamp).toDate())
                                : "No Date"),
                            trailing: widget.isRep
                                ? SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.arrow_forward, size: 28),
                                        SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () async {
                                            await FirebaseFirestore.instance
                                                .collection(
                                                    'Assignment_Subjects')
                                                .doc(doc.id)
                                                .delete();
                                          },
                                          child: Icon(Icons.delete,
                                              size: 28, color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  )
                                : Icon(Icons.arrow_forward, size: 28),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
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
                    onPressed: () {
                      setState(
                        () {
                          _addassignment();
                        },
                      );
                    },
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
