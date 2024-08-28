import 'package:chatapplication/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Chat App'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                  height: height * .2,
                  // width: width * .3,
                  // fit: BoxFit.cover,
                  'assets/app_icon.png'),
              SizedBox(
                height: height * .2,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: height * .015),
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
