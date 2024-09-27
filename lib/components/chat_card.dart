import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/models/ChatUser.dart';
import 'package:chatapplication/models/single_message_modal.dart';
import 'package:chatapplication/models/time_formatter_modal.dart';
import 'package:chatapplication/screens/chat_screen.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ChatCard extends StatelessWidget {
  ChatUser user;

  ChatCard({
    super.key,
    required this.user,
  });

  SingleMessageModal? lastMessage;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                user: user,
              ),
            ),
          );
        },
        child: StreamBuilder(
            stream: FirebaseInstances.firestore
                .collection(
                    'chats/${FirebaseInstances.getConversationId(user.id!)}/messages/')
                .orderBy('sentTime', descending: true)
                .limit(1)
                .snapshots(),
            // stream: FirebaseInstances.getLastMessages(user.id!),
            builder: (context, snapshot) {
              // List _list = snapshot.data!.docs.map((msg) {
              //   return SingleMessageModal.fromJson(msg);
              // }).toList();

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.isEmpty ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                return ListTile(
                  leading: CircleAvatar(
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
                  title: Text(
                    user.name.toString(),
                  ),
                  subtitle: Text(lastMessage == null
                      ? user.about ?? 'Send him a Message!'
                      : lastMessage!.message.toString()),
                  trailing:
                      Text(lastMessage == null ? '' : lastMessage!.sentTime!),
                  // Container(
                  //   height: height * .02,
                  //   width: height * .02,
                  //   decoration: BoxDecoration(
                  //     color: primaryColor,
                  //     borderRadius: BorderRadius.circular(width),
                  //   ),
                  // )
                );
              } else {
                List<QueryDocumentSnapshot<Map<String, dynamic>>> _list =
                    snapshot.data!.docs;

                for (var i in _list) {
                  lastMessage = SingleMessageModal.fromJson(i.data());
                }
                return ListTile(
                  leading: CircleAvatar(
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
                  title: Text(
                    user.name.toString(),
                  ),
                  subtitle: lastMessage == null
                      ? Text(user.about ?? 'Send him a Message!')
                      : lastMessage!.type == 'text'
                          ? Text(lastMessage!.message.toString())
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 16,
                                ),
                                Text(' Photo'),
                              ],
                            ),
                  trailing: lastMessage == null
                      ? null
                      : lastMessage!.readTime!.isEmpty &&
                              lastMessage!.senderId !=
                                  FirebaseAuth.instance.currentUser!.uid
                          ? Container(
                              height: height * .02,
                              width: height * .02,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(width),
                              ),
                            )
                          : Text(TimeFormatterModal.format2(
                              lastMessage!.sentTime!, context) ),

                  // Container(
                  //   height: height * .02,
                  //   width: height * .02,
                  //   decoration: BoxDecoration(
                  //     color: primaryColor,
                  //     borderRadius: BorderRadius.circular(width),
                  //   ),
                  // )
                );
              }
            }),
      ),
    );
  }
}
