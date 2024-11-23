import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore import
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../model/res/constant/app_utils.dart';
import '../../model/res/routes/routes_name.dart';
import '../action/action_provider.dart';

class AuthProvider extends ChangeNotifier {
  Future<void> signInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Check if the user exists in the Firestore admin collection
      final adminSnapshot = await FirebaseFirestore.instance
          .collection('admin') // Replace with your admin collection name
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password) // Assumes passwords are stored securely (hashed)
          .get();

      if (adminSnapshot.docs.isNotEmpty) {
        // AppUtils().showToast(text: 'Please enter your correct username and password');
        // Admin record found, proceed with login logic
        ActionProvider.stopLoading();
        AppUtils().showToast(text: "Login Successful");
        Get.offNamed(RoutesName.mainScreen);
        log("Login successful");
      } else {
        // No matching admin record found
        ActionProvider.stopLoading();
        log('No admin record found for that email and password.');
        AppUtils().showToast(
          text: "Login failed: No admin record found for that email and password.",
        );
      }
    } catch (e) {
      ActionProvider.stopLoading();
      log('Error: $e');
      AppUtils().showToast(
        text: "Login failed: An unexpected error occurred.",
      );
    }
  }
}
