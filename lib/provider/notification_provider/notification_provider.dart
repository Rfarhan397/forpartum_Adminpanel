import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constant.dart';
import '../../model/activity/activity.dart';
import '../../model/blog_post/blog_model.dart';

class NotificationProviderForNotifications with ChangeNotifier {
  List<NotificationModel> notifications = [];

  // Use Stream instead of Future for real-time updates
  Stream<List<NotificationModel>> getNotificationsStream() {
    return FirebaseFirestore.instance
        .collection('notifications')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return NotificationModel(
          description: doc['description'],
          message: doc['message'],
          timestamp: doc['timestamp'],
          title: doc['title'],
          status: doc['status'],
          id: doc['id'],
        );
      }).toList();
    });
  }

  // Format timestamp as before
  String formatTimestamp(String timestampString) {
    try {
      int timestamp = int.parse(timestampString);
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp ~/ 1000);
      String formattedDate = DateFormat('yyyy-MM-dd ').format(dateTime);
      return formattedDate;
    } catch (e) {
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

      clickedCount = snapshot.docs.fold<int>(0, (sum, doc) {
        return sum + ((doc['clicked'] ?? 0) as num).toInt();
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
