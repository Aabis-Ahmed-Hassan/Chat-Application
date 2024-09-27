import 'dart:io';

import 'package:chatapplication/models/ChatUser.dart';
import 'package:chatapplication/models/single_message_modal.dart';
import 'package:chatapplication/models/time_formatter_modal.dart';
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
      lastActive: DateTime.now().millisecondsSinceEpoch.toString(),
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

  // static Future<Stream<QuerySnapshot<Map<String, dynamic>>>>
  //     getAllMessages() async {
  //   return firestore.collection('messages').snapshots();
  // }

  static String getConversationId(String id) {
    return auth.currentUser!.uid.hashCode <= id.hashCode
        ? '${auth.currentUser!.uid}_$id'
        : '${id}_${auth.currentUser!.uid}';
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(String id) {
    return firestore
        .collection('chats/${getConversationId(id)}/messages/')
        .snapshots();
  }

  static Future<void> sendMessage(
      String textMessage, ChatUser user, String messageType) async {
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    print(time);
    print(DateTime.now().day);
    SingleMessageModal messageToUpload = SingleMessageModal(
      type: messageType,
      sentTime: time,
      senderId: auth.currentUser!.uid,
      receiverId: user.id,
      readTime: '',
      message: textMessage,
      docId: time,
      conversationId: getConversationId(user.id!),
    );
    var ref =
        firestore.collection('chats/${getConversationId(user.id!)}/messages/');
    await ref.doc(time).set(messageToUpload.toJson());
  }

  static Future<void> updateReadMessageTime(
      SingleMessageModal message, BuildContext context) async {
    String readTime = TimeFormatterModal.format(
        DateTime.now().millisecondsSinceEpoch.toString(), context);
    var ref2 =
        firestore.collection('chats/${message.conversationId}/messages/');
    await ref2.doc(message.sentTime).update({'readTime': '$readTime'});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      String id) {
    return firestore
        .collection('chats/${getConversationId(id)}/messages/')
        .orderBy('sentTime', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> updateProfilePicture(
      File file, BuildContext context) async {
    String extension = file.path.split('.').last;
    Reference ref = FirebaseStorage.instance.ref().child(
        'profile_pictures/${FirebaseAuth.instance.currentUser!.uid}.$extension}');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$extension'));
    String imageUrl = await ref.getDownloadURL();
    me.image = imageUrl;
    updateProfile(context);

    //
    // String fileName = basename(file.path);
    // Reference ref = storage.ref().child('profile_pictures/${fileName}');
    // Reference ref = storage.ref().child('profile_pictures/${file.path}');
    //
    // TaskSnapshot uploadTask = await ref.putFile(file);
    // String downloadUrl = await ref.getDownloadURL();
    //
    // me.image = downloadUrl;
    // updateProfile(context);
  }

  static Future<void> sendImageMessage(ChatUser user, File file) async {
    final extension = file.path.split('.').last;

    Reference ref = FirebaseStorage.instance.ref().child(
        'images/${getConversationId(user.id!)}/${DateTime.now().millisecondsSinceEpoch.toString()}/$extension');
    await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/$extension'),
    );

    String downloadUrl = await ref.getDownloadURL();

    await sendMessage(downloadUrl, user, 'image');

    // final ext = file.path.split('.').last;
    // final ref = storage.ref().child(
    //     'images/${getConversationId(user.id!)}/${DateTime.now().millisecondsSinceEpoch.toString()}.$ext');
    //
    // await ref
    //     .putFile(file, SettableMetadata(contentType: 'image/$ext'))
    //     .then((e) {
    //   print('data transferred : ${e.bytesTransferred / 1000} kb');
    // });
    //
    // final imageUrl = await ref.getDownloadURL();
    // await sendMessage(imageUrl, user, 'image');
  }

  static Future<void> deleteMessage(SingleMessageModal message) async {
    var ref =
        await firestore.collection('chats/${message.conversationId}/messages/');
    await ref.doc(message.docId).delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserLastSeen(
      ChatUser user) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: user.id)
        .snapshots();
  }

  static Future<void> updateMyLastSeen(bool isOnline) async {
    await firestore.collection('users').doc(currentUser.uid!).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }
}
