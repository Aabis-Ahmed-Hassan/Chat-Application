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
  String? receivedTime;
  String? receiverId;
  String? senderId;
  String? type;

  SingleMessageModal(
      {this.message,
      this.sentTime,
      this.receivedTime,
      this.receiverId,
      this.senderId,
      this.type});

  SingleMessageModal.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    sentTime = json['sentTime'];
    receivedTime = json['receivedTime'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['sentTime'] = this.sentTime;
    data['receivedTime'] = this.receivedTime;
    data['receiverId'] = this.receiverId;
    data['senderId'] = this.senderId;
    data['type'] = this.type;
    return data;
  }
}
