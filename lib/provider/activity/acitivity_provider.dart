import 'package:flutter/material.dart';
import '../../model/activity/activity.dart';

class ActivityProvider with ChangeNotifier {
  List<Activity> _activities = [
    Activity(date: '2023-06-25', description: 'User Emily P. completed a milestone'),
    Activity(date: '2023-06-25', description: 'New user Jane D. registered'),
    Activity(date: '2023-06-25', description: 'Milestone updated: Baby’s First Solid Food'),
    Activity(date: '2023-06-25', description: 'User Miley completed a milestone'),
    Activity(date: '2023-06-25', description: 'Milestone updated: Baby’s First Solid Food'),
  ];
  List<ActivityForNotifications> _activitiesForNotifications = [
    ActivityForNotifications(date: '2023-06-25', description: 'Weekly Insights Update',status: 'sent',action:'[View]'),
    ActivityForNotifications(date: '2023-06-25', description: 'New Feature Announcement ',status: 'pending',action:'[View]'),
    ActivityForNotifications(date: '2023-06-25', description: 'System Maintenance ',status: 'pending',action:'[View]'),
    ActivityForNotifications(date: '2023-06-25', description: 'Weekly Insights Update',status: 'sent',action:'[View]'),
    ActivityForNotifications(date: '2023-06-25', description: 'Weekly Insights Update',status: 'sent',action:'[View]'),
  ];

  List<Activity> get activities => _activities;
  List<ActivityForNotifications> get activitiesForNotifications => _activitiesForNotifications;

  void addActivity(Activity activity) {
    _activities.add(activity);
    notifyListeners();
  }
  void addActivityForNotifications(ActivityForNotifications activityForNotifications) {
    _activitiesForNotifications.add(activityForNotifications);
    notifyListeners();
  }
}
