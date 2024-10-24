import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../model/res/components/custom_appBar.dart';
import '../../../model/res/constant/app_utils.dart';
import '../../../model/res/widgets/app_text.dart.dart';
import '../../../model/res/widgets/app_text_field.dart';
import '../../../model/res/widgets/button_widget.dart';
import '../../../provider/action/action_provider.dart';
import '../../constant.dart';
import '../../model/blog_post/blog_model.dart';
import '../../provider/stream/streamProvider.dart';

class GuidelineScreen extends StatelessWidget {
  GuidelineScreen({super.key});

  TextEditingController _questionController =  TextEditingController();
  TextEditingController _answerController =  TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final action = Provider.of<ActionProvider>(context);

    return  Scaffold(
      appBar: const CustomAppbar(text: 'Guidelines'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 4.w, vertical:6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppTextWidget(text: 'Question'),
                  SizedBox(height: 1.h,),
                  Container(
                    height: 8.h,
                    width: 25.w,
                    child: AppTextFieldBlue(
                      controller: _questionController,
                      hintText: 'How do I use?',
                      radius: 5,
                    ),

                  ),
                  SizedBox(height: 1.h,),
                  Container(
                    height: 10.h,
                    width: 30.w,// 50% of screen height
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.8)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:  TextField(
                      maxLines: null, // Allows the text to wrap within the height
                      expands: true,  // Expands the TextField to fill the parent container
                      controller: _answerController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          border: InputBorder.none,
                          hintText: '',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w900,fontSize: 15,
                          )
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h,),
                  Consumer<ActionProvider>(
                    builder: (context, value, child) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: ButtonWidget(
                            text: value.publishText,
                            onClicked: () {
                              if (value.editingId == null) {
                                _publishFAQ();
                              } else {
                                _updateFaq(context, value.editingId!);
                              }
                            },
                            width: 100,
                            height: 35,
                            fontWeight: FontWeight.normal),
                      );
                    },
                  ),
                  SizedBox(height: 3.h,),
                  const AppTextWidget(text: 'Recent Guidelines: ',fontSize: 18,fontWeight: FontWeight.w600,),
                  SizedBox(height: 2.h,),
                  Consumer<StreamDataProvider>(
                    builder: (context, provider, child) {
                      return StreamBuilder<List<AddGuideline>>(
                        stream: provider.getGuideline(),
                        builder: (context, snapshot) {

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No milestone found'));
                          }

                          List<AddGuideline> addGuideline = snapshot.data!;
                          log("Length of addGuideline is:: ${snapshot.data!.length}");
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8.0),
                            itemCount: addGuideline.length,
                            itemBuilder: (ctx, index) {
                              AddGuideline model = addGuideline[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTextWidget(text: 'Guideline: ${index + 1}',fontSize: 16,fontWeight: FontWeight.w600,),
                                  Row(
                                    children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1.w, vertical: 0.5.h),
                                          child: AppTextWidget(
                                              text: model.question,
                                              textAlign: TextAlign.start,
                                              color: const Color(0xff5B5B5B),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1.w, vertical: 0.5.h),
                                          child: SizedBox(
                                            width: 50.w,
                                            child: AppTextWidget(
                                              maxLines: 15,
                                                text: model.answer,
                                                textAlign: TextAlign.start,
                                                color: const Color(0xff5B5B5B),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                      const Spacer(),
                                      // Update Icon
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: secondaryColor),
                                        onPressed: () {
                                          // _updateMilestone(context, model.id);
                                          _questionController.text = model.question;
                                          _answerController.text = model.answer;
                                          action.setEditingMode(model.id);
                                          _scrollToTextField();

                                        },
                                      ),

                                      // Delete Icon
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: primaryColor),
                                        onPressed: () async {
                                          bool confirmDelete = await _showDeleteConfirmationDialog(context);
                                          if (confirmDelete) {
                                            action.deleteItem('guideline', model.id);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey[300],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],),
            )
          ],
        ),
      ),
    );
  }
  void _publishFAQ() async {
    ActionProvider.startLoading();
    if (_questionController.text.isEmpty || _questionController.text.isEmpty) {
      AppUtils().showToast(text: 'Please enter the text');
      ActionProvider.stopLoading();
      return;  // Stop execution if the text is empty
    }

    try {
      var id = FirebaseFirestore.instance.collection('guideline').doc().id;  // Generate the document ID
      await FirebaseFirestore.instance.collection('guideline').doc(id).set({
        'question': _questionController.text,  // Ensure the controller text is used
        'answer': _answerController.text,  // Ensure the controller text is used
        'id': id,
        'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
      });
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'guideline updated successfully');
      _questionController.clear();
      _answerController.clear();
    } catch (e) {
      log("Error updating guideline: $e");  // Log the error
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Failed to update guideline');
    }
  }
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete!'),
          content: const Text('Are you sure you want to delete?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  void _scrollToTextField() {
    // Scroll to the TextField position
    _scrollController.animateTo(
      10.0, // Adjust this value based on your layout
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  void _updateFaq(BuildContext context, String id) {
    FirebaseFirestore.instance.collection('guideline').doc(id).update({
      'question': _questionController.text,
      'answer': _answerController.text,
    }).then((value) {
      _questionController.clear();
      _answerController.clear();
      Provider.of<ActionProvider>(context, listen: false).resetMode();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Updated successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Update: $error')),
      );
    });
  }
}
