import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/models/ChatUser.dart';
import 'package:chatapplication/models/time_formatter_modal.dart';
import 'package:chatapplication/screens/auth/login_screen.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:chatapplication/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ViewProfileScreen extends StatefulWidget {
  ViewProfileScreen({super.key, required this.currentUser});
  ChatUser currentUser;

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        // to close the keyboard whenever someone clicks on anywhere on the screen
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // profile image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(width / 2),
                        child: CachedNetworkImage(
                          height: width * .4,
                          width: width * .4,
                          fit: BoxFit.cover,
                          imageUrl: widget.currentUser.image ??
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
                      // Positioned(
                      //   bottom: 0,
                      //   right: 0,
                      //   child: MaterialButton(
                      //     color: Colors.white,
                      //     shape: CircleBorder(),
                      //     onPressed: () {
                      //       showBottomSheetForPickingImage(height);
                      //     },
                      //     child: Icon(
                      //       Icons.edit,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: height * .025),
                  // email
                  SizedBox(height: height * .025),
                  Column(
                    children: [
                      // email
                      MyRow(
                          title: 'Email',
                          subtitle: widget.currentUser.email.toString()),
                      SizedBox(height: height * .025),
                      // name
                      MyRow(
                          title: 'Name',
                          subtitle: widget.currentUser.name.toString()),
                      SizedBox(height: height * .025),
                      // about
                      MyRow(
                          title: 'About',
                          subtitle: widget.currentUser.about.toString()),

                      SizedBox(height: height * .025),
                      MyRow(
                          title: 'Created At',
                          subtitle:
                              'Created At ${TimeFormatterModal.formatForShowingAccountCreationDate(widget.currentUser.createdAt.toString(), context)}'),
                      SizedBox(height: height * .025),
                      MyRow(
                        title: 'Current Status',
                        subtitle: widget.currentUser.isOnline ?? false
                            ? 'Online'
                            : 'Offline',
                      ),
                      SizedBox(height: height * .025),
                      if (!bool.parse(widget.currentUser.isOnline.toString()))
                        MyRow(
                          title: 'Last Seen',
                          subtitle: TimeFormatterModal
                              .formatForProfileLastSeenAtChatScreen(
                                  widget.currentUser.lastActive.toString(),
                                  context),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () async {
            await FirebaseInstances.auth.signOut().then((value) async {
              await FirebaseInstances.updateMyLastSeen(false);
              await GoogleSignIn().signOut().then((value) {
                // to clear the stack

                Navigator.pop(context);
                // reinstantiating the auth method so that after signing in again, we'll not be using details of previous user
                FirebaseInstances.auth = FirebaseInstances.auth;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              }).catchError((e) {
                Utils.showSnackBar(context, 'Sign out fail!');
              });
            }).catchError((e) {
              Utils.showSnackBar(context, 'Sign out fail!');
            });
          },
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.logout),
              Text('Logout'),
            ],
          ),
        ),
      ),
    );
  }
}

class MyRow extends StatelessWidget {
  MyRow({super.key, required this.title, required this.subtitle});

  String title, subtitle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          subtitle,
        ),
      ],
    );
  }
}
