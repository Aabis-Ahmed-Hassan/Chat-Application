import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/models/single_message_modal.dart';
import 'package:chatapplication/models/time_formatter_modal.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:flutter/cupertino.dart';
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
        ? SenderMessage(context)
        : ReceiverMessage(context);
  }

  Widget SenderMessage(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                insetPadding: EdgeInsets.zero,
                content: Container(
                  child: Text("Do you want to delete this message?"),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No')),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseInstances.deleteMessage(singleMessage);
                      Navigator.pop(context);
                    },
                    child: Text('Yes'),
                  ),
                ],
              );
            });
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: height * 0.025,
        ),
        child: Row(
          children: [
            Icon(
              Icons.done_all,
              color: singleMessage.readTime!.isNotEmpty
                  ? Colors.blue
                  : Colors.grey,
              size: 16,
            ),
            Text(TimeFormatterModal.format(singleMessage.sentTime!, context)),
            // Spacer(),
            SizedBox(
              width: width * 0.05,
            ),
            Spacer(),
            Container(
              constraints: BoxConstraints(
                maxWidth: width * 0.65,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: height * 0.0125, vertical: height * 0.0125),
              decoration: BoxDecoration(
                color: Colors.purple.shade200,
                border: Border.all(
                  color: Colors.purple,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: singleMessage.type == 'text'
                  ? Text(
                      singleMessage.message.toString(),
                      style: TextStyle(fontSize: 16),
                    )
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: singleMessage.message.toString(),
                      placeholder: (context, url) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Icon(CupertinoIcons.person);
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget ReceiverMessage(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (singleMessage.readTime!.isEmpty) {
      FirebaseInstances.updateReadMessageTime(singleMessage, context);
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: height * 0.025,
      ),
      child: Row(
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: width * 0.65,
            ),
            padding: EdgeInsets.symmetric(
                horizontal: height * 0.0125, vertical: height * 0.0125),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.purple,
              ),
              color: Colors.purple.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: singleMessage.type == 'text'
                ? Text(
                    singleMessage.message.toString(),
                    style: TextStyle(fontSize: 16),
                  )
                : CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: singleMessage.message.toString(),
                    placeholder: (context, url) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Icon(Icons.image);
                    },
                  ),
          ),
          SizedBox(
            width: width * 0.05,
          ),
          Spacer(),
          Text(TimeFormatterModal.format(singleMessage.sentTime!, context)),
          // Icon(
          //   Icons.double_arrow,
          //   color: Colors.blue,
          //   size: 16,
          // ),
        ],
      ),
    );
  }
}
