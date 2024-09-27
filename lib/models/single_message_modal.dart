// class SingleMessageModal {
//   String message;
//   DateTime time;
//   bool sentByMe;
//   SingleMessageModal({
//     required this.message,
//     required this.time,
//     required this.sentByMe,
//   });
// }
class SingleMessageModal {
  String? message;
  String? sentTime;
  String? readTime;
  String? receiverId;
  String? senderId;
  String? type;
  String? docId;
  String? conversationId;

  SingleMessageModal({
    this.message,
    this.sentTime,
    this.readTime,
    this.receiverId,
    this.senderId,
    this.type,
    this.docId,
    this.conversationId,
  });

  SingleMessageModal.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    sentTime = json['sentTime'];
    readTime = json['readTime'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    type = json['type'];
    docId = json['docId'];
    conversationId = json['conversationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['sentTime'] = this.sentTime;
    data['readTime'] = this.readTime;
    data['receiverId'] = this.receiverId;
    data['senderId'] = this.senderId;
    data['type'] = this.type;
    data['docId'] = this.docId;
    data['conversationId'] = this.conversationId;
    return data;
  }
}
