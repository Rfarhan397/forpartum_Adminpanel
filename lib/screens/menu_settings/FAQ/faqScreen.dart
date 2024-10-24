import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/components/add_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constant.dart';
import '../../../controller/menu_App_Controller.dart';
import '../../../model/res/components/custom_appBar.dart';
import '../../../model/res/constant/app_utils.dart';
import '../../../model/res/routes/routes_name.dart';
import '../../../model/res/widgets/app_text.dart.dart';
import '../../../model/res/widgets/app_text_field.dart';
import '../../../model/res/widgets/button_widget.dart';
import '../../../provider/action/action_provider.dart';
import '../../../provider/libraryCard/card_provider.dart';

class FaqScreen extends StatelessWidget {
   FaqScreen({super.key});
  TextEditingController _questionController =  TextEditingController();
  TextEditingController _answerController =  TextEditingController();
   final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final action = Provider.of<ActionProvider>(context);
    return Scaffold(
      appBar: CustomAppbar(text: 'FAQ',),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 4.w, vertical:3.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Provider.of<MenuAppController>(context, listen: false)
                    //     .changeScreen(21);
                  },
                  child:
                  AddButton(text: 'Add New FAQ')
                ),
                SizedBox(height: 4.h,),
                Column(
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
                      height: 20.h,
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
                    )
                  ],),
                SizedBox(height: 4.h,),
                AppTextWidget(text: "FAQ's:",fontSize: 16,color: Colors.black,fontWeight: FontWeight.w700,),
                Container(
                  width: 45.w,
                  child: Column(
                    children: [
                      SizedBox(height: 2.h,),
                      Divider(
                        height: 1.0,
                        color: Colors.grey.shade300,
                      ),
                      StreamBuilder(
                        stream:  FirebaseFirestore.instance.collection('faq').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          // Check for errors
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }

                          // Check if the data is empty
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text('No privacy policies found'));
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var document = snapshot.data!.docs[index];
                              var question = document['question'];
                              var answer = document['answer'];
                              return Consumer<FaqProvider>(
                                builder: (context, faqProvider, child) {
                                  final isExpanded = faqProvider.expanded[index];
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          faqProvider.toggleExpand(index);
                                        },
                                        child: ListTile(
                                          title: AppTextWidget(
                                            text: question,
                                            textAlign: TextAlign.start,
                                            fontSize: 14,
                                          ),
                                          trailing: Icon(Icons.add,color: Color(0xff8C8C8C),size: 15,),
                                        ),
                                      ),
                                      if (isExpanded)
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 16.0,left: 16.0,bottom: 15.0),
                                              child: AppTextWidget(
                                                text: answer,
                                                textAlign: TextAlign.start,
                                                fontSize: 14,
                                                color: Color(0xff585858),
                                                maxLines: 30,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit, color: secondaryColor),
                                                  onPressed: () {
                                                    // _updateMilestone(context, model.id);
                                                    _questionController.text = document['question'];
                                                    _answerController.text = document['answer'];
                                                    action.setEditingMode(document['id']);
                                                    action.scrollToTextField(_scrollController);

                                                  },
                                                ),

                                                // Delete Icon
                                                IconButton(
                                                  icon: const Icon(Icons.delete, color: primaryColor),
                                                  onPressed: () async {
                                                    bool confirmDelete = await action.showDeleteConfirmationDialog(context,'Delete!','Are you sure you want to delete?');
                                                    if (confirmDelete) {
                                                      action.deleteItem('faq', document['id']);
                                                    }
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      Container(
                                        height: 1.0,
                                        color: Colors.grey.shade300,
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
               // FaqWidget(),
              ],
            ),
          ),
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
       var id = FirebaseFirestore.instance.collection('faq').doc().id;  // Generate the document ID
       await FirebaseFirestore.instance.collection('faq').doc(id).set({
         'question': _questionController.text,  // Ensure the controller text is used
         'answer': _answerController.text,  // Ensure the controller text is used
         'id': id,
         'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
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
   void _updateFaq(BuildContext context, String id) {
     FirebaseFirestore.instance.collection('faq').doc(id).update({
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
