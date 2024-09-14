import 'package:chatapplication/models/single_message_modal.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:flutter/material.dart';

class SingleMessage extends StatelessWidget {
  SingleMessage({super.key, required this.singleMessage});

  SingleMessageModal singleMessage;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // return Container(
    //   margin: EdgeInsets.symmetric(
    //     vertical: height * 0.025,
    //   ),
    //   child: Row(
    //     children: [
    //       Icon(
    //         Icons.double_arrow,
    //         color: Colors.blue,
    //         size: 16,
    //       ),
    //       Text(singleMessage.sentTime.toString()),
    //       Spacer(),
    //       Container(
    //         padding: EdgeInsets.symmetric(
    //             horizontal: width * 0.02, vertical: height * 0.01),
    //         decoration: BoxDecoration(
    //           color: Colors.purple.shade200,
    //           borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(30),
    //             topRight: Radius.circular(30),
    //             bottomLeft: Radius.circular(30),
    //           ),
    //         ),
    //         child: Text(
    //           singleMessage.message.toString(),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    // return singleMessage.senderId == FirebaseInstances.currentUser.uid
    //     ? Text('ME')
    //     : Text('THEM');
    return singleMessage.senderId == FirebaseInstances.auth.currentUser!.uid
        ? Container(
            margin: EdgeInsets.symmetric(
              vertical: height * 0.025,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.double_arrow,
                  color: Colors.blue,
                  size: 16,
                ),
                Text(singleMessage.sentTime.toString()),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: height * 0.01),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
                  child: Text(
                    singleMessage.message.toString(),
                  ),
                ),
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.symmetric(
              vertical: height * 0.025,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: height * 0.01),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Text(
                    singleMessage.message.toString(),
                  ),
                ),
                Spacer(),
                Text(singleMessage.sentTime.toString()),
                Icon(
                  Icons.double_arrow,
                  color: Colors.blue,
                  size: 16,
                ),
              ],
            ),
          );
  }
}
