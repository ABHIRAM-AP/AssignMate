import 'package:assign_mate_app/widgets/util_tab.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InternalsCalc extends StatefulWidget {
  final bool isRep;
  const InternalsCalc({
    super.key,
    required this.isRep,
  });

  @override
  State<InternalsCalc> createState() => _InternalsCalcState();
}

class _InternalsCalcState extends State<InternalsCalc> {
  final TextEditingController firstSeriesController = TextEditingController();
  final TextEditingController secondSeriesController = TextEditingController();
  final TextEditingController assignmentMarksController =
      TextEditingController();
  final TextEditingController attendanceController = TextEditingController();

  @override
  void dispose() {
    firstSeriesController.dispose();
    secondSeriesController.dispose();
    assignmentMarksController.dispose();
    attendanceController.dispose();
    super.dispose();
  }

  void calculateInternals() {
    double? series1Marks = double.tryParse(firstSeriesController.text.trim());
    double? series2Marks = double.tryParse(secondSeriesController.text.trim());
    double? attendanceMark = double.tryParse(attendanceController.text.trim());
    double? assignmentMark =
        double.tryParse(assignmentMarksController.text.trim());

    if (series1Marks == null ||
        series2Marks == null ||
        assignmentMark == null ||
        attendanceMark == null) {
      showResultDialog("", "Enter marks to calculate the internals");
      return;
    } else if (assignmentMark > 15 || assignmentMark < 0) {
      showResultDialog("Assignment Marks", "Enter a valid Assignment mark");
      return;
    } else if (series1Marks > 50 ||
        series2Marks > 50 ||
        series1Marks < 0 ||
        series2Marks < 0) {
      showResultDialog("Series Marks", "Enter a valid Series mark");
      return;
    } else if (attendanceMark > 100 || attendanceMark < 0) {
      showResultDialog("Attendance", "Enter a valid Attendance");
      return;
    } else {
      if (attendanceMark >= 90 || attendanceMark <= 100) {
        attendanceMark = 10;
      } else if (attendanceMark < 90 || attendanceMark >= 80) {
        attendanceMark = 9;
      } else {
        attendanceMark = 8.5;
      }

      double seriesAvg =
          (series1Marks / 50) * 12.5 + (series2Marks / 50) * 12.5;

      double totalMarks = seriesAvg + attendanceMark + assignmentMark;
      showResultDialog(
          "Internal Marks", "Your total internal marks: $totalMarks");
      resetFields();
    }
  }

  void showResultDialog(String? title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFCCD5AE),
        title: title != null && title.isNotEmpty
            ? Text(
                title,
                style: GoogleFonts.itim(
                    fontSize: 24, color: const Color(0xFFBC6C25)),
              )
            : null,
        content: Text(
          message,
          style: GoogleFonts.inconsolata(
              fontSize: 17, fontWeight: FontWeight.w500),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(
                color: Color(0xFFBC6C25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resetFields() {
    firstSeriesController.clear();
    secondSeriesController.clear();
    attendanceController.clear();
    assignmentMarksController.clear();
    setState(() {});
  }

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFCCD5AE),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFFBC6C25), width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Internal Calculator",
          style: GoogleFonts.itim(
            color: const Color(0xFFBC6C25),
            fontWeight: FontWeight.w800,
            fontSize: 28,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: const Color(0xFFBC6C25),
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context, widget.isRep);
            } else {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 50),
                      TextField(
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: firstSeriesController,
                        decoration:
                            customInputDecoration("Enter First Series Marks:"),
                      ),
                      const SizedBox(height: 50),
                      TextField(
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: secondSeriesController,
                        decoration:
                            customInputDecoration("Enter Second Series Marks:"),
                      ),
                      const SizedBox(height: 50),
                      TextField(
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: assignmentMarksController,
                        decoration:
                            customInputDecoration("Enter Assignment Marks:"),
                      ),
                      const SizedBox(height: 50),
                      TextField(
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: attendanceController,
                        decoration: customInputDecoration(
                            "Enter Attendance in Percentage:"),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: calculateInternals,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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
