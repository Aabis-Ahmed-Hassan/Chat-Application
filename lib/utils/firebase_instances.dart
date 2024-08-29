import 'package:chatapplication/models/ChatUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseInstances {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User currentUser = auth.currentUser!;
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
}
