import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/models/single_message_modal.dart';
import 'package:chatapplication/models/time_formatter_modal.dart';
import 'package:chatapplication/utils/constants.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SingleMessage extends StatelessWidget {
  SingleMessage({super.key, required this.singleMessage});

  SingleMessageModal singleMessage;

  showMessageOptions(BuildContext context, SingleMessageModal message) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // copy message
                InkWell(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(
                        text:
                            message.message ?? 'Error in copying the message'));
                    Navigator.pop(context);
                  },
                  child: MessageOption(
                    title: 'Copy Text',
                    icon: Icon(
                      Icons.copy_all_rounded,
                      color: primaryColor,
                    ),
                  ),
                ),
                Divider(),
                // edit message
                InkWell(
                  onTap: () {
                    Navigator.pop(context);

                    showEditMessageDialog(context, message);
                  },
                  child: MessageOption(
                    title: 'Edit Message',
                    icon: Icon(
                      Icons.edit,
                      color: primaryColor,
                    ),
                  ),
                ),
                // delete message
                InkWell(
                  onTap: () {
                    FirebaseInstances.deleteMessage(message);
                    Navigator.pop(context);
                  },
                  child: MessageOption(
                    title: 'Delete Message',
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
                Divider(),
                // sent at
                MessageOption(
                  title:
                      'Sent at ${TimeFormatterModal.format(message.sentTime.toString(), context)}',
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: primaryColor,
                  ),
                ),
                // read at
                MessageOption(
                  title: message.readTime!.isEmpty
                      ? 'Not Read Yet'
                      : 'Read at ${TimeFormatterModal.format(message.readTime.toString(), context)}',
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          );
        });
  }

  showEditMessageDialog(BuildContext context, SingleMessageModal message) {
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController _editController = TextEditingController();
          _editController.text = message.message ?? '';
          return AlertDialog(
            title: Text('Edit Message'),
            content: TextField(
              controller: _editController,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseInstances.editMessage(
                      message, _editController.text.toString());
                  Navigator.pop(context);
                },
                child: Text('Edit'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return singleMessage.senderId == FirebaseInstances.auth.currentUser!.uid
        ? SenderMessage(context)
        : ReceiverMessage(context);
    return InkWell(
      onTap: showMessageOptions(
        context,
        singleMessage,
      ),
      child: singleMessage.senderId == FirebaseInstances.auth.currentUser!.uid
          ? SenderMessage(context)
          : ReceiverMessage(context),
    );
  }

  Widget SenderMessage(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onLongPress: () {
        showMessageOptions(
          context,
          singleMessage,
        );
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

class MessageOption extends StatelessWidget {
  MessageOption({
    super.key,
    required this.title,
    required this.icon,
  });

  String title;
  Widget icon;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.0175,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(
            width: width * 0.025,
          ),
          Text(
            title,
          ),
        ],
      ),
    );
  }
}
