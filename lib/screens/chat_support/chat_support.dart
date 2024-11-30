import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forpartum_adminpanel/screens/chat_support/right_side.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../constant.dart';
import '../../model/chat/chatMOdel.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/constant/app_assets.dart';
import '../../model/res/constant/app_colors.dart';
import '../../model/res/constant/app_icons.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../provider/chat/chatProvider.dart';
import '../../provider/dropDOwn/dropdown.dart';

class ChatSupportScreen extends StatelessWidget {
   ChatSupportScreen({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dropdownProvider = Provider.of<DropdownProvider>(context);
    final provider = Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: const Color(0xffFFFAF9),
        appBar: const CustomAppbar(text: 'Dashboard'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextWidget(
                      text: 'Chats',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 4.0, bottom: 8.0, left: 1.w, right: 3.w),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Left Sidebar (Contact List)
                      buildLeftSide(),
                      // Main Chat Window
                     Container(
                         width: 59.1.w,
                             height: 70.h,
                             color: Colors.white,
                         child: RightSideMessage())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Container buildLeftSide() {
    return Container(
      height: 70.h,
      width: 20.w,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
        border:
            Border(right: BorderSide(color: Colors.grey.shade300, width: 1)),
        color: Colors.white,
      ),
      child: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          return StreamBuilder<List<ChatRoomModel>>(
            stream: chatProvider.getChatRoomsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No chats available'));
              }
              var chatRooms = snapshot.data!;
              return ListView.separated(
                itemCount: chatRooms.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final chatRoom = chatRooms[index];
                  var lastMessage = chatRoom.lastMessage;
                  final otherUserEmail = chatRoom.users
                      .firstWhere((user) => user != getCurrentUid());
                  final otherUser = chatProvider.users.firstWhere(
                    (user) => user.email == otherUserEmail,
                    orElse: () => UserChatModel(
                      uid: '',
                      name: 'Unknown',
                      email: otherUserEmail,
                    ),
                  );
                  log('Error loading image for ${otherUser.name}: ${otherUser.image}');

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:  otherUser.image.toString().isNotEmpty
                          ? NetworkImage(otherUser.image.toString()) as ImageProvider
                          : const AssetImage(AppAssets.person),
                    ),

                    title: AppTextWidget(
                      text: otherUser.name,
                      fontSize: 14.0,
                      textAlign: TextAlign.start,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    // title: Text(otherUserEmail),
                    subtitle: AppTextWidget(
                      text: lastMessage,
                      fontSize: 12.0,
                      color: Colors.black,
                      textAlign: TextAlign.start,
                    ),
                    trailing: chatRoom.isMessage == getCurrentUid() &&
                            chatRoom.isMessage != "seen"
                        ? const CircleAvatar(
                            radius: 7,
                            backgroundColor: primaryColor,
                          )
                        : null,
                    onTap: () async {
                      final chatRoomId = await Provider.of<ChatProvider>(
                              context,
                              listen: false)
                          .getChatRoom(otherUserEmail, "");

                      var provide =
                          Provider.of<ChatProvider>(context, listen: false);
                      log("Chat Room ID:: $chatRoomId");
                      provide.getMessages(chatRoomId.toString());
                      provide.getSingleUserChat(chatRoomId.toString());
                      final selectedChatRoom = chatRooms[index];
                      provide.setSelectedChatRoom(selectedChatRoom, otherUserEmail);

                      provide.setResponse(
                        chatRoomId: chatRoomId.toString(),
                        otherUserEmail: otherUserEmail,
                      );
                      chatProvider.setSelectedUser(
                        userId: otherUser.uid,
                        name: otherUser.name,
                        image: otherUser.image!,
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: primaryColor,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // Container buildRightSide(BuildContext context, ChatProvider provider) {
  //   return Container(
  //     width: 59.1.w,
  //     height: 70.h,
  //     color: Colors.white,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         _buildChatHeader('Emily Kelly', 'Active 50min ago'),
  //         Divider(
  //           color: Colors.grey.shade300,
  //           thickness: 1,
  //         ),
  //         Flexible(
  //           child: Container(
  //             margin: EdgeInsets.only(
  //               top: 15.w,
  //             ),
  //             padding: EdgeInsets.only(
  //               top: 5.w,
  //             ),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                 topRight: Radius.circular(12.w),
  //                 topLeft: Radius.circular(12.w),
  //               ),
  //             ),
  //             child: StreamBuilder(
  //               stream: Provider.of<ChatProvider>(context,listen: false).getMessages(
  //                   provider.chatRoomId.isNotEmpty
  //                       ? provider.chatRoomId
  //                       : "ss"),
  //               builder: (context, snapshot) {
  //                 if (snapshot.connectionState == ConnectionState.waiting) {
  //                   return const Center(child: CircularProgressIndicator());
  //                 }
  //                 if (snapshot.hasError) {
  //                   return Center(child: Text('Error: ${snapshot.error}'));
  //                 }
  //                 if (!snapshot.hasData) {
  //                   log("no");
  //                   return const Center(
  //                       child: Text(
  //                         'No chat history Found',
  //                         style: TextStyle(color: Colors.black),
  //                       ));
  //                 }
  //                 provider.markMessageAsRead(provider.chatRoomId);
  //                 provider.updateDeliveryStatus(provider.chatRoomId);
  //                 final messages = snapshot.data!.docs;
  //                 List<Widget> messageWidgets = [];
  //                 for (var message in messages) {
  //                   final messageText = message["text"];
  //                   final messageSender = message["sender"];
  //                   final messageTimestamp = message["timestamp"];
  //                   final isDelivered = message["delivered"];
  //                   final type = message["type"];
  //                   final documentId = message.id.toString();
  //
  //                   final relativeTime = messageTimestamp != null
  //                       ? timeago.format(messageTimestamp.toDate())
  //                       : '';
  //                   // return ListView
  //                   final isCurrentUser = messageSender == getCurrentUid();
  //
  //                   final messageWidget = Align(
  //                     alignment: isCurrentUser
  //                         ? Alignment.centerRight
  //                         : Alignment.centerLeft,
  //                     child: Column(
  //                       mainAxisAlignment: isCurrentUser
  //                           ? MainAxisAlignment.end
  //                           : MainAxisAlignment.start,
  //                       crossAxisAlignment: isCurrentUser
  //                           ? CrossAxisAlignment.end
  //                           : CrossAxisAlignment.start,
  //                       children: [
  //                         Container(
  //                           decoration: BoxDecoration(
  //                             color: type == "image"
  //                                 ? Colors.transparent
  //                                 : isCurrentUser
  //                                 ? primaryColor
  //                                 : Colors.white,
  //                             borderRadius: BorderRadius.circular(10),
  //                           ),
  //                           padding: const EdgeInsets.all(10),
  //                           margin: const EdgeInsets.symmetric(
  //                               vertical: 5, horizontal: 10),
  //                           child: Column(
  //                             crossAxisAlignment: isCurrentUser
  //                                 ? CrossAxisAlignment.end
  //                                 : CrossAxisAlignment.start,
  //                             children: [
  //                               type == "text"
  //                                   ? Text(
  //                                 messageText,
  //                                 style: TextStyle(
  //                                     color: isCurrentUser
  //                                         ? Colors.red
  //                                         : Colors.black),
  //                               )
  //                                   : type == "image"
  //                                   ? Image.network(
  //                                 message['url']!.toString(),
  //                                 width: 200.0,
  //                                 height: 200.0,
  //                                 fit: BoxFit.cover,
  //                               )
  //                                   : type == "voice"
  //                                   ? SizedBox(
  //                                 width: Get.width * 0.54,
  //                                 child: const ListTile(
  //                                   title: Text("Voice Message"),
  //                                   // trailing: PlayButton(
  //                                   //     audioUrl: message['url']),
  //                                 ),
  //                               )
  //                                   : const SizedBox.shrink(),
  //                               const SizedBox(height: 3),
  //                               Row(
  //                                 mainAxisSize: MainAxisSize.min,
  //                                 children: [
  //                                   Text(
  //                                     relativeTime,
  //                                     style: TextStyle(
  //                                       color: type == "image"
  //                                           ? Colors.black
  //                                           : isCurrentUser
  //                                           ? Colors.white70
  //                                           : Colors.grey,
  //                                       fontSize: 10,
  //                                     ),
  //                                   ),
  //                                   if (isCurrentUser) ...[
  //                                     const SizedBox(width: 5),
  //                                     Icon(
  //                                       message["read"]
  //                                           ? Icons.done_all
  //                                           : Icons.done,
  //                                       color: type == "image"
  //                                           ? Colors.black
  //                                           : message["read"]
  //                                           ? Colors.white
  //                                           : Colors.white70,
  //                                       size: 12,
  //                                     ),
  //                                   ],
  //                                 ],
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         if (isCurrentUser)
  //                           Container(
  //                               margin:
  //                               const EdgeInsets.symmetric(horizontal: 10),
  //                               child: AppTextWidget(
  //                                   text: isDelivered ? "seen" : "deliver",
  //                                   fontSize: 12.0))
  //                       ],
  //                     ),
  //                   );
  //                   messageWidgets.add(messageWidget);
  //                 }
  //                 return ListView(
  //                   reverse: true,
  //                   children: messageWidgets,
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //         _buildMessageInput(context,provider.chatRoomId,'other user email'),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildChatHeader(String name, String status) {
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
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    AppAssets.yoga,
                    fit: BoxFit.cover,
                  ),
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
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w700),
              AppTextWidget(
                  text: status,
                  fontSize: 10,
                  textAlign: TextAlign.start,
                  color: Colors.black,
                  fontWeight: FontWeight.w300),
            ],
          ),
          const Spacer(),
          Image.asset(AppIcons.menu),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
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
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: IconButton(
                icon: const Icon(Icons.sentiment_satisfied_alt_outlined),
                onPressed: () {}),
          ),
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
        ],
      ),
    );
  }
}
