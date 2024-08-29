import 'package:chatapplication/screens/auth/login_screen.dart';
import 'package:chatapplication/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    Future.delayed(
        Duration(
          milliseconds: 1500,
        ), () {
      // user is login
      if (FirebaseAuth.instance.currentUser != null) {
        // move to homescreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
      // user is not loing
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
          ),
          child: Image.asset(
            height: height * .15,
            // width: width * .1,
            fit: BoxFit.cover,
            'assets/app_icon.png',
          ),
        ),
      ),
    );
  }
}
