import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:forpartum_adminpanel/model/res/components/add_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../constant.dart';
import '../../../controller/menu_App_Controller.dart';
import '../../../model/res/components/custom_appBar.dart';
import '../../../model/res/constant/app_utils.dart';
import '../../../model/res/routes/routes_name.dart';
import '../../../model/res/widgets/app_text.dart.dart';
import '../../../model/res/widgets/button_widget.dart';
import '../../../provider/action/action_provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../../provider/meal/mealProvider.dart';



class DisclaimerScreen extends StatelessWidget {
   DisclaimerScreen({super.key});
  TextEditingController _policyController = TextEditingController();
  TextEditingController _scrollController = TextEditingController();
   final quill.QuillController _quillController = quill.QuillController.basic();

  @override
  Widget build(BuildContext context) {
    final action = Provider.of<ActionProvider>(context,);
    final mealProvider = Provider.of<MealProvider>(context);


    return Scaffold(
      appBar: const CustomAppbar(text: 'Disclaimer'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            Container(
              width: 70.w,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 2.w, top: 7.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 1.h,),
                        _buildSelectButton(
                          context: context,
                          title: "Disclaimer",
                          heading: "Select:",

                          value: mealProvider.selectedDisclaimer,
                          options: ['Disclaimer', 'Reference', 'About App'],
                          onSelected: (value) => mealProvider.setDisclaimer(value),
                        ),
                        SizedBox(height: 1.h,),
                        AppTextWidget(
                            text: 'Add New Disclaimer:',
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                        SizedBox(height: 1.h,),
                        QuillSimpleToolbar(
                          controller: _quillController,
                          configurations: const QuillSimpleToolbarConfigurations(

                            showUnderLineButton: false,
                            showClearFormat: false,
                            showDirection: false,
                            showFontFamily: false,
                            showSuperscript: false,
                            showSubscript: false,
                            showStrikeThrough: false,
                            showSmallButton: false,
                            showSearchButton: false,
                            showUndo: false,
                            showRedo: false,
                            showQuote: false,
                            showListNumbers: true,
                            showFontSize: false,
                            showColorButton: false,
                            showBackgroundColorButton: false,
                            showHeaderStyle: false,
                            showListCheck: false,
                            showCodeBlock: false,
                            showLink: true,
                            showIndent: true,
                            showClipboardCut: false,
                            showClipboardCopy: false,
                            showClipboardPaste: false,

                          ),
                        ),
                        Container(
                          height: 50.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: quill.QuillEditor(
                              controller: _quillController,
                              scrollController: ScrollController(),
                              // scrollable: true,
                              focusNode: FocusNode(),
                              // autoFocus: false,
                              // readOnly: false,
                              // expands: true,
                              // padding: Ed/geInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h,),
                  Container(
                    width: 47.w
,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 2.w,
                        ),
                        Consumer<ActionProvider>(
                          builder: (context, value, child) {
                            return ButtonWidget(
                                isShadow: true,
                                text: value.publishText,
                                onClicked: () {
                                  if (value.editingId == null) {
                                    _publishAppContent(context);
                                  } else {
                                    _updateAppContent(context, value.editingId!);
                                  }
                                },
                                borderColor: secondaryColor,
                                width: 100,
                                height: 35,
                                fontWeight: FontWeight.normal);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
            SizedBox(height: 2.h,),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('AppContent')
                    .where('type',isEqualTo: mealProvider.selectedDisclaimer )
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  // Check for loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Check for errors
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  // Check if the data is empty
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No App Content found'));
                  }

                  // Data exists, build the list
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(
                        text: 'Recent Content:',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var document = snapshot.data!.docs[index];
                          var createdAtString = (document['created_at']).toString();
                          final quillDocument = Document.fromJson(jsonDecode(document['text']));

                          var createdAt = DateTime.fromMillisecondsSinceEpoch(int.parse(createdAtString)); // Convert to DateTime
                          var formattedDate = '${createdAt.day}/${createdAt.month}/${createdAt.year}';

                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTextWidget(text: 'App content : ${index + 1}',fontSize: 16,fontWeight: FontWeight.w600,),
                                   SizedBox(height: 1.h),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            QuillEditor.basic(
                                              controller: QuillController(
                                                document: quillDocument,
                                                readOnly: true,
                                                selection: const TextSelection.collapsed(offset: 0),
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            AppTextWidget(
                                              text: 'Published on: ${formattedDate.toString()}',
                                              textAlign: TextAlign.start,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 2.w,),
                                      SizedBox(
                                        height: 50,
                                        width: 20.w,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, color: secondaryColor),
                                              onPressed: () {
                                                _quillController.document = quillDocument;
                                                action.setEditingMode(document['type']);
                                                action.scrollToTextField(_scrollController);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: primaryColor),
                                              onPressed: () async {
                                                bool confirmDelete = await action.showDeleteConfirmationDialog(
                                                  context,
                                                  'Delete!',
                                                  'Are you sure you want to delete?',
                                                );
                                                if (confirmDelete) {
                                                  action.deleteItem('AppContent', document['type']);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );

                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
   Widget _buildSelectButton({
     required BuildContext context,
     required String title,
     required String heading,
     required String? value,
     required List<String> options,
     required Function(String) onSelected,
   }) {
     return Row(
       children: [
         AppTextWidget(
           text: heading,
           fontSize: 18,
           fontWeight: FontWeight.w500,
         ),
         SizedBox(width: 2.h),
         Container(
           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
           decoration: BoxDecoration(
             color: Theme.of(context).primaryColor,
             borderRadius: BorderRadius.circular(12),
           ),
           child: DropdownButton<String>(
             value: options.contains(value) ? value : null,
             hint: Text(
               title,
               style: const TextStyle(color: Colors.white),
             ),
             dropdownColor: Theme.of(context).primaryColor,
             style: const TextStyle(color: Colors.white),
             underline: const SizedBox.shrink(),
             icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
             items: options
                 .map(
                   (option) => DropdownMenuItem<String>(
                 value: option,
                 child: Text(option, style: const TextStyle(color: Colors.white)),
               ),
             )
                 .toList(),
             onChanged: (newValue) => onSelected(newValue!),
           ),
         ),
       ],
     );
   }

   void _publishAppContent(BuildContext context) async {
     final mealProvider = Provider.of<MealProvider>(context, listen: false);
     ActionProvider.startLoading();

     // Validate input
     if (_quillController.document.isEmpty()) {
       ActionProvider.stopLoading();
       AppUtils().showToast(text: 'Please enter the disclaimer content.');
       return;
     }

     if (mealProvider.selectedDisclaimer == null || mealProvider.selectedDisclaimer!.isEmpty) {
       ActionProvider.stopLoading();
       AppUtils().showToast(text: 'Please select a disclaimer type.');
       return;
     }

     String contentJson = jsonEncode(_quillController.document.toDelta().toJson());
     log('Content JSON: $contentJson');

     try {
       await FirebaseFirestore.instance.collection('AppContent').doc(mealProvider.selectedDisclaimer).set({
         'text': contentJson,
         'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
         'type': mealProvider.selectedDisclaimer,
       });

       ActionProvider.stopLoading();
       AppUtils().showToast(text: 'Disclaimer added successfully.');
       _quillController.clear(); // Clear the content
       mealProvider.clearDisclaimer(); // Reset the disclaimer type
     } catch (e) {
       ActionProvider.stopLoading();
       log("Error while adding disclaimer: $e");
       AppUtils().showToast(text: 'Failed to add disclaimer. Try again.');
     }
   }
   void _updateAppContent(BuildContext context, String id) async {
     final mealProvider = Provider.of<MealProvider>(context, listen: false);

     ActionProvider.startLoading();

     if (_quillController.document.isEmpty()) {
       ActionProvider.stopLoading();
       AppUtils().showToast(text: 'Please enter the disclaimer content.');
       return;
     }

     String contentJson = jsonEncode(_quillController.document.toDelta().toJson());
     log('Updated Content JSON: $contentJson');

     try {
       await FirebaseFirestore.instance.collection('AppContent').doc(mealProvider.selectedDisclaimer).update({
         'text': contentJson,
       });

       ActionProvider.stopLoading();
       AppUtils().showToast(text: 'Disclaimer updated successfully.');
       _quillController.clear(); // Clear the content
       Provider.of<ActionProvider>(context, listen: false).resetMode();
     } catch (e) {
       ActionProvider.stopLoading();
       log("Error while updating disclaimer: $e");
       AppUtils().showToast(text: 'Failed to update disclaimer. Try again.');
     }
   }

}
