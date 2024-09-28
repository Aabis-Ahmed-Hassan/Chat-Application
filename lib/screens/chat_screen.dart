import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/components/single_message.dart';
import 'package:chatapplication/models/ChatUser.dart';
import 'package:chatapplication/models/single_message_modal.dart';
import 'package:chatapplication/models/time_formatter_modal.dart';
import 'package:chatapplication/screens/view_profile_screen.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/constants.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.user});
  ChatUser user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for storing all the messages
  List<SingleMessageModal> list = [];

  // for handling new message input
  TextEditingController _messageController = TextEditingController();

  bool _showEmojis = false;
  bool _isUploading = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        if (_showEmojis) {
          setState(() {
            _showEmojis = false;
          });
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.purple.shade50,
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewProfileScreen(
                    currentUser: widget.user,
                  ),
                ),
              );
            },
            child: Row(
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
                      imageUrl: widget.user.image ??
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
                      widget.user.name ?? 'No name',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    StreamBuilder(
                        stream: FirebaseInstances.getUserLastSeen(
                          widget.user,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            List _list = snapshot.data!.docs;
                            ChatUser user = ChatUser.fromJson(_list[0].data());
                            return Text(
                              user.isOnline!
                                  ? 'Online'
                                  : 'Last Seen at ${TimeFormatterModal.formatForProfileLastSeenAtChatScreen(user.lastActive.toString(), context)}' ??
                                      'No last seen',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ],
            ),
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
                      stream: FirebaseInstances.getAllMessages(widget.user.id!),
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
              if (_isUploading)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: primaryColor,
                    ),
                  ),
                ),
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
                        InkWell(
                          onTap: () {
                            setState(() {
                              print('show emoji is tapped');
                              FocusScope.of(context).unfocus();
                              _showEmojis = !_showEmojis;
                            });
                          },
                          child: Icon(Icons.emoji_emotions),
                        ),
                        SizedBox(
                          width: width * 0.025,
                        ),
                        // text field
                        SizedBox(
                          width: width * 0.465,
                          child: TextField(
                            onTap: () {
                              if (_showEmojis) {
                                setState(() {
                                  _showEmojis = !_showEmojis;
                                });
                              }
                            },
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

                        GestureDetector(
                          onTap: () async {
                            ImagePicker _picker = ImagePicker();
                            List<XFile> images = await _picker.pickMultiImage(
                              imageQuality: 50,
                            );
                            // XFile? file = await _picker.pickImage(
                            //   source: ImageSource.gallery,
                            //   imageQuality: 50,
                            // );
                            if (images.isNotEmpty) {
                              setState(() {
                                _isUploading = true;
                              });
                              for (var i in images) {
                                await FirebaseInstances.sendImageMessage(
                                    widget.user, File(i.path));
                              }
                              setState(() {
                                _isUploading = false;
                              });
                            }
                          },
                          child: Icon(Icons.image),
                        ),
                        SizedBox(
                          width: width * 0.025,
                        ),
                        GestureDetector(
                          onTap: () async {
                            ImagePicker _picker = ImagePicker();
                            XFile? file = await _picker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 50,
                            );
                            if (file != null) {
                              setState(() {
                                _isUploading = true;
                              });
                              await FirebaseInstances.sendImageMessage(
                                  widget.user, File(file.path));
                              setState(() {
                                _isUploading = true;
                              });
                            }
                          },
                          child: Icon(Icons.camera),
                        ),
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
                            _messageController.text, widget.user, 'text');
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
              if (_showEmojis)
                SizedBox(
                  height: height * 0.35,
                  child: EmojiPicker(
                    textEditingController: _messageController,
                    config: Config(
                      // height: 256,
                      emojiViewConfig: EmojiViewConfig(
                          emojiSizeMax: 26 *
                              (Platform.isIOS == TargetPlatform.iOS
                                  ? 1.3
                                  : 1.0),
                          columns: 8),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
