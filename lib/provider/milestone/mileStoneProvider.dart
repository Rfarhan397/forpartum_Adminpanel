import 'package:flutter/material.dart';

class MilestoneProvider with ChangeNotifier {
  TextEditingController milestoneController = TextEditingController();
  bool isEditing = false;
  String? editingMilestoneId;

  // Set the editing state and update the controller with the selected milestone title
  void startEditing(String id, String title) {
    isEditing = true;
    editingMilestoneId = id;
    milestoneController.text = title;
    notifyListeners();
  }

  // Reset the editing state after updating or cancelling
  void stopEditing() {
    isEditing = false;
    editingMilestoneId = null;
    milestoneController.clear();
    notifyListeners();
  }

  // Upload new milestone
  Future<void> uploadMilestone(BuildContext context) async {
    // Add your Firebase upload logic here
    // For simplicity, resetting the form after uploading
    stopEditing();
    notifyListeners();
  }

  // Update an existing milestone
  Future<void> updateMilestone(BuildContext context) async {
    // Add your Firebase update logic here using editingMilestoneId
    // After updating, reset the form
    stopEditing();
    notifyListeners();
  }
}
