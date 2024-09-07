import 'package:flutter/material.dart';

import '../../model/user_model/user_model.dart';

class UserProvider with ChangeNotifier {
  final List<User> _users = [
    User(name: "Emily Kelly", email: "emily@example.com", isActive: true),
    User(name: "Erin Love", email: "emily@example.com", isActive: true),
    User(name: "Kemi Olowojeje", email: "emily@example.com", isActive: true),
    User(name: "Denise Stewart", email: "emily@example.com", isActive: true),
    User(name: "Scut Tom", email: "emily@example.com", isActive: true),
    User(name: "Amina Ahmed", email: "emily@example.com", isActive: true),
    User(name: "Banabas Paul", email: "emily@example.com", isActive: true),
    User(name: "Ayo Jones", email: "emily@example.com", isActive: true),
  ];

  List<User> get users => _users;

  void deleteUser(User user) {
    _users.remove(user);
    notifyListeners();
  }

  void updateUser(User user) {
    // Implement update logic
    notifyListeners();
  }
}
