class ChatUser {
  String? image;
  String? createdAt;
  String? lastActive;
  String? name;
  String? about;
  bool? isOnline;
  String? id;
  String? pushToken;
  String? email;

  ChatUser(
      {this.image,
      this.createdAt,
      this.lastActive,
      this.name,
      this.about,
      this.isOnline,
      this.id,
      this.pushToken,
      this.email});

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? 'Null Data';
    createdAt = json['createdAt'] ?? 'Null Data';
    lastActive = json['lastActive'] ?? 'Null Data';
    name = json['name'] ?? 'Null Data';
    about = json['about'] ?? 'Null Data';
    isOnline = json['isOnline'] ?? 'Null Data';
    id = json['id'] ?? 'Null Data';
    pushToken = json['pushToken'] ?? 'Null Data';
    email = json['email'] ?? 'Null Data';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    data['lastActive'] = this.lastActive;
    data['name'] = this.name;
    data['about'] = this.about;
    data['isOnline'] = this.isOnline;
    data['id'] = this.id;
    data['pushToken'] = this.pushToken;
    data['email'] = this.email;
    return data;
  }
}
