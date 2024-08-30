import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: ListTile(
          leading: CircleAvatar(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(width / 2),
              child: CachedNetworkImage(
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
          subtitle: Text(user.id.toString()),
          trailing: Random().nextInt(2) % 2 == 0
              ? Container(
                  height: height * .02,
                  width: height * .02,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(width),
                  ),
                )
              : Text(user.lastActive.toString()),
        ),
      ),
    );
  }
}
