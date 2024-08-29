import 'package:chatapplication/screens/auth/login_screen.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/chat_card.dart';
import '../models/ChatUser.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
            'Hey ${FirebaseInstances.currentUser.displayName!.length > 7 ? FirebaseInstances.currentUser.displayName!.substring(0, 7) + '...' : FirebaseInstances.currentUser.displayName}' +
                '👋'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseInstances.auth.signOut().then((a) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
            icon: Icon(Icons.logout),
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(
              FirebaseInstances.currentUser.photoURL ??
                  'https://cdn-icons-png.flaticon.com/128/149/149071.png',
            ),
          ),
          SizedBox(
            width: width * 0.03,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseInstances.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No Connection Found'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (FirebaseInstances.currentUser.uid !=
                    snapshot.data!.docs[index].get('id'))
                  return ChatCard(
                    user: ChatUser.fromJson(snapshot.data!.docs[index].data()),
                  );
              },
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Messages Found'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('An error occured!'),
            );
          } else {
            return Center(
              child: Text('An unknown error occured!'),
            );
          }
        },
      ),
    );
  }
}
