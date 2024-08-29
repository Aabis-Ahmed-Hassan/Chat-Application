import 'dart:io';

import 'package:chatapplication/screens/home_screen.dart';
import 'package:chatapplication/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    Future.delayed(
        Duration(
          milliseconds: 500,
        ), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  //
  _login() {
    Utils.showProgressBar(context);
    signInWithGoogle().then((value) {
      Navigator.pop(context);
      print(value!.user);
      print('\n\n');

      print(value!.credential);
      print('\n\n');
      print(value.additionalUserInfo);
      print('\n\n');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      return await FirebaseAuth.instance.signInWithCredential(credentials);
    } catch (e) {
      print('signInWithGoogle: $e');
      Utils.showSnackBar(context, 'An error occured (Internet Issue)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
          ),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedPositioned(
                duration: Duration(
                  seconds: 1,
                ),
                top: height * .2,
                right: _isAnimate ? width / 3 : 0,
                child: Image.asset(
                    height: height * .15,
                    // width: width * .3,
                    // fit: BoxFit.cover,
                    'assets/app_icon.png'),
              ),
              AnimatedPositioned(
                bottom: height * .3,
                duration: Duration(
                  seconds: 1,
                ),
                right: _isAnimate ? width / 4 : 0,
                child: ElevatedButton(
                  onPressed: () {
                    _login();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        height: height * .05,
                        // width: width * .1,
                        fit: BoxFit.cover,
                        'assets/google.png',
                      ),
                      SizedBox(
                        width: width * .02,
                      ),
                      Text(
                        'Sign in with ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Google',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
