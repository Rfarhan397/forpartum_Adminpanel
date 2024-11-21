import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forpartum_adminpanel/model/res/constant/app_assets.dart';
import 'package:intl/intl.dart';

class ChatRoomModel {
  final String id;
  final List<String> users;
  final String lastMessage;
  final String isMessage;
  final DateTime lastTimestamp;
  int unreadMessageCount;

  ChatRoomModel({
    required this.id,
    required this.users,
    required this.lastMessage,
    required this.isMessage,
    required this.lastTimestamp,
    this.unreadMessageCount = 0,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> data, String id) {
    return ChatRoomModel(
      id: id,
      users: List<String>.from(data['users']),
      lastMessage: data['lastMessage'] ?? '',
      isMessage: data['isMessage'] ?? '',
      lastTimestamp: (data['lastTimestamp'] as Timestamp?)?.toDate() ?? DateTime.now(), // Provide a default date
      unreadMessageCount: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'users': users,
      'lastMessage': lastMessage,
      'lastTimestamp': lastTimestamp,
      'isMessage': isMessage,
    };
  }
}



class UserChatModel {
  final String uid;
  final String name;
  final String email;
  final String? image;

  UserChatModel({
    required this.uid,
    required this.name,
    required this.email,
     this.image,
  });

  factory UserChatModel.fromMap(Map<String, dynamic> map) {
    return UserChatModel(
      uid: map['uid'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      image: map['imageUrl'] ?? "",
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $uid, name: $name, email: $email, image:$image}';
  }
}
