import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/provider/chat/chatProvider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

const primaryColor = Color(0xffEF6844);
const secondaryColor = Color(0xff9A96E4);
const lightPurpleColor = Color(0xffB1AFE9);
const whiteColor = Color(0xFFFFFFFF);
const bgColor = Color(0xFFFFF0EC);
const lightGrey = Color(0xFFE2E8F0);
const darkGrey = Color(0x89534F5D);
const lightBlue = Colors.lightBlue;
const Color customGrey = Color(0xFFE0E0E0);


LinearGradient gradientColor = const LinearGradient(colors: [
  Color(0xffFF5000),
  Color(0xffFFCC38),
]);

RadialGradient lightModeGradient = const RadialGradient(colors: [
  Color(0x24ff5000),
  Color(0xF3BBB9D0),
]);

String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'zzoe nubl luhf pnto';
  }

  // Regular expression for validating an email
  String pattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Enter a valid email address';
  }

  return null;
}
String? getCurrentUid(){
  // final provider = Provider.of<ChatProvider>(Get.context!,listen: false);
  String email = "admin123@gmail.com";
  return email;
}
String convertTimestamp(String timestampString) {
  DateTime parsedTimestamp = parseTimestamp(timestampString);
  final now = DateTime.now();
  final difference = now.difference(parsedTimestamp);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h';
  } else if (difference.inDays < 30) {
    return '${difference.inDays}d';
  } else if (difference.inDays < 365) {
    final months = difference.inDays ~/ 30;
    return '${months}mm';
  } else {
    final years = difference.inDays ~/ 365;
    return '${years}y';
  }
}

DateTime parseTimestamp(String timestampString) {
  return DateTime.parse(timestampString);
}