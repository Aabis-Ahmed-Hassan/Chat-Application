import 'package:chatapplication/screens/edit_profile.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/chat_card.dart';
import '../models/ChatUser.dart';
import '../utils/utils.dart';
import 'auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  List<ChatUser> _searchList = [];
  late String image;
  bool isSearching = false;
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseInstances.getSelfData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching = false;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: InkWell(
              onTap: () async {
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
              child: Icon(
                CupertinoIcons.home,
              ),
            ),
            title: isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration:
                        const InputDecoration(hintText: 'Name, email ...'),
                    onChanged: (value) {
                      setState(() {
                        _searchList.clear();
                        for (ChatUser i in _list) {
                          if (i.name!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              i.email!
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                            _searchList.add(i);
                          }
                        }
                        setState(() {});
                      });
                    },
                  )
                : const Text('Hello 👋'),
            actions: [
              // show profile image

              InkWell(
                onTap: () {
                  setState(() {
                    isSearching = !isSearching;
                    _searchController.text = '';
                  });
                },
                child: Icon(
                  isSearching ? Icons.close : Icons.search,
                ),
              ),
              SizedBox(
                width: width * 0.03,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfileScreen(currentUser: FirebaseInstances.me),
                    ),
                  );
                },
                child: const CircleAvatar(
                  // backgroundImage: NetworkImage(list.isEmpty
                  //     ? 'https://cdn-icons-png.flaticon.com/128/149/149071.png'
                  //     : list[0].image!),
                  backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/128/149/149071.png',
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.03,
              ),
            ],
          ),
          body: InkWell(
            onTap: () {
              //   hide keyboard on tap
              FocusScope.of(context).unfocus();
            },
            child: StreamBuilder(
              stream: FirebaseInstances.getAllUsersExceptSelf(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No Messages Found!'),
                    );
                  }
                  _list = [];
                  List data = snapshot.data!.docs;
                  for (QueryDocumentSnapshot<Map<String, dynamic>> i in data) {
                    _list.add(ChatUser.fromJson(i.data()));
                  }

                  return ListView.builder(
                    // itemCount: snapshot.data!.docs.length,
                    itemCount: isSearching ? _searchList.length : _list.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatCard(
                        // user: ChatUser.fromJson(snapshot.data!.docs[index].data()),
                        user: isSearching ? _searchList[index] : _list[index],
                      );

                      // if (_searchController.text.isNotEmpty) {
                      //   if (_list[index].name!.toLowerCase().toString().contains(
                      //       _searchController.text.toString().toLowerCase())) {
                      //   }
                      // } else {
                      //   return ChatCard(
                      //     // user: ChatUser.fromJson(snapshot.data!.docs[index].data()),
                      //     user: _list[index],
                      //   );
                      // }
                    },
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No Messages Found'),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error occured!'),
                  );
                } else {
                  return const Center(
                    child: Text('An unknown error occured!'),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
