import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            CupertinoIcons.person,
          ),
        ),
        title: Text('Human'),
        subtitle: Text('Last message'),
        trailing: Text('12:00 PM'),
      ),
    );
  }
}
