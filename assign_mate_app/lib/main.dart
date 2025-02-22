import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:assign_mate_app/screens/assignments_screen.dart';
import 'package:assign_mate_app/screens/login_screen_normal.dart';
import 'package:assign_mate_app/screens/splash_screen.dart';
import 'package:assign_mate_app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Firebase.initializeApp();
    if (!mounted) return;

    // Check authentication state after Firebase initializes
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      debugPrint("User logged in: ${user.email}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const AssignmentsScreen(isRep: false)),
      );
    } else {
      debugPrint("User not logged in");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
