import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/user_model/user_model.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = true;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  UserProvider() {
    fetchUsersFromFirebase();
  }

  Future<void> fetchUsersFromFirebase() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Fetch data from Firebase for users
      final snapshot = await FirebaseFirestore.instance.collection('users').get();

      _users = await Future.wait(snapshot.docs.map((doc) async {
        // Fetch tracker data for each user


        return User(
          uid: doc.id,
          name: doc['name'] ?? "",
          email: doc['email'] ?? "",
          status: doc['status'] ?? "",
          imageUrl: doc['imageUrl'] ?? "",
          accountType: doc['accountType'] ?? "",
          age: doc['age'] ?? "",
          avatar: doc['avatar'] ?? "",
          birthDate: doc['birthDate'] ?? "",
          createdAt: doc['createdAt'] ?? "",
          dietPlan: doc['dietPlan'] ?? "",
          feedingFormula: doc['feedingFormula'] ?? "",
          isPolicyAccept: doc['isPolicyAccept'] ?? "",
          password: doc['password'] ?? "",
          pregnant: doc['pregnant'] ?? "",
          singletonSection: doc['singletonSection'] ?? "",
          sleepHour: doc['sleepHour'] ?? "",
          stressLevel: doc['stressLevel'] ?? "",
          subscriptionPlan: doc['subscriptionPlan'] ?? "",
          trialStartDate: doc['trialStartDate'] ?? "",
          vaginalBirth: doc['vaginalBirth'] ?? "",
        );
      }).toList());

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log("Error fetching users: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  //////////////feedback //////

  List<Map<String, dynamic>> _feedbacks = [];

  List<Map<String, dynamic>> get feedbacks => _feedbacks;

  Future<void> fetchFeedbacks() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('feedbacks').get();
      _feedbacks = snapshot.docs.map((doc) => doc.data()).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching feedbacks: $e');
    }
  }

  /////////////sadasd//////

}


