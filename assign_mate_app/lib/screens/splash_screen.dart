import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:assign_mate_app/screens/login_screen_normal.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Lottie.asset("assets/splash.json", width: 300), // Lottie animation
      ),
    );
  }
}
