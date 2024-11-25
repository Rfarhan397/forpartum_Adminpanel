import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constant.dart';
import '../../model/activity/activity.dart';
import '../../model/blog_post/blog_model.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationItem> _notifications = [
    NotificationItem(
      date: '2023-06-25',
      description: 'Server maintenance scheduled for 2 AM',
      category: 'System Notifications',
      categoryColor: secondaryColor,
    ),
    NotificationItem(
      date: '2023-06-25',
      description: 'User Emily P. suggested a new feature',
      category: 'User Request',
      categoryColor: primaryColor,
    ),
    NotificationItem(
      date: '2023-06-25',
      description: 'High number of users.svg reporting fatigue',
      category: 'Health Notifications',
      categoryColor:secondaryColor,
    ),
  ];

  List<NotificationItem> get notifications => _notifications;
}
// class NotificationProviderForNotifications with ChangeNotifier {
//   List<NotificationItem> _notifications = [
//     NotificationItem(
//       date: '2023-06-25',
//       description: 'Weekly Insights Update',
//       category: 'Overdue Notifications',
//       categoryColor: secondaryColor,
//     ),
//
//     NotificationItem(
//       date: '2023-06-25',
//       description: 'System Maintenance Notice Failed to Send',
//       category: 'Notification Errors',
//       categoryColor: secondaryColor,
//     ),
//   ];
//
//   List<NotificationItem> get notifications => _notifications;
// }
// Import your model if you have one

class NotificationProviderForNotifications with ChangeNotifier {
  List<NotificationModel> notifications = [];

  Future<void> fetchNotifications() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('notifications').get();
      notifications = querySnapshot.docs.map((doc) {
        return NotificationModel(
          description: doc['description'],
          message: doc['message'],
          timestamp: doc['timestamp'],
          title: doc['title'],
          status: doc['status'],
          id: doc['id'],
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      // Handle errors if needed
      log("Error fetching notifications: $e");
    }
  }


  String formatTimestamp(String timestampString) {
    try {
      // Convert the string timestamp to an integer (assuming it's in microseconds)
      int timestamp = int.parse(timestampString);

      // Convert the timestamp to a DateTime object
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp ~/ 1000);

      // Format the DateTime to a human-readable string (e.g., "2024-11-08 14:30")
      String formattedDate = DateFormat('yyyy-MM-dd ').format(dateTime);

      return formattedDate;
    } catch (e) {
      // Handle potential parsing errors
      print("Error formatting timestamp: $e");
      return 'Invalid Date';
    }
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int totalSentCount = 0;
  int clickedCount = 0;
  String clickThroughRate = '0%';

  Future<void> fetchCTR() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('notifications').get();
      totalSentCount = snapshot.size;

      // Assuming each notification document has a field 'clicked' that shows how many times it was clicked
      clickedCount = snapshot.docs.fold<int>(0, (sum, doc) {
        return sum + ((doc['clicked'] ?? 0) as num).toInt(); // Ensure the value is an int
      });


      if (totalSentCount > 0) {
        clickThroughRate = '${((clickedCount / totalSentCount) * 100).toStringAsFixed(2)}%';
      } else {
        clickThroughRate = '0%';
      }

      notifyListeners();
    } catch (e) {
      print('Error calculating CTR: $e');
    }
  }
}

