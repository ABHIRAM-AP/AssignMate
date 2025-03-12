import 'package:assignmate/widgets/util_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:assignmate/models/assignment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  String? userName;
  bool _isRep = false;

  late final TextEditingController assignmentController;
  late final TextEditingController dateController;
  final List<Assignment> assignments = [];

  @override
  void initState() {
    super.initState();
    fetchUserName();
    assignmentController = TextEditingController();
    dateController = TextEditingController();

    _loadUserRole();
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return "No Name Found";
    return text[0].toUpperCase() + text.substring(1);
  }

  Future<void> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          userName = "Not Logged In";
        });
        return;
      }

      // Fetch student and class rep docs simultaneously
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection('Students')
          .doc(user.uid)
          .get();

      DocumentSnapshot classRepDoc = await FirebaseFirestore.instance
          .collection('Class_Rep')
          .doc(user.uid)
          .get();

      if (studentDoc.exists && studentDoc.data() != null) {
        Map<String, dynamic> studentData =
            studentDoc.data() as Map<String, dynamic>;
        setState(() {
          userName =
              capitalizeFirstLetter(studentData['userName'] ?? "No Name Found");
        });
      } else if (classRepDoc.exists && classRepDoc.data() != null) {
        Map<String, dynamic> repData =
            classRepDoc.data() as Map<String, dynamic>;
        setState(() {
          userName =
              capitalizeFirstLetter(repData['userName'] ?? "No Name Found");
        });
      } else {
        setState(() {
          userName = "No Name Found";
        });
      }
    } catch (e) {
      setState(() {
        userName = "Error Occurred: $e";
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
      debugPrint(e.toString());
    }
  }

  void _addassignment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFCCD5AE),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Enter Assignment Details",
              style: GoogleFonts.itim(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFBC6C25),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: TextField(
                  controller: assignmentController,
                  decoration: InputDecoration(
                    hintText: "Enter Task",
                    fillColor: const Color(0xFFFAEDCD),
                    filled: true,
                  ),
                ),
              ),
              TextField(
                controller: dateController,
                readOnly: true, // Prevents manual input
                decoration: InputDecoration(
                  fillColor: const Color(0xFFFAEDCD),
                  hintText: "Pick Date",
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
                      EdgeInsets.only(left: 20, right: 30, top: 10, bottom: 15),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      const Color(0xFFBC6C25),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
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
                    textAlign: TextAlign.center,
                    "Submit",
                    style: GoogleFonts.inconsolata(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.only(left: 20, right: 30, top: 10, bottom: 15),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      const Color(0xFFBC6C25),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    textAlign: TextAlign.center,
                    "Cancel",
                    style: GoogleFonts.inconsolata(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
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
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2.0),
      child: Card(
        color: const Color(0xFFCCD5AE),
        elevation: 8,
        child: ListTile(
          contentPadding: EdgeInsets.all(13),
          title: Text(
            data['Title'],
            style: GoogleFonts.itim(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF283618),
            ),
          ),
          subtitle: Text(
            "  Due Date: ${DateFormat('d-MM-y').format(
              (data['Date'] as Timestamp).toDate(),
            )}",
            style: GoogleFonts.itim(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF283618),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isRep = prefs.getBool("isRep") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Welcome\n${userName ?? 'Loading...'}",
                  style: GoogleFonts.itim(
                    fontSize:
                        (userName != null && userName!.length >= 7) ? 35 : 39,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFBC6C25),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Text(
                    'Assignments',
                    style: GoogleFonts.inconsolata(
                      fontSize: 30,
                      color: const Color(0xFF606C38),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05)
                      .copyWith(
                    bottom: 10,
                  ),
                  child: Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width * 0.9,
                    color: const Color(0xFFBC6C25),
                  ),
                ),
              ],
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
                        style: GoogleFonts.itim(
                            color: Color(0xFFBC6C25),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data();

                      return _isRep
                          ? Dismissible(
                              key: Key(doc.id),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                // Get a stable context BEFORE deleting
                                final messengerContext =
                                    ScaffoldMessenger.of(context);

                                await FirebaseFirestore.instance
                                    .collection('Assignment_Subjects')
                                    .doc(doc.id)
                                    .delete();

                                // Ensure context is still valid
                                if (context.mounted) {
                                  messengerContext.showSnackBar(
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
                                }
                              },
                              child: _buildAssignmentData(data),
                            )
                          : _buildAssignmentData(data);
                    },
                  );
                },
              ),
            ),
            if (_isRep)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, bottom: 20),
                  child: FloatingActionButton(
                    backgroundColor: const Color(0xFFBC6C25),
                    onPressed: () {
                      _addassignment();
                    },
                    child: Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: const UtilTab(),
        ),
      ),
    );
  }
}
