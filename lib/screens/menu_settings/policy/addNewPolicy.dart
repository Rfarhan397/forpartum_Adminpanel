import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/constant/app_utils.dart';
import 'package:sizer/sizer.dart';

import '../../../constant.dart';
import '../../../model/res/components/custom_appBar.dart';
import '../../../model/res/widgets/app_text.dart.dart';
import '../../../model/res/widgets/button_widget.dart';
import '../../../provider/action/action_provider.dart';

class AddNewPolicy extends StatelessWidget {
   AddNewPolicy({super.key});

  TextEditingController _policyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppbar(text: 'Privacy Policy'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
          Padding(
            padding:  EdgeInsets.only(left: 2.w,top:7.h ),
            child: Column(
              children: [
               Container(
                width: 40.w,
                 child: Column(
                   children: [
                     Container(
                       // height: 20.h,
                       width: 70.w,// 50% of screen height
                       decoration: BoxDecoration(
                         border: Border.all(color: Colors.black.withOpacity(0.8)),
                         borderRadius: BorderRadius.circular(12),
                       ),
                       child:  TextField(
                         maxLines: null, // Allows the text to wrap within the height
                         expands: true,  // Expands the TextField to fill the parent container
                         controller: _policyController,
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
                     SizedBox(height: 4.h,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         ButtonWidget(text: 'Save As Draft', onClicked: () {

                         },
                             borderColor: secondaryColor,
                             width: 120,backgroundColor: secondaryColor,
                             oneColor: true, height: 35, fontWeight: FontWeight.normal),
                         SizedBox(width: 2.w,),
                         ButtonWidget(text: 'Publish', onClicked: () {
                           _publishPolicy();

                         },
                             borderColor: secondaryColor,
                             width: 100,height: 35, fontWeight: FontWeight.normal),
                       ],
                     ),
                   ],
                 ),
               )
              ],
            ),
          )
        ],
      ),
    );
  }

   void _publishPolicy() async {
     ActionProvider.startLoading();
     if (_policyController.text.isEmpty) {
       ActionProvider.stopLoading();
       AppUtils().showToast(text: 'Please enter the privacy policy text');
       return;  // Stop execution if the text is empty

     }

     try {
       var id = FirebaseFirestore.instance.collection('privacy').doc().id;  // Generate the document ID
       await FirebaseFirestore.instance.collection('privacy').doc(id).set({
         'privacy': _policyController.text,  // Ensure the controller text is used
         'id': id,
         'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
       });
       ActionProvider.stopLoading();
       AppUtils().showToast(text: 'Privacy updated successfully');
       _policyController.clear();
     } catch (e) {
       ActionProvider.stopLoading();  // Stop the loading spinner if there's an error'
       log("Error updating privacy policy: $e");  // Log the error
       AppUtils().showToast(text: 'Failed to update privacy policy');
     }
   }


}
