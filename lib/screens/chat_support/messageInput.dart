import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forpartum_adminpanel/constant.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import 'dart:typed_data';

import '../../provider/chat/chatProvider.dart';
import '../../provider/cloudinary/cloudinary_provider.dart';


class MessageInput extends StatelessWidget {
  final String chatRoomId, otherUserEmail;

  MessageInput({super.key, required this.chatRoomId, required this.otherUserEmail});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(
                color: Colors.black,
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (value) async {
                if (_controller.text.isNotEmpty) {
                  await provider.sendMessage(
                      chatRoomId: chatRoomId,
                      message: _controller.text,
                      otherEmail: otherUserEmail,
                      type: 'text',

                  );
                  _controller.clear(); }
              },
              decoration: InputDecoration(
                hintText: 'Type a message....',
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
          SizedBox(width: 1.w),
          GestureDetector(
            onTap: () async {
              await provider.sendMessage(
                  chatRoomId: chatRoomId,
                  message: _controller.text,
                  otherEmail: otherUserEmail,
                  type: 'text',
              );
              _controller.clear();
            },
            child:  Container(
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
                  decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(20),right: Radius.circular(20))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset('assets/icons/share.svg'),
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Future<void> deleteChat(String id) async {
  //   await fireStore.collection("chatRooms").doc(id).delete();
  //   Get.back(); // Close the screen after deletion
  // }

}
