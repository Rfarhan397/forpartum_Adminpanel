import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/constant.dart';
import 'package:forpartum_adminpanel/provider/action/action_provider.dart';
import 'package:provider/provider.dart';

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
  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;


  List<String> _optionsId = [];
  String _questionId= "";
  String get questionId => _questionId;

  // getter
  List<String> get optionsId => _optionsId;

  final List<TextEditingController> optionControllers = [
    TextEditingController()
  ];


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
        return DropdownButton<String>(
          dropdownColor: primaryColor,
          underline: Container(),
          value: dropdownProvider.selectedTrackerCategory.isEmpty
              ? null // Set to null if no valid selection
              : dropdownProvider.selectedTrackerCategory,
          hint: Text('Select Tracker'),
          items: dropdownProvider.trackerCategories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              dropdownProvider.setSelectedTrackerCategory(newValue);
            }
          },
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
