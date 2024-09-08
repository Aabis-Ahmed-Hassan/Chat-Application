import 'dart:io';

import 'package:chatapplication/models/ChatUser.dart';
import 'package:chatapplication/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseInstances {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User currentUser = FirebaseAuth.instance.currentUser!;

  static FirebaseStorage storage = FirebaseStorage.instance;
  // check if user already exists
  static Future<bool> userExistence() async {
    return (await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get())
        .exists;
  }
//   create a new user if it doesn't exist already
// in this way, the document will not get clear on every login

  static Future<void> createUser() async {
    ChatUser newUser = ChatUser(
      image: currentUser.photoURL.toString(),
      about: 'I am using chat app',
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      email: currentUser.email.toString(),
      id: currentUser.uid,
      isOnline: false,
      lastActive: '12:02',
      name: currentUser.displayName.toString(),
      pushToken: 'push token',
    );

    await FirebaseInstances.firestore
        .collection('users')
        .doc(currentUser.uid)
        .set(newUser.toJson());
  }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsersExceptSelf() {
  //   return firestore.collection('users').snapshots();
  // }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsersExceptSelf() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  static late ChatUser me;
  static Future<void> getSelfData() async {
    print('current user uid in get self data function ' +
        FirebaseAuth.instance.currentUser!.uid);
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((user) {
      if (user != null) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        getSelfData();
      }
      print('my data ${me.name}');
    });
  }

  static Future<void> updateProfile(BuildContext context) async {
    print('name ' + me.name.toString());
    print('about ' + me.about.toString());
    print('id ' + me.id.toString());

    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'name': me.name,
      'about': me.about,
      'image': me.image,
    }).then((e) {
      Utils.showSnackBar(context, 'Profile Updated Successfully');
      // // the data on firebase  gets updated but to show the updated version on the app when we even the profile screen again,
      // // we need to call this function
      // FirebaseInstances.getSelfData();
    }).catchError((e) {
      Utils.showSnackBar(context, 'An Error Occurred');
    });
  }

  static Future<void> updateProfilePicture(
      File file, BuildContext context) async {
    Reference ref = storage.ref().child('profile_pictures/${file.path}');

    TaskSnapshot uploadTask = await ref.putFile(file);
    String downloadUrl = await ref.getDownloadURL();

    me.image = downloadUrl;
    updateProfile(context);
  }
}
