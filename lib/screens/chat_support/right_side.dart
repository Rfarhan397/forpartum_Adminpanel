import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../model/res/constant/app_assets.dart';
import '../../model/res/constant/app_icons.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../provider/chat/chatProvider.dart';
import 'package:timeago/timeago.dart' as timeago;



class RightSideMessage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<ChatProvider>(context);


    final selectedUserId =
        Provider.of<ChatProvider>(context).singleUserId;

    final messagesStream = Provider.of<ChatProvider>(context).messagesStream;
    final chatProvider = Provider.of<ChatProvider>(context);
    final selectedUserName = chatProvider.selectedUserName ?? 'Unknown';
    final selectedUserImage = chatProvider.selectedUserImage;
    final selectedChatRoom = chatProvider.selectedChatRoom;
    if (selectedUserId == null) {
      log('No user selected, returning fallback UI');
      return Center(
        child: Text('Select a user to start chatting'),
      );
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: messagesStream,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if ( !snapshot.hasData) {
          return Center(child: Text('Failed to load messages.'));
        }

        final messages = snapshot.data!;
        log('load messages $messages');

        return Column(
          children: [
            // Text('Chat with User $selectedUserId'),
                    _buildChatHeader(selectedUserName,selectedUserImage,selectedChatRoom),
        Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  log('messagesss ${message['text']}');
                  final messageSender = message['sender']?? '';
                                    final type = message["type"];

                  final isCurrentUser = messageSender == getCurrentUid();
                                    final messageTimestamp = message["timestamp"];
                  final relativeTime = messageTimestamp != null
                      ? timeago.format(messageTimestamp.toDate())
                      : '';
                  final isDelivered = message["delivered"];

                  return Align(
                    alignment: isCurrentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: isCurrentUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: isCurrentUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: type == "image"
                                ? Colors.transparent
                                : isCurrentUser
                                ? primaryColor
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              type == "text"
                                  ? Text(
                                message['text'],
                                style: TextStyle(
                                    color: isCurrentUser
                                        ? Colors.white
                                        : Colors.black),
                              )
                                  : type == "image"
                                  ? Image.network(
                                message['url']!.toString(),
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              )
                                  : type == "voice"
                                  ? SizedBox(
                                width: Get.width * 0.54,
                                child: const ListTile(
                                  title: Text("Voice Message"),
                                  // trailing: PlayButton(
                                  //     audioUrl: message['url']),
                                ),
                              )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    relativeTime,
                                    style: TextStyle(
                                      color: type == "image"
                                          ? Colors.black
                                          : isCurrentUser
                                          ? Colors.white70
                                          : Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                  if (isCurrentUser) ...[
                                    const SizedBox(width: 5),
                                    Icon(
                                      message["read"]
                                          ? Icons.done_all
                                          : Icons.done,
                                      color: type == "image"
                                          ? Colors.black
                                          : message["read"]
                                          ? Colors.white
                                          : Colors.white70,
                                      size: 12,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isCurrentUser)
                          Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 10),
                              child: AppTextWidget(
                                  text: isDelivered ? "seen" : "deliver",
                                  fontSize: 12.0))
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildMessageInput(context,selectedChatRoom!.id,selectedUserId),

          ],
        );
      },
    );
  }
  Widget _buildMessageInput(context,chatRoomId,otherUserEmail) {
    final provider = Provider.of<ChatProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (value) async{
                if (_controller.text.isNotEmpty) {
                  await provider.sendMessage(
                    chatRoomId: chatRoomId,
                    message: _controller.text,
                    otherEmail: otherUserEmail,
                    type: 'text',
                  );
                  _controller.clear();
                }
              },
              decoration: InputDecoration(
                hintText: 'Start typing here',
                hintStyle: const TextStyle(
                  fontSize: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                )),
            child: InkWell(
              onTap: () async {
                await provider.sendMessage(
                    chatRoomId: chatRoomId,
                    message: _controller.text,
                    otherEmail: otherUserEmail,
                    type: 'text',
                );
                _controller.clear();
              },
              child: Container(
                  height: 30,
                  width: 40,
                  decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(20), right: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset('assets/icons/share.svg'),
                  )),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildChatHeader(String name,image,selectedChatRoom) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  color: primaryColor
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: image.toString().isEmpty ?Image.asset(
                    AppAssets.person,
                    fit: BoxFit.cover,
                  ): Image.network(image,fit: BoxFit.cover,)
                ),
              ),
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
          SizedBox(width: 1.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget(
                  text: name,
                  fontSize: 14,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w700),
              // AppTextWidget(
              //     text: status,
              //     fontSize: 10,
              //     textAlign: TextAlign.start,
              //     color: Colors.black,
              //     fontWeight: FontWeight.w300),
            ],
          ),
          const Spacer(),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, size: 24.0, color: primaryColor),
            color: primaryColor,
            itemBuilder: (context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem(
                  onTap: () => deleteChat(selectedChatRoom.id),
                  child: SizedBox(
                    width: 30.sp,
                    child: AppTextWidget(
                      text: "Delete Chat",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: whiteColor,
                    ),
                  ),
                ),
              ];
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
  Future<void> deleteChat(String id) async {
    try {
      // Reference to the messages subcollection
      final messagesCollection = FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(id)
          .collection('messages');

      // Get all documents in the messages subcollection
      final messagesSnapshot = await messagesCollection.get();

      // Use batch writes to delete messages in chunks
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var doc in messagesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Commit the batch
      await batch.commit();

      // Delete the chat room document after deleting all messages
      await FirebaseFirestore.instance.collection("chatRooms").doc(id).delete();

      // Close the screen after deletion
      Get.back();
    } catch (e) {
      print('Error deleting chat: $e');
    }
  }


}