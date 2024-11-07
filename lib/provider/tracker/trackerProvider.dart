import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/constant.dart';
import 'package:forpartum_adminpanel/main.dart';
import 'package:forpartum_adminpanel/provider/action/action_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../model/res/constant/app_utils.dart';
import '../../model/tracker/trackerModel.dart';

class TrackerProvider extends ChangeNotifier{
  List<String> trackerCategories = [
    'sleep',
    'mood',
    'stress',
    'energy',
    'pain'
  ];


  var controller = TextEditingController();
  var moodController = TextEditingController();
  var moodID = "";
  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;

  String _imageUrl = "";

  String get imageUrl => _imageUrl;


  void updateImage(image){
    _imageUrl = image;
    notifyListeners();
  }


  List<String> _optionsId = [];
  String _questionId= "";
  String get questionId => _questionId;

  // getter
  List<String> get optionsId => _optionsId;

  final List<TextEditingController> optionControllers = [
    TextEditingController()
  ];




  void update(){
    _isUpdate = true;
    notifyListeners();
  }

  void addController(String optionId,String questionId){
    _isUpdate = true;
    _optionsId.add(optionId);
    _questionId = questionId;
    optionControllers.add(TextEditingController());
    notifyListeners();
  }

  void resetOptionController(){
    optionControllers.clear();
    _optionsId.clear();
    optionControllers.add(TextEditingController());
    _isUpdate = false;
    _questionId = "";
    notifyListeners();
  }


  Future<void> updateTracker() async{
    await FirebaseFirestore.instance
        .collection('trackerLog')
        .doc(_questionId)
        .update({
      'text': controller.text,
    });

    for (int i =0; i < optionControllers.length; i++) {
      await FirebaseFirestore.instance
          .collection('trackerLog')
          .doc(_questionId)
          .collection('options')
          .doc(optionsId[i])
          .update({
        'text': optionControllers[i].text,

      });
    }
    resetOptionController();
    ActionProvider.stopLoading();
  }
  Future<void> updateMood() async {
    if (moodID == null || moodID!.isEmpty) {
      log('Error: _questionId is null or empty.');
      AppUtils().showToast(text: 'Error: Invalid question ID');
      ActionProvider.stopLoading();
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('trackerLog').doc(moodID).update({
        'text': controller.text,
        'intensity': moodController.text,
        'image': imageUrl,
      });
      AppUtils().showToast(text: 'Mood updated successfully'); // Optional feedback
    } catch (error) {
      AppUtils().showToast(text: 'Failed to update mood: $error');
      log('Error updating mood: $error');
    } finally {
      ActionProvider.stopLoading();
    }
  }
  Future<void> uploadMood(textController,moodController,String image,type,categoryId) async {
    var id = FirebaseFirestore.instance.collection('trackerLog').doc().id;
    try {
      await FirebaseFirestore.instance.collection('trackerLog').doc(id).set({
        'text': textController,
        'intensity': moodController,
        'image': image,
        'id': id,
        'type': type,
        'categoryId' : categoryId
      });
      AppUtils().showToast(text: 'Mood upload successfully'); // Optional feedback
    } catch (error) {
      AppUtils().showToast(text: 'Failed to upload mood: $error');
      log('Error uploading mood: $error');
    } finally {
      ActionProvider.stopLoading();
    }
  }




  // Initialize with the first category as default
  String _selectedTrackerCategory = 'sleep';

  String get selectedTrackerCategory => _selectedTrackerCategory;

  void setSelectedTrackerCategory(String category) {
    _selectedTrackerCategory = category;
    notifyListeners();
  }
  ////to fetch pain categories
  List<String> painCategories = [];
  String? selectedPainCategory;

  // Fetch categories on initialization
  TrackerProvider() {
    painCategoriesStream();
  }

  Stream<List<PainCategory>> painCategoriesStream() {
    return FirebaseFirestore.instance
        .collection('painCategories')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PainCategory.fromDocument(doc))
        .toList());
  }



  set selectedPainCategorys(String? category) {
    selectedPainCategory = category;
    notifyListeners();
  }
}



class TrackerDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TrackerProvider>(
      builder: (context, dropdownProvider, child) {
        return Container(
          width: 10.w,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.transparent),
          ),
          child: DropdownButtonFormField<String>(
            dropdownColor: primaryColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),          value: dropdownProvider.selectedTrackerCategory.isEmpty
                ? null // Set to null if no valid selection
                : dropdownProvider.selectedTrackerCategory,
            hint: Text('Select Tracker',style: TextStyle(color: Colors.black),),
            items: dropdownProvider.trackerCategories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category,style: TextStyle(color: whiteColor),),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                dropdownProvider.setSelectedTrackerCategory(newValue);
              }
            },
            icon: Icon(Icons.keyboard_arrow_down_outlined,color: whiteColor,),
          ),
        );
      },
    );
  }


  // update all controller data with questions
  // void updateControllerData(TrackerProvider trackerProvider, TrackerModel trackerModel) {
  //   trackerModel.trackerCategory = trackerProvider.selectedTrackerCategory;
  //   trackerModel.options = trackerProvider.optionControllers.map((controller) => controller.text).toList();
  //   trackerModel.isUpdate = trackerProvider.isUpdate;
  // }

}
