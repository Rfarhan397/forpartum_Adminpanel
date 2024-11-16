import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

import '../../model/res/constant/app_assets.dart';


class MessageBubble extends StatelessWidget {
  final String message; // Message text or placeholder for image/voice
  final String type; // Message type (text, image, voice)
  final bool isSender;
  final String time;
  final String? url; // URL for image or voice
  final String? profileImageUrl; // URL for image or voice


  const MessageBubble({
    required this.message,
    required this.type,
    required this.isSender,
    required this.time,
    this.url,
    this.profileImageUrl   ,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget messageContent;

    // Display content based on message type
    if (type == 'text') {
      // Display text message
      messageContent = Text(
        message,
        maxLines: null,
        style: TextStyle(color: isSender ? Colors.white : Colors.black),
      );
    } else if (type == 'image' && url != null) {
      // Display image message
      messageContent = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url!,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error); // Handle image loading error
          },
          fit: BoxFit.cover,
          width: 200,
          height: 200,
        ),
      );
    } else if (type == 'voice' && url != null) {
      // Display voice message with a clickable play button
      messageContent = GestureDetector(
        onTap: () async{
          final Uri uri = Uri.parse(url!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, webOnlyWindowName: '_blank');  // Opens URL in a new tab
          } else {
            throw 'Could not launch $url';
          }
          // launchAudio(url!);
        },
        child: Row(
          children: [
            const Icon(Icons.play_circle_fill, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                url.toString(),
                style: TextStyle(color: isSender ? Colors.white : Colors.black),
              ),
            ),
          ],
        ),
      );
    }else if (type == 'document' && url != null) {
      // Display voice message with a clickable play button
      messageContent = InkWell(
        onTap: () {
          // Open or play voice message
          launchAudio(url!);
        },
        child: Row(
          children: [
            Image.asset(AppAssets.logoImage,height: 30,width: 30,),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                "Document: $type",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // url.toString(),
                style: TextStyle(color: isSender ? Colors.white : Colors.black),
              ),
            ),
          ],
        ),
      );
    }
    else {
      // Fallback for unknown message types
      messageContent = Text(
        'Unknown message type',
        style: TextStyle(color: isSender ? Colors.white : Colors.black),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start, // Align right for sender
        children: [
          if (!isSender) // Only show avatar for receiver's message
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              backgroundImage: profileImageUrl != null && profileImageUrl!.isNotEmpty
                  ? NetworkImage(profileImageUrl!) // Load the user's profile image
                  : AssetImage(AppAssets.logoImage) as ImageProvider, // Fallback to a default image
            ),
          SizedBox(width: 1.w),
          Column(
            crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: 40.w
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: isSender ? Colors.blueAccent : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: isSender ? Radius.circular(0): Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomLeft: isSender ? Radius.circular(15) : Radius.circular(0),
                  ),
                ),
                child: messageContent,
              ),
              const SizedBox(height: 5),
              Text(
                time,
                style: const TextStyle(

                    color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Launch audio URL directly
  void launchAudio(String audioUrl) {
    html.window.open(audioUrl, '_blank');
  }
}
