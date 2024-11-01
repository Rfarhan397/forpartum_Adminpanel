import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/user_model/user_model.dart';

class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
  void closeDrawer() {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.closeDrawer();
    }
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  User? _parameters;
  User? get parameters => _parameters;

  void changeScreen(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void changeScreenWithParams(int routeName,
      { required User parameters}) {
    _selectedIndex = routeName;
    _parameters = parameters;
    notifyListeners();
  }
  ///////to controll the toggle state in user details/////////
  bool _isActive = true;

  bool get isActive => _isActive;

  // Method to toggle active status and update Firestore
  void toggleActive(String userId) {
    _isActive = !_isActive;
    notifyListeners();

    // Update Firestore status based on the new toggle state
    updateUserStatusInFirestore(userId, _isActive);
  }

  // Function to update the user's status in Firestore
  Future<void> updateUserStatusInFirestore(String userId, bool isActive) async {
    try {
      // Access the specific document by user ID and update the status
      await FirebaseFirestore.instance
          .collection('users')  // Replace with your actual collection
          .doc(userId)  // Document ID of the user
          .update({'status': isActive ? 'isActive' : 'isNotActive'}); // Update the status
    } catch (e) {
      log('Failed to update status: $e');
    }
  }
}
