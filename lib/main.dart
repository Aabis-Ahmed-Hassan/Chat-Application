import 'package:chatapplication/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 1,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      home: LoginScreen(),
    );
  }
}
