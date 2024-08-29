import 'package:chatapplication/components/chat_card.dart';
import 'package:chatapplication/screens/auth/login_screen.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.home,
            ),
          ),
          title: Text(
            'HomeScreen',
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () async {
                await FirebaseInstances.auth.signOut().then((a) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                });
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: 10,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return ChatCard();
          },
        ));
  }
}
