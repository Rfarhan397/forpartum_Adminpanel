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

class AddNewFaq extends StatelessWidget {
   AddNewFaq({super.key});

   TextEditingController _questionController =  TextEditingController();
   TextEditingController _answerController =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppbar(text: 'FAQ'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 4.w, vertical:6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              AppTextWidget(text: 'Question'),
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
                  height: 50.h,
                  width: 40.w,// 50% of screen height
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
                Align(
                  alignment: Alignment.centerRight,
                  child: ButtonWidget(
                      text: 'Publish',
                      onClicked: () {
                        _publishFAQ();
                      },
                      width: 100,
                      height: 35,
                      fontWeight: FontWeight.normal),
                )
            ],),
          )
        ],
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
      var id = FirebaseFirestore.instance.collection('faq').doc().id;  // Generate the document ID
      await FirebaseFirestore.instance.collection('faq').doc(id).set({
        'question': _questionController.text,  // Ensure the controller text is used
        'answer': _answerController.text,  // Ensure the controller text is used
        'id': id,
        'created_at': DateTime.now(),
      });
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Privacy updated successfully');
      _questionController.clear();
      _answerController.clear();
    } catch (e) {
      log("Error updating privacy policy: $e");  // Log the error
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Failed to update privacy policy');
    }
  }
}
