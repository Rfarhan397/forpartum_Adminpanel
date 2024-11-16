import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ProfileInfoProvider with ChangeNotifier {
  String? _profileImageUrl;
  String? _profileName;
  String? _profileEmail;
  String? _profileAddress;
  String? _profilePhone;
  String? _profileRole;

  String? get profileImageUrl => _profileImageUrl;
  String? get profileName => _profileName;
  String? get profileEmail => _profileEmail;
  String? get profilePhone => _profilePhone;
  String? get profileAddress => _profileAddress;
  String? get profileRole => _profileRole;

  // Method to set the profile information and notify listeners
  void setProfileInfo(String imageUrl, String name, String email,address,phone,role) {
    _profileImageUrl = imageUrl;
    _profileName = name;
    _profileEmail = email;
    _profileAddress = address;
    _profilePhone = phone;
    _profileRole = role;
    notifyListeners();
  }

  // Method to listen to real-time profile updates
  void listenToProfileInfo() {
    // Listening for changes in the Firestore document
    FirebaseFirestore.instance
        .collection('admin')
        .doc("d7vRqxlJm1Qg2BB04ILb058YoRw1") // Replace with your document ID
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        // Extract data from the snapshot
        final data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          // Extract the necessary fields with null checks
          String imageUrl = data['imageUrl'] ?? '';
          String name = data['name  '] ?? 'Unknown';
          String email = data['email'] ?? 'Unknown';
          String phone = data['phone'] ?? 'Unknown';
          String address = data['address'] ?? 'Unknown';
          String role = data['role'] ?? 'Unknown';

          // Update the profile information
          setProfileInfo(imageUrl, name, email,address,phone,role);
        }
      } else {
        if (kDebugMode) {
          print("Profile document does not exist");
        }
      }
    }, onError: (error) {
      if (kDebugMode) {
        print("Error listening to profile updates: $error");
      }
    });
  }
}
