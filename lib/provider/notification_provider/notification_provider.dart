import 'package:flutter/material.dart';
import '../../constant.dart';
import '../../model/activity/activity.dart';

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
class NotificationProviderForNotifications with ChangeNotifier {
  List<NotificationItem> _notifications = [
    NotificationItem(
      date: '2023-06-25',
      description: 'Weekly Insights Update',
      category: 'Overdue Notifications',
      categoryColor: secondaryColor,
    ),

    NotificationItem(
      date: '2023-06-25',
      description: 'System Maintenance Notice Failed to Send',
      category: 'Notification Errors',
      categoryColor: secondaryColor,
    ),
  ];

  List<NotificationItem> get notifications => _notifications;
}
