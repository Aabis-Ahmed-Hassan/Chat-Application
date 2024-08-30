import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/models/ChatUser.dart';
import 'package:chatapplication/screens/auth/login_screen.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:chatapplication/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key, required this.currentUser});
  ChatUser currentUser;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _aboutController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.currentUser.name ?? 'Null Name';
    _aboutController.text = widget.currentUser.about ?? 'Null About';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _aboutController.dispose();
  }

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
                          fit: BoxFit.fill,
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
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          color: Colors.white,
                          shape: CircleBorder(),
                          onPressed: () {},
                          child: Icon(
                            Icons.edit,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * .025),
                  // email
                  Text(widget.currentUser.email ?? 'noemail@gmail.com'),
                  SizedBox(height: height * .025),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // name text field
                        TextFormField(
                          // onSaved: (value) {
                          //   FirebaseInstances.me.name = value;
                          // },
                          validator: (value) {
                            if (value!.isEmpty || value == null) {
                              return 'Required field';
                            }
                          },
                          decoration: InputDecoration(
                            label: Text('Name'),
                            hintText: 'e.g. Ali',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          controller: _nameController,
                        ),
                        SizedBox(height: height * .025),
                        // about text field

                        TextFormField(
                          // onSaved: (value) {
                          //   FirebaseInstances.me.about = value;
                          // },
                          validator: (value) {
                            if (value!.isEmpty || value == null) {
                              return 'Required field';
                            }
                          },
                          decoration: InputDecoration(
                            label: Text('About'),
                            hintText: 'e.g. I am using Chat App',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.info),
                          ),
                          controller: _aboutController,
                        ),
                        SizedBox(height: height * .025),
                        // update button
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _loading = true;
                            });

                            if (_formKey.currentState!.validate()) {
                              print('form key validate');
                              FirebaseInstances.updateProfile(
                                context,
                                _nameController.text.toString(),
                                _aboutController.text.toString(),
                              ).then((e) {
                                Navigator.pop(context);
                              });
                            }
                            setState(() {
                              _loading = false;
                            });
                            ;
                          },
                          child: _loading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(
                                        width: width * .025,
                                      ),
                                      Text('Update'),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
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
              await GoogleSignIn().signOut().then((value) {
                // to clear the stack
                Navigator.pop(context);
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
