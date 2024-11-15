import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  const ChatSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dropdownProvider = Provider.of<DropdownProvider>(context);
    final provider = Provider.of<ChatProvider>(context,listen: false);
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppTextWidget(
                      text: 'Chats',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    DropdownButton<String>(
                      value: dropdownProvider.selectedValue,
                      items: <String>[
                        'Last 30 Days',
                        'Last 10 Days',
                        'Yesterday'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: AppTextWidget(text: value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          dropdownProvider.setSelectedValue(newValue);
                        }
                      },
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
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
                      Container(
                        height: 70.h,
                          width: 20.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
                            border: Border(
                              right: BorderSide
                                (color: Colors.grey.shade300, width: 1
                              )
                            ),
                            color: Colors.white,
                          ),
                        child: Consumer<ChatProvider>(
                          builder: (context, chatProvider, _) {
                            return StreamBuilder<List<ChatRoomModel>>(
                              stream: chatProvider.getChatRoomsStream(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const  Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const  Center(
                                    child: Text('No chats available'),
                                  );
                                }
                                var chatRooms = snapshot.data!;
                                return ListView.separated(
                                  itemCount: snapshot.data!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final chatRoom = chatRooms[index];
                                    final unreadCount =  chatProvider.unreadMessageCounts[chatRoom.id] ?? 0;
                                    var otherUserEmail = chatRoom.users.firstWhere((user) => user != getCurrentUid());
                                    var lastMessage = chatRoom.lastMessage;
                                    // var timeStamp = chatRoom[index].lastTimestamp;


                                    log("message $unreadCount");
                                    // final relativeTime = timeStamp != null
                                    //     ? timeago.format(timeStamp.toDate())
                                    //     : '';

                                    log("message ${chatProvider.users.firstWhere(
                                            (user) => user.email == otherUserEmail,
                                        orElse: () => UserChatModel(uid: '', name: 'Unknown', email: otherUserEmail))}");

                                    // Retrieve user information from ChatProvider
                                    var otherUser =  chatProvider.users.firstWhere(
                                          (user) => user.email == otherUserEmail,
                                      orElse: () => UserChatModel(uid: '', name: 'Unknown', email: otherUserEmail), // Default user
                                    );

                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: AssetImage(AppAssets.person), // Assuming image is a URL
                                      ),
                                      title: AppTextWidget(
                                        text: otherUser.name,
                                        fontSize: 14.0,
                                        textAlign: TextAlign.start,
                                        color: Colors.black,fontWeight: FontWeight.bold,),
                                      // title: Text(otherUserEmail),
                                      subtitle: AppTextWidget(
                                        text: lastMessage.toString(),
                                        fontSize: 12.0,color: Colors.black,
                                        textAlign: TextAlign.start,
                                      ),
                                      trailing: chatRoom.isMessage == getCurrentUid() && chatRoom.isMessage !="seen"
                                          ? const CircleAvatar(
                                        radius: 7,
                                        backgroundColor: primaryColor,
                                      )
                                          : null,
                                      onTap: () async{
                                        final chatRoomId = await context.read<ChatProvider>().createOrGetChatRoom(otherUser.email,"");
                                        Provider.of<ChatProvider>(context,listen: false).updateMessageStatus(chatRoomId);
                                        Provider.of<ChatProvider>(context,listen: false).setResponse(
                                            chatRoomId: chatRoomId,
                                            otherUserEmail: otherUserEmail
                                        );


                                        log("User:: $otherUserEmail");


                                        //Get.to(ChatScreen());
                                        await chatProvider.getUnreadMessageCount(chatRoom.id);

                                        // await chatProvider.getCollectionLength(chatRoom.id);
                                        // log('get Messages ${chatProvider.collectionLength}');

                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      color: Colors.black,
                                    );
                                  },
                                );

                              },
                            );
                          },
                        ),
                      ),
                      // Container(
                      //   height: 70.h,
                      //   width: 20.w,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
                      //     border: Border(
                      //       right: BorderSide
                      //         (color: Colors.grey.shade300, width: 1
                      //       )
                      //     ),
                      //     color: Colors.white,
                      //   ),
                      //   child: ListView.builder(
                      //     itemBuilder: (context, index) {
                      //       return Column(
                      //         children: [
                      //           _buildContactItem(
                      //               primaryColor,
                      //               'Emily Kelly',
                      //               'Newly Postpartum',
                      //               '3 min ago',
                      //               'assets/profile1.png'),
                      //           Divider(
                      //             color: Colors.grey.shade300,
                      //             thickness: 1,
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //     shrinkWrap: true,
                      //     scrollDirection: Axis.vertical,
                      //   ),
                      // ),

                      // Main Chat Window
                      Container(
                        width: 59.1.w,
                        height: 70.h,
                        color: Colors.white,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildChatHeader('Emily Kelly', 'Active 50min ago'),
                            Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 15.w,
                                ),
                                padding: EdgeInsets.only(
                                  top: 5.w,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12.w),
                                    topLeft: Radius.circular(12.w),
                                  ),
                                ),
                                child: StreamBuilder(
                                  stream: context.read<ChatProvider>().getMessages(provider.chatRoomId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Center(child: Text('Error: ${snapshot.error}'));
                                    }
                                    if (!snapshot.hasData) {
                                      log("no");
                                      return const Center(child: Text('No chat history found'));
                                    }
                                    provider.markMessageAsRead(provider.chatRoomId);
                                    provider.updateDeliveryStatus(provider.chatRoomId);
                                    final messages = snapshot.data!.docs;
                                    List<Widget> messageWidgets = [];
                                    for (var message in messages) {
                                      final messageText = message["text"];
                                      final messageSender = message["sender"];
                                      final messageTimestamp = message["timestamp"];
                                      final isDelivered = message["delivered"];
                                      final type = message["type"];
                                      final documentId = message.id.toString();

                                      final relativeTime = messageTimestamp != null
                                          ? timeago.format(
                                          messageTimestamp.toDate())
                                          : '';
                                      // return ListView
                                      final isCurrentUser = messageSender == getCurrentUid();

                                      final messageWidget = Align(
                                        alignment: isCurrentUser ? Alignment
                                            .centerRight : Alignment.centerLeft,
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
                                                color: type == "image" ? Colors
                                                    .transparent : isCurrentUser
                                                    ? primaryColor
                                                    : Colors.white,
                                                borderRadius: BorderRadius
                                                    .circular(10),
                                              ),
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              child: Column(
                                                crossAxisAlignment: isCurrentUser
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                                children: [
                                                  type == "text" ?
                                                  Text(
                                                    messageText,
                                                    style: TextStyle(
                                                        color: isCurrentUser
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ) :
                                                  type == "image" ?
                                                  Image.network(
                                                    message['url']!.toString(),
                                                    width: 200.0,
                                                    height: 200.0,
                                                    fit: BoxFit.cover,)
                                                      : type == "voice" ?
                                                  SizedBox(
                                                    width: Get.width * 0.54,
                                                    child: const ListTile(
                                                      title: Text(
                                                          "Voice Message"),
                                                      // trailing: PlayButton(
                                                      //     audioUrl: message['url']),
                                                    ),
                                                  )

                                                      : const SizedBox.shrink(),
                                                  const SizedBox(height: 3),
                                                  Row(
                                                    mainAxisSize: MainAxisSize
                                                        .min,
                                                    children: [
                                                      Text(
                                                        relativeTime,
                                                        style: TextStyle(
                                                          color: type == "image"
                                                              ?
                                                          Colors.black
                                                              : isCurrentUser ?
                                                          Colors.white70 : Colors
                                                              .grey,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      if (isCurrentUser) ...[
                                                        const SizedBox(width: 5),
                                                        Icon(message["read"] ? Icons.done_all : Icons.done,
                                                          color: type == "image" ? Colors.black : message["read"] ?
                                                          Colors.white : Colors.white70,
                                                          size: 12,
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if(isCurrentUser)
                                              Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: AppTextWidget(
                                                      text: isDelivered ? "seen" : "deliver",
                                                      fontSize: 12.0)
                                              )
                                          ],
                                        ),
                                      );
                                      messageWidgets.add(messageWidget);
                                    }
                                    return ListView(
                                      reverse: true,
                                      children: messageWidgets,
                                    );
                                  },
                                ),
                              ),
                            ),
                            // _buildChatMessages(),
                            _buildMessageInput(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
              //   child: Container(
              //     height: 70.h,
              //     width: 90.w,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20),
              //       color: Colors.white,
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.2),
              //           spreadRadius: 2.0,)]
              //     ),
              //     child: Column(
              //       children: [
              //         AppTextWidget(text: 'Total Chats', fontWeight: FontWeight.bold, fontSize: 15,),
              //         AppTextWidget(text: '12,345', fontWeight: FontWeight.w400, fontSize: 18,),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ));
  }
// import 'package:flutter/material.dart';
//
// class ChatSupportScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           // Left Sidebar (Contact List)
//           Expanded(
//             flex: 2,
//             child: Container(
//               color: Colors.white,
//               child: ListView(
//                 children: [
//                   _buildContactItem('Emily Kelly', 'Newly Postpartum', '3 min ago', 'assets/profile1.png'),
//                   _buildContactItem('Erin Love', 'Newly Postpartum', '10 min ago', 'assets/profile2.png'),
//                   _buildContactItem('Kemi Olowojaje', 'Newly Postpartum', '30 min ago', 'assets/profile3.png'),
//                   _buildContactItem('Denise Stewart', 'Newly Postpartum', '1 hr ago', 'assets/profile4.png'),
//                   _buildContactItem('Scut Tom', 'Health Specialist', '2 hrs ago', 'assets/profile5.png'),
//                   _buildContactItem('Amina Ahmed', 'Health Counselor', '4 hrs ago', 'assets/profile6.png'),
//                   _buildContactItem('Banabas Paul', 'General Care', '2 days ago', 'assets/profile7.png'),
//                   _buildContactItem('Ayo Jones', 'Family Practitioner', '4 days ago', 'assets/profile8.png'),
//                 ],
//               ),
//             ),
//           ),
//
//           // Main Chat Window
//           Expanded(
//             flex: 5,
//             child: Container(
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   _buildChatHeader('Emily Kelly', 'Active 5min ago'),
//                   Expanded(child: _buildChatMessages()),
//                   _buildMessageInput(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  Widget _buildContactItem(
      Color color, String name, String status, String time, String image) {
    return ListTile(
      leading: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Container(
            height: 4.h,
            width: 2.2.w,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              AppAssets.person,
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
      title: AppTextWidget(
        text: name,
        textAlign: TextAlign.start,
        fontWeight: FontWeight.w700,
      ),
      subtitle: AppTextWidget(
          text: status,
          color: AppColors.appRedColor,
          fontSize: 10,
          textAlign: TextAlign.start),
      trailing: Padding(
        padding: EdgeInsets.only(bottom: 3.h),
        child:
            AppTextWidget(text: time, fontSize: 8, textAlign: TextAlign.start),
      ),
    );
  }

  Widget _buildChatHeader(String name, String status) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,top: 15.0,bottom: 15.0),
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
                  child: Image.asset(AppAssets.yoga,
                    fit: BoxFit.cover,
                     ),
                ),
              ),
              // Container(
              //   height: 36,
              //   width: 36,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(24),
              //       image: DecorationImage(image: AssetImage(AppAssets.girll),
              //         fit: BoxFit.cover,
              //       ),
              //     border: Border.all(
              //       color: Colors.grey.shade300,
              //       width: 1,
              //     ),
              //   ),
              //   // child: Image.asset(
              //   //   AppAssets.girll,
              //   //   fit: BoxFit.cover,
              //   // ),
              // ),
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
          SizedBox(width: 20,),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return Expanded(
      flex: 1,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          _buildReceivedMessage(
              'Hi Emily, \nPlease send the images as discussed on your last visit',
              '28 min ago'),
          SizedBox(height: 2.h,),
          _buildSentMessage(
              'Hi Doc. Here are the images. Sorry for coming late though',
              '27 min ago'),
          // More messages...
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(String message, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Container(
            height: 30,
              width: 30,
              decoration: const BoxDecoration(
                  image: DecorationImage(
            image: AssetImage(
              AppAssets.girll,
            ),
          ))),
        ),
        SizedBox(width: 0.3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4.h),
                ),
                child: AppTextWidget(
                  text: message,
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                  margin: EdgeInsets.only(right: 24.w),
                  child: Align(alignment:Alignment.centerRight,child: AppTextWidget(text: time, color: Colors.grey, fontSize: 10))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSentMessage(String message, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4.h),
                ),
                child: Text(message),
              ),
              const SizedBox(height: 4),
              Container(
                  margin: EdgeInsets.only(right: 21.5.w),
                  child: AppTextWidget(text: time,color: Colors.grey, fontSize: 10)),
            ],
          ),
        ),
        SizedBox(width: 0.5.w),
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      AppAssets.girll,
                    ),
                  ))),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
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
                icon: const Icon(Icons.sentiment_satisfied_alt_outlined), onPressed: () {}),
          ),
          Expanded(
            child: TextField(
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
                  width: 1,),
                )
            ),
            child: Container(
              height: 30,
              width: 40,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(20),right: Radius.circular(20))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/icons/share.svg'),
              )
            ),
          ),
        ],
      ),
    );
  }
}
