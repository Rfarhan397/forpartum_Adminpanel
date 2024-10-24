// import 'package:flutter/material.dart';
//
// import '../../model/user_model/user_model.dart';
//
// class UserProvider with ChangeNotifier {
//   final List<User> _users = [
//     User(name: "Emily Kelly", email: "emily@example.com", isActive: true),
//     User(name: "Erin Love", email: "emily@example.com", isActive: true),
//     User(name: "Kemi Olowojeje", email: "emily@example.com", isActive: true),
//     User(name: "Denise Stewart", email: "emily@example.com", isActive: true),
//     User(name: "Scut Tom", email: "emily@example.com", isActive: true),
//     User(name: "Amina Ahmed", email: "emily@example.com", isActive: true),
//     User(name: "Banabas Paul", email: "emily@example.com", isActive: true),
//     User(name: "Ayo Jones", email: "emily@example.com", isActive: true),
//     User(name: "Emily Kelly", email: "emily@example.com", isActive: true),
//     User(name: "Erin Love", email: "emily@example.com", isActive: true),
//     User(name: "Kemi Olowojeje", email: "emily@example.com", isActive: true),
//     User(name: "Denise Stewart", email: "emily@example.com", isActive: true),
//     User(name: "Scut Tom", email: "emily@example.com", isActive: true),
//     User(name: "Amina Ahmed", email: "emily@example.com", isActive: true),
//     User(name: "Banabas Paul", email: "emily@example.com", isActive: true),
//     User(name: "Ayi Jones", email: "emily@example.com", isActive: true),
//   ];
//
//   List<User> get users => _users;
//
//   void deleteUser(User user) {
//     _users.remove(user);
//     notifyListeners();
//   }
//
//   void updateUser(User user) {
//     // Implement update logic
//     notifyListeners();
//   }
// }
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

      // Fetch data from Firebase
      final snapshot = await FirebaseFirestore.instance.collection('users').get();

      _users = snapshot.docs.map((doc) {
        return User(
          uid: doc.id,
          name: doc['name'] ?? "",
          email: doc['email']?? "",
          status: doc['status']?? "",
          imageUrl: doc['imageUrl']?? "",
          accountType: doc['accountType']?? "",
          age: doc['age']?? "",
          avatar:   doc['avatar']?? "",
          birthDate: doc['birthDate']?? "",
          createdAt: doc['createdAt']?? "",
          dietPlan: doc['dietPlan']?? "",
          feedingFormula: doc['feedingFormula']?? "",
          isPolicyAccept: doc['isPolicyAccept']?? "",
          password: doc['password']?? "",
          pregnant: doc['pregnant']?? "",
          singletonSection: doc['singletonSection']?? "",
          sleepHour: doc['sleepHour']?? "",
          stressLevel: doc['stressLevel']?? "",
          subscriptionPlan: doc['subscriptionPlan']?? "",
          trialStartDate: doc['trialStartDate']?? "",
          vaginalBirth: doc['vaginalBirth']?? "",

        );
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log("Error fetching users: $e");
      _isLoading = false;
      notifyListeners();
    }
  }
}
