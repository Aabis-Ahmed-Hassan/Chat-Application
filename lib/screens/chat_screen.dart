import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/components/single_message.dart';
import 'package:chatapplication/models/ChatUser.dart';
import 'package:chatapplication/models/single_message_modal.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.user});
  ChatUser user;

  // for storing all the messages
  List<SingleMessageModal> list = [];

  // for handling new message input
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // go back button
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            // CircleAvatar(
            //   backgroundImage: NetworkImage(
            //     user.image ??
            //         'https://cdn-icons-png.flaticon.com/128/149/149071.png',
            //   ),
            // ),
            // profile image
            CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(width / 2),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: user.image ??
                      'https://cdn-icons-png.flaticon.com/128/149/149071.png',
                  placeholder: (context, url) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Icon(CupertinoIcons.person);
                  },
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            // profile details
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? 'No name',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  user.lastActive ?? 'Last seen at 12:00 am',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: width * 0.035,
          right: width * 0.035,
          bottom: height * 0.01,
        ),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                    stream: FirebaseInstances.getAllMessages(user.id!),
                    builder: (context, snapshot) {
                      {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: SizedBox(),
                          );
                        } else if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text('Say Hi! 👋'),
                          );
                        } else if (snapshot.hasData) {
                          list.clear();
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              data = snapshot.data!.docs;

                          for (QueryDocumentSnapshot<Map<String, dynamic>> i
                              in data) {
                            list.add(SingleMessageModal.fromJson(
                              i.data(),
                            ));
                          }

                          return ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return SingleMessage(
                                    singleMessage: list[index]);
                              });
                        } else {
                          return Center(child: Text('error'));
                        }
                      }
                    })),
            // text field's row (contains emoji picker, textfield, media picker and send message button
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.025,
                      ),
                      Icon(Icons.emoji_emotions),
                      SizedBox(
                        width: width * 0.025,
                      ),
                      SizedBox(
                        width: width * 0.465,
                        child: TextField(
                          controller: _messageController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 4,
                          decoration:
                              InputDecoration(hintText: 'Send a message...'),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.025,
                      ),
                      Icon(Icons.image),
                      SizedBox(
                        width: width * 0.025,
                      ),
                      Icon(Icons.camera),
                      SizedBox(
                        width: width * 0.025,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    if (_messageController.text.isNotEmpty) {
                      FirebaseInstances.sendMessage(
                          _messageController.text, user);
                    }
                    _messageController.text = '';
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
