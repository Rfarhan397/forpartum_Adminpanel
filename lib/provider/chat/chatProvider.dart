import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../constant.dart';
import '../../model/chat/chatMOdel.dart';

class ChatProvider extends ChangeNotifier{

  List<ChatRoomModel> _chatRooms = [];
  Map<String, int> _unreadMessageCounts = {};

  List<ChatRoomModel> get chatRooms => _chatRooms;

  Map<String, int> get unreadMessageCounts => _unreadMessageCounts;

  ChatProvider(){
    _loadUsers();
    _loadChatRooms();
  }


  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<String> createOrGetChatRoom(String otherUserEmail,String lastMessage) async {
    final currentUserEmail = getCurrentUid().toString();
    final chatRoomId = _getChatRoomId(currentUserEmail, otherUserEmail);

    final chatRoomDoc = FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId);
    final chatRoomSnapshot = await chatRoomDoc.get();

    if (!chatRoomSnapshot.exists) {
      await chatRoomDoc.set({
        'users': [currentUserEmail, otherUserEmail],
        'lastMessage': lastMessage,
        'isMessage': getCurrentUid().toString(),
        'lastTimestamp': FieldValue.serverTimestamp(),
        'userStatus': "active",
      });
    }
    return chatRoomId;
  }

  Future<void> updateMessageStatus(String chatRoomID) async{
    log("message ${chatRoomID} : run");
    await FirebaseFirestore.instance.collection("chatRooms").doc(chatRoomID).update({"isMessage" : "seen"});
  }

  Future<void> markMessageAsRead(String chatRoomId) async {
    final currentUserEmail = getCurrentUid().toString();
    final messageDocs = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('sender', isNotEqualTo: currentUserEmail)
        .get();

    for (var doc in messageDocs.docs) {
      if (!(doc['read'] as bool)) {
        await doc.reference.update({'read': true});
      }
    }
    await _loadChatRooms();
  }

  Future<void> updateDeliveryStatus(String chatRoomId) async {
    final currentUserEmail = getCurrentUid().toString();
    final messageDocs = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('sender', isNotEqualTo: currentUserEmail)
        .get();

    for (var doc in messageDocs.docs) {
      if (!(doc['delivered'] as bool)) {
        await doc.reference.update({'delivered': true});
      }
    }
  }

  Future<void> _loadChatRooms() async {
    log("Chat Room Load");
    final currentUserEmail = getCurrentUid().toString();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .where('users', arrayContains: currentUserEmail)
        .get();

    final chatRooms = snapshot.docs.map((doc) {
      return ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    await Future.wait(chatRooms.map((chatRoom) async {
      chatRoom.unreadMessageCount = await getUnreadMessageCount(chatRoom.id);
      _unreadMessageCounts[chatRoom.id] = chatRoom.unreadMessageCount;
    }));

    _chatRooms = chatRooms;
    notifyListeners();
  }


  Future<void> sendMessage({required String chatRoomId,required String message,
    required String otherEmail,required String type}) async {
    final currentUserEmail = getCurrentUid().toString();
    final newMessage = {
      'text': message,
      'sender': currentUserEmail,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
      'delivered': false,
      'type': type, // Include type in the message data
    };
    await FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).collection('messages').add(newMessage);
    await FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage': message,
      'isMessage': otherEmail,
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<int> getUnreadMessageCount(String chatRoomId) async {
    final currentUserEmail = getCurrentUid().toString();
    final messagesSnapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('read', isEqualTo: false)
        .where('sender', isNotEqualTo: currentUserEmail)
        .get();

    return messagesSnapshot.docs.length;
  }

  String _getChatRoomId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode
        ? '$user1-$user2'
        : '$user2-$user1';
  }
  Stream<List<ChatRoomModel>> getChatRoomsStream() {
    final currentUserEmail = getCurrentUid();
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .where('users', arrayContains: currentUserEmail)
        .snapshots()
        .asyncMap((snapshot) async {
      final chatRooms = snapshot.docs.map((doc) {
        final chatRoom = ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        chatRoom.unreadMessageCount = _unreadMessageCounts[chatRoom.id] ?? 0;
        return chatRoom;
      }).toList();
      return chatRooms;
    });
  }
  List<UserChatModel> _users = [];

  List<UserChatModel> get users => _users;

  Future<void> _loadUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
    _users = snapshot.docs
        .map((doc) => UserChatModel(
      uid: doc['uid'] ?? "",
      name: doc['name'] ?? "",
      email: doc['email'] ?? "",
       image: doc['imageUrl'] ?? "",
    ))
        .toList();
    notifyListeners();
  }
  String _chatRoomId = "admin@gmail.com";
  String _otherUserEmail = "";

  String get chatRoomId => _chatRoomId;
  String get otherUserEmail => _otherUserEmail;

  void setResponse({required String chatRoomId,required String otherUserEmail}){
    _chatRoomId = chatRoomId;
    _otherUserEmail = otherUserEmail;
    notifyListeners();
  }


  ChatRoomModel? _selectedChatRoom;
  String? _selectedUserEmail;
  ChatRoomModel? get selectedChatRoom => _selectedChatRoom;
  String? get selectedUserEmail => _selectedUserEmail;
  void setSelectedChatRoom(ChatRoomModel chatRoom, String userEmail) {
    _selectedChatRoom = chatRoom;
    _selectedUserEmail = userEmail;
    notifyListeners(); // Notify consumers about the change
  }
}