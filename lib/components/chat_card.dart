import 'package:chatapplication/models/ChatUser.dart';
import 'package:chatapplication/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  ChatUser user;
  ChatCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryColor,
          child: Icon(
            CupertinoIcons.person,
            color: Colors.white,
          ),
        ),
        title: Text(
          user.name.toString(),
        ),
        subtitle: Text(user.lastActive.toString()),
        trailing: Text(user.lastActive.toString()),
      ),
    );
  }
}
