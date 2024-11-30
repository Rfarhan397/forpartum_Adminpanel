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

  Stream<List<Map<String,dynamic>>>? _messagesStream;
  Stream<List<Map<String,dynamic>>>? get messagesStream => _messagesStream;



  Map<String, int> get unreadMessageCounts => _unreadMessageCounts;

  String? _singleUserId;


  String? get singleUserId => _singleUserId;

  ChatProvider(){
    loadUsers();
    _loadChatRooms();
  }


  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    log("Message Get Chat Room $chatRoomId");
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<List<Map<String, dynamic>>>? getSingleUserChat(String userID) {
    _singleUserId = userID;
    log('User ID in getSingleUserChat is: $userID');
    _messagesStream = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(userID)
        .collection('messages') // Removed `.doc()` to target all documents
        // .orderBy('timestamp', descending: true) // Ensure `timestamp` exists in all documents
        .snapshots()
        .map((snapshot) {
      // Log snapshot metadata
      int totalDocuments = snapshot.docs.length; // Count total documents
      for (var doc in snapshot.docs) {
        log('Document data: ${doc.data()}');
      }
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        log('Mapped data: $data');
        return data;
      }).toList();
    });

    return _messagesStream;
  }









  //to get the user name,image
  String? selectedUserId;
  String? selectedUserName;
  String? selectedUserImage;

  void setSelectedUser({required String userId, required String name, required String image}) {
    selectedUserId = userId;
    selectedUserName = name;
    selectedUserImage = image;
    notifyListeners();
  }




  Future<String?> getChatRoom(String otherUserEmail,String lastMessage) async {
    log("otherUserEmail : $otherUserEmail");
    final currentUserEmail = getCurrentUid().toString();
    final chatRoomId = _getChatRoomId( otherUserEmail,currentUserEmail);

    final chatRoomDoc = FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId);
    final chatRoomSnapshot = await chatRoomDoc.get();

    if (chatRoomSnapshot.exists) {
      await chatRoomDoc.set({
        'users': [otherUserEmail,currentUserEmail],
        'lastMessage': lastMessage,
        'isMessage': getCurrentUid().toString(),
        'lastTimestamp': FieldValue.serverTimestamp(),
        'userStatus': "active",
      });      return chatRoomId;
    }

    // Chat room does not exist
    return chatRoomId; // Or throw an error if needed
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
    return user2.hashCode <= user1.hashCode
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

  Future<void> loadUsers() async {
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
  String _chatRoomId = "";
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