import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/models/single_message_modal.dart';
import 'package:chatapplication/models/time_formatter_modal.dart';
import 'package:chatapplication/utils/constants.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:chatapplication/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

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
                            text: message.message ??
                                'Error in copying the message'))
                        .then((value) {
                      Navigator.pop(context);

                      Utils.showSnackBar(
                          context, 'Message copied successfully!');
                    });
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
                    FirebaseInstances.deleteMessage(message).then((value) {
                      Navigator.pop(context);
                    });
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
                      'Sent at ${TimeFormatterModal.formatTimeForSentAndReadMessage(message.sentTime.toString(), context)}',
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: primaryColor,
                  ),
                ),
                // read at
                MessageOption(
                  title: message.readTime!.isEmpty
                      ? 'Not Read Yet'
                      : 'Read at ${TimeFormatterModal.formatTimeForSentAndReadMessage(message.readTime.toString(), context)}',
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.green,
                  ),
                ),
                if (message.type == 'image')
                  InkWell(
                    onTap: () async {
                      // we're using http because we have to give the image in Uint8List format to the ImageGallerSaver
                      //  we can't do that with the image address which we've in message.message.toString
                      // so we're using http package.
                      try {
                        // Fetch the image from the network
                        final response = await http
                            .get(Uri.parse(message.message.toString()));
                        // Check if the response is successful
                        if (response.statusCode == 200) {
                          print('if state of response');
                          // Return the body of the response as Uint8List
                          await ImageGallerySaver.saveImage(response.bodyBytes);

                          Navigator.pop(context);
                          Utils.showSnackBar(
                              context, 'Image saved successfully.');
                        } else {
                          print('else state of response');
                          Navigator.pop(context);
                          Utils.showSnackBar(context,
                              'An error occurred while saving the image. ');
                        }
                      } catch (e) {
                        Utils.showSnackBar(context,
                            'An error occurred while saving the image. ');
                      }
                    },
                    // onTap: () async {
                    //
                    //   await ImageGallerySaver.saveFile(
                    //           message.message.toString())
                    //       .then((success) {
                    //     Navigator.pop(context);
                    //     print('success: ' + success);
                    //   });
                    // },
                    // onTap: () async {
                    //   try {
                    //     await ImageGallerySaver.saveFile(
                    //             message.message.toString())
                    //         .then((success) {
                    //       Navigator.pop(context);
                    //       if (success != null && success) {
                    //         Utils.showSnackBar(
                    //             context, 'Image saved successfully!');
                    //       }
                    //     });
                    //   } catch (e) {
                    //     print('Error while download image: ' + e.toString());
                    //     Utils.showSnackBar(context,
                    //         'An error occured while downloading the image. ');
                    //   }
                    // },
                    child: MessageOption(
                      title: 'Save Image',
                      icon: Icon(
                        Icons.download,
                        color: Colors.green,
                      ),
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
                          message, _editController.text.toString())
                      .then((value) {
                    Navigator.pop(context);
                  });
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
