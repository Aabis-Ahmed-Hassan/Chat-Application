import 'package:chatapplication/screens/edit_profile.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<ChatUser> list = [];
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
        title: Text('Hello 👋'),
        actions: [
          // show profile image

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(currentUser: list[0]),
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                list[0].image ??
                    'https://cdn-icons-png.flaticon.com/128/149/149071.png',
              ),
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
            list = [];
            List data = snapshot.data!.docs;
            for (QueryDocumentSnapshot<Map<String, dynamic>> i in data) {
              list.add(ChatUser.fromJson(i.data()));
            }

            return ListView.builder(
              // itemCount: snapshot.data!.docs.length,
              itemCount: list.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                // if (FirebaseInstances.currentUser.uid !=
                //     snapshot.data!.docs[index].get('id'))
                return ChatCard(
                  // user: ChatUser.fromJson(snapshot.data!.docs[index].data()),
                  user: list[index],
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
