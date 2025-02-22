import 'package:assign_mate_app/widgets/util_tab.dart';
import 'package:flutter/material.dart';

class InternalsCalc extends StatefulWidget {
  const InternalsCalc({super.key});

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
      showResultDialog("Scam", "Enter marks to calculate the internals");
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

  void showResultDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Internal Calculator"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
                      TextField(
                        controller: firstSeriesController,
                        decoration: InputDecoration(
                            hintText: "Enter First Series Marks:"),
                      ),
                      const SizedBox(height: 50),
                      TextField(
                        controller: secondSeriesController,
                        decoration: InputDecoration(
                            hintText: "Enter Second Series Marks:"),
                      ),
                      const SizedBox(height: 50),
                      TextField(
                        controller: assignmentMarksController,
                        decoration: InputDecoration(
                            hintText: "Enter Assignment Marks:"),
                      ),
                      const SizedBox(height: 50),
                      TextField(
                        controller: attendanceController,
                        decoration: InputDecoration(
                            hintText: "Enter Attendance in Percentage:"),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: calculateInternals,
                        child: Text("Check Values"),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: UtilTab(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
