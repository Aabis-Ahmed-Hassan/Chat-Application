import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/models/ChatUser.dart';
import 'package:chatapplication/screens/view_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ProfileDetailsDialog extends StatelessWidget {
  ProfileDetailsDialog({super.key, required this.user});

  ChatUser user;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        // padding: EdgeInsets.symmetric(
        //   horizontal: width * 0.025,
        // ),
        height: height * 0.3,
        width: height * 0.3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  // to close the dialogue box
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProfileScreen(
                        currentUser: user,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey.withOpacity(0.4),
                  child: Icon(
                    Icons.info_outline,
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: width * 0.2,
              backgroundColor: primaryColor.withOpacity(0.4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(width / 2),
                child: CachedNetworkImage(
                  height: height * 0.2,
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
              height: height * 0.025,
            ),
            Text(
              user.name.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
