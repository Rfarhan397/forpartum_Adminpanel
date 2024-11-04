import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/constant.dart';
import 'package:forpartum_adminpanel/model/res/components/custom_appBar.dart';
import 'package:forpartum_adminpanel/model/res/constant/app_utils.dart';
import 'package:forpartum_adminpanel/model/tracker/trackerModel.dart';
import 'package:forpartum_adminpanel/provider/tracker/trackerProvider.dart';
import 'package:forpartum_adminpanel/screens/trackers/trakerQuestion.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:html' as html;
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/app_text_field.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/cloudinary/cloudinary_provider.dart';

class TrackerScreen extends StatefulWidget {
  TrackerScreen({super.key});

  @override
  _TrackerScreenState createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();

  Uint8List? _imageData;
// Declare imageData here

  @override
  Widget build(BuildContext context) {
    final trackerProvider = Provider.of<TrackerProvider>(context);

    return Scaffold(
      appBar: const CustomAppbar(text: 'Trackers'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            thickness: 1.0,
            color: Colors.grey[300],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: SizedBox(
                  width: 41.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Consumer<TrackerProvider>(
                          builder: (context, value, child) {
                            return TrackerDropdown();
                          },
                        ),
                      ),
                      if (trackerProvider.selectedTrackerCategory == 'pain')
                         Column(
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    _showAddCategoryBottomSheet(context);
                                  },
                                  child: const AppTextWidget(text: 'Add Pain Category',color: primaryColor,fontWeight: FontWeight.w500,fontSize: 18,)),
                              StreamBuilder<List<PainCategory>>(
                                stream: trackerProvider.painCategoriesStream(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return DropdownButton<String>(
                                      underline: Container(),
                                      value: "",
                                      items: [''].map((_) {
                                        return const DropdownMenuItem<String>(
                                          value: "",
                                          child: Text("Loading..."),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        trackerProvider.selectedPainCategorys = value!;
                                      },
                                    );
                                  }
                                  if (snapshot.hasError || !snapshot.hasData) {
                                    return const Text('Error loading categories');
                                  }

                                  final painCategories = snapshot.data!;
                                  return DropdownButton<String>(
                                    underline: Container(),
                                    value: trackerProvider.selectedPainCategory,
                                    items: painCategories.map((categoryItem) {
                                      return DropdownMenuItem<String>(
                                        value: categoryItem.id,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(categoryItem.category),
                                            const SizedBox(width: 8), // Adjust the width as needed
                                            if (trackerProvider.selectedPainCategory != categoryItem.id)
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      trackerProvider.controller.text = categoryItem.category;
                                                      _showUpdateCategoryBottomSheet(context, categoryItem.id);
                                                    },
                                                    child: const Icon(Icons.edit),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        _deleteCategory(context, categoryItem.id);
                                                      },
                                                      child: const Icon(Icons.delete))
                                                ],
                                              ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      trackerProvider.selectedPainCategorys = value!;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],),
                        const AppTextWidget(
                        text: 'Your Question',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        height: 8.h,
                        width: 30.w,
                        child: AppTextFieldBlue(
                          hintText: 'Write your question here',
                          radius: 5,
                          controller: trackerProvider.isUpdate ? trackerProvider.controller : _titleController,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      if (trackerProvider.selectedTrackerCategory == 'mood')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 8.h,
                              width: 30.w,
                              child: AppTextFieldBlue(
                                hintText: 'Write intensity of your mood',
                                radius: 5,
                                controller: _moodController,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Consumer<CloudinaryProvider>(
                              builder: (context, provider, child) {
                                return provider.imageData != null
                                    ? Container(
                                        height: 20.h,
                                        width: 20.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                        child: Image.memory(
                                          provider.imageData!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        height: 20.h,
                                        width: 20.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          //border: Border.all(color: Colors.black),
                                        ),
                                        child: const Center(
                                          child: AppTextWidget(
                                              text: 'No image selected',
                                              color: Colors.grey),
                                        ),
                                      );
                              },
                            ),
                            SizedBox(height: 1.h),
                            const AppTextWidget(
                              text:
                                  'Image must be in PNG format with transparent background',
                              color: Colors.grey,
                            ),
                            SizedBox(height: 1.h),
                            ButtonWidget(
                              text:
                                  'Upload Post ${trackerProvider.selectedTrackerCategory}',
                              onClicked: () {
                                _pickAndUploadImage(
                                  context,
                                );
                              },
                              width: 10.w,
                              height: 5.h,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      SizedBox(height: 1.h),
                      // Show options only if selected type is not "Mood" or "Stress"
                      if (trackerProvider.selectedTrackerCategory != 'mood' &&
                          trackerProvider.selectedTrackerCategory !=
                              'stress') ...[
                        const AppTextWidget(
                          text: 'Options',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 1.h),
                        ..._buildOptionFields(),
                        SizedBox(height: 1.h),
                        TextButton(
                          onPressed: (){
                            _addOption(trackerProvider);
                          },
                          child: const Text("Add Option"),
                        ),
                      ],
                      SizedBox(height: 5.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ButtonWidget(
                            onClicked: () {
                              ActionProvider.startLoading();
                              if(trackerProvider.isUpdate){
                                trackerProvider.updateTracker();
                              }else{
                                _uploadTracker(context);
                              }

                            },
                            text: trackerProvider.isUpdate ? "Update" : "Publish",
                            height: 5.h,
                            width: 10.w,
                            textColor: Colors.white,
                            radius: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  width: 35.w,
                  child: trackerProvider.selectedTrackerCategory == "mood"
                      ? const TrackerCausesList(type: 'mood')
                      : QuestionListSection(
                    onTap: () {

                    },
                          type: trackerProvider.selectedTrackerCategory,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future<void> updateTrackerLog(String trackerLogId, String questionText, ) async {
    try {
      await FirebaseFirestore.instance
          .collection('trackerLog')
          .doc(trackerLogId)
          .update({
        'text': questionText,
      });
      print("TrackerLog updated successfully");
    } catch (e) {
      print("Error updating TrackerLog: $e");
    }
  }
  Future<void> updateOption(String trackerLogId, String optionId, String optionText) async {
    try {
      await FirebaseFirestore.instance
          .collection('trackerLog')
          .doc(trackerLogId)
          .collection('options')
          .doc(optionId)
          .update({
        'text': optionText,
        // Add other fields if necessary
      });
      print("Option updated successfully");
    } catch (e) {
      print("Error updating Option: $e");
    }
  }
  void updateData() async{
    String trackerLogId = "8t3SMDq9Hn0Ku0GM4UsZ";
    String optionId = 'optionid';
    String newQuestionText = "What did you think of your child's sleep last night?";
    String newIntensity = "Moderate";
    String newOptionText = "Slept like a log";

    // Update TrackerLog
    updateTrackerLog(trackerLogId, newQuestionText, );

    // Update Option
    updateOption(trackerLogId, optionId, newOptionText);
  }

  void _showAddCategoryBottomSheet(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppTextWidget(
                text: 'Add Pain Category',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 16),
              AppTextFieldBlue(
                hintText: 'Enter category name',
                radius: 5,
                controller: categoryController,
              ),
              const SizedBox(height: 16),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.w),
                child: ButtonWidget(
                  text: 'Add Category',
                  onClicked: () async {
                    final category = categoryController.text.trim();
                   _uploadCategory(context,category);
                  },
                  width: 50.w,
                  height: 5.h,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  void _showUpdateCategoryBottomSheet(BuildContext context,String id) {

    final trackerProvider = Provider.of<TrackerProvider>(context,listen: false);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppTextWidget(
                text: 'Update Pain Category',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 16),
              AppTextFieldBlue(
                hintText: 'Enter category name',
                radius: 5,
                controller: trackerProvider.controller,
              ),
              const SizedBox(height: 16),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.w),
                child: ButtonWidget(
                  text: 'update Category',
                  onClicked: () async {
                    final category = trackerProvider.controller.text.trim();
                    _updateCategory(context,category,id);
                  },
                  width: 50.w,
                  height: 5.h,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _pickAndUploadImage(BuildContext context) async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // Accept only images

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);

      reader.onLoadEnd.listen((e) async {
        final bytes = reader.result as Uint8List;
        _imageData = bytes;

        // Set image data using Provider to display in the container
        final cloudinaryProvider =
            Provider.of<CloudinaryProvider>(context, listen: false);
        cloudinaryProvider.setImageData(bytes);

        // Upload to Cloudinary
        await cloudinaryProvider.uploadImage(_imageData!);

        // Show toast when upload completes
        AppUtils().showToast(text: 'Image uploaded successfully');
      });
    });

    uploadInput.click(); // Trigger the file picker dialog
  }

  List<Widget> _buildOptionFields() {
    final trackerProvider = Provider.of<TrackerProvider>(context, listen: false);
    return List.generate(trackerProvider.optionControllers.length, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: AppTextFieldBlue(
                hintText: 'Option ${index + 1}',
                radius: 5,
                controller: trackerProvider.optionControllers[index],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () {
                _removeOption(index,trackerProvider);
              },
            ),
          ],
        ),
      );
    });
  }

  void _addOption(TrackerProvider trackerProvider) {
    setState(() {
      trackerProvider.optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index,TrackerProvider trackerProvider) {
    setState(() {
      trackerProvider.optionControllers.removeAt(index);
    });
  }

  void _uploadTracker(BuildContext context) async {
    ActionProvider.startLoading();
    var trackerProvider = Provider.of<TrackerProvider>(context, listen: false);
    var cloudinaryProvider =
        Provider.of<CloudinaryProvider>(context, listen: false);

    if (_titleController.text.isEmpty ||
        (trackerProvider.selectedTrackerCategory != 'mood' &&
            trackerProvider.selectedTrackerCategory != 'stress' &&
            trackerProvider.optionControllers.any((controller) => controller.text.isEmpty))) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppUtils().showToast(text: 'Please fill in all fields'),
      );
      ActionProvider.stopLoading();
      return;
    }

    // Check if tracker type is selected
    if (trackerProvider.selectedTrackerCategory == null ||
        trackerProvider.selectedTrackerCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppUtils().showToast(text: 'Please select a tracker type'),
      );
      ActionProvider.stopLoading();
      return;
    }

    var trackerId =
        FirebaseFirestore.instance.collection('trackerLog').doc().id;

    await FirebaseFirestore.instance
        .collection('trackerLog')
        .doc(trackerId)
        .set({
      'text': _titleController.text,
      'id': trackerId,
      'type': trackerProvider.selectedTrackerCategory,
      'intensity': _moodController.text,
      'image': cloudinaryProvider.imageUrl.toString(),
    });

    log(
      'image url is::${cloudinaryProvider.imageUrl.toString()}',
    );
    // Upload options only if type is not "Mood" or "Stress"
    if (trackerProvider.selectedTrackerCategory != 'mood' &&
        trackerProvider.selectedTrackerCategory != 'stress') {
      for (var optionController in trackerProvider.optionControllers) {
        var optionID = FirebaseFirestore.instance
            .collection('trackerLog')
            .doc(trackerId)
            .collection('options')
            .doc()
            .id;
        await FirebaseFirestore.instance
            .collection('trackerLog')
            .doc(trackerId)
            .collection('options')
            .doc(optionID)
            .set({
          'text': optionController.text,
          'id': optionID,
          'trackerID' : trackerId

        });
      }
    }

    AppUtils().showToast(text: 'Tracker published successfully');
    ActionProvider.stopLoading();
  }

  void _uploadCategory(BuildContext context,String category) async {

    var id = FirebaseFirestore.instance
        .collection('painCategories')
        .doc()
        .id
        .toString();
    if (category.isNotEmpty) {
      // Save the category to Firestore
      await FirebaseFirestore.instance
          .collection('painCategories').doc(id)
          .set({
        'category': category,
        'Id': id,
      });
      Navigator.pop(context); // Close the bottom sheet
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        AppUtils().showToast(text: 'Please enter a category name'),
      );
    }
  }
  void _updateCategory(BuildContext context,String category,String id) async{
    var trackerProvider = Provider.of<TrackerProvider>(context, listen: false);
    if (category.isNotEmpty) {
      // Save the category to Firestore
      await FirebaseFirestore.instance
          .collection('painCategories').doc(id)
          .update({
        'category': category.toString(),
      });
      Navigator.pop(context); // Close the bottom sheet
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        AppUtils().showToast(text: 'Please enter a category name'),
      );
    }
  }

  void _deleteCategory(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () {
              _deleteCategoryFromFirestore(context, id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteCategoryFromFirestore(BuildContext context, String id) {
    FirebaseFirestore.instance
       .collection('painCategories')
       .doc(id)
       .delete()
       .then((value) {
      AppUtils().showToast(text: 'Category deleted successfully');
    })
       .catchError((error) {
      AppUtils().showToast(text: 'Error deleting category');
    });
  }
}
