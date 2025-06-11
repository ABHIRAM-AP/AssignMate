import 'package:assignmate/screens/login_screen_normal.dart';
import 'package:assignmate/services/firebase_auth_services.dart';
import 'package:assignmate/widgets/app_title.dart';
import 'package:assignmate/widgets/email_id_textfield.dart';
import 'package:assignmate/widgets/password_textfield.dart';
import 'package:assignmate/widgets/radio_buttons.dart';
import 'package:assignmate/widgets/rep_id_textfield.dart';
import 'package:assignmate/widgets/user_name_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? _role = 'student';

  late final TextEditingController emailidController;
  late final TextEditingController userNameController;
  late final TextEditingController repidController;
  late final TextEditingController passwordController;
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    emailidController = TextEditingController();
    userNameController = TextEditingController();
    repidController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailidController.dispose();
    userNameController.dispose();
    repidController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleSignUp() async {
    try {
      if (_role == "rep") {
        bool repExists = await _authService.checkIfRepExists();
        if (repExists) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    "A representative already exists! You cannot sign up as a rep."),
              ),
            );
          }
          return;
        }
      }

      await _authService.signUpUser(
        email: emailidController.text.trim(),
        password: passwordController.text.trim(),
        userName: userNameController.text.trim(),
        role: _role!,
        repId: _role == "rep" ? repidController.text.trim() : "101",
      );

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to create an account: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Sign Up",
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFFBC6C25),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const AppTitle(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0)
                          .copyWith(bottom: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          EmailIdTextfield(
                              emailidController: emailidController),
                          const SizedBox(height: 20),

                          UserNameTextfield(
                              userNameController: userNameController),
                          const SizedBox(height: 20),
                          // Rep ID TextField (only for "Rep" role)
                          if (_role == 'rep')
                            RepIdTextfield(repidController: repidController),
                          const SizedBox(height: 20),

                          PasswordTextfield(
                              passwordController: passwordController),
                          const SizedBox(height: 20),

                          // Role Selection (Radio Buttons)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RadioOptionWidget(
                                  text: "Student",
                                  value: "student",
                                  groupValue: _role,
                                  onChanged: (val) =>
                                      setState(() => _role = val),
                                ),
                                const SizedBox(width: 20),
                                RadioOptionWidget(
                                  text: "Rep",
                                  value: "rep",
                                  groupValue: _role,
                                  onChanged: (val) =>
                                      setState(() => _role = val),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Sign Up Button
                          SizedBox(
                            width: 264,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              onPressed: () {
                                if (emailidController.text.trim().isNotEmpty &&
                                    passwordController.text.trim().isNotEmpty) {
                                  if (_role == "rep") {
                                    if (repidController.text
                                        .trim()
                                        .isNotEmpty) {
                                      handleSignUp();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("Enter Rep ID"),
                                        ),
                                      );
                                    }
                                  } else {
                                    handleSignUp();
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Enter the credentials"),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
