import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

class PrivacyScreen extends StatelessWidget {
  PrivacyScreen({super.key});
  TextEditingController _policyController = TextEditingController();
  TextEditingController _scrollController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final action = Provider.of<ActionProvider>(context);

    return Scaffold(
      appBar: const CustomAppbar(text: 'Privacy Policy'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(18.0),
            //   child: Row(
            //     children: [
            //       InkWell(
            //         hoverColor: Colors.transparent,
            //           highlightColor: Colors.transparent,
            //           splashColor: Colors.transparent,
            //         onTap: () {
            //           Provider.of<MenuAppController>(context, listen: false)
            //               .changeScreen(22);
            //         },
            //         child: AddButton(text: 'Add New Policy')
            //       ),
            //       SizedBox(
            //         width: 2.w,
            //       ),
            //       InkWell(
            //         hoverColor: Colors.transparent,
            //         highlightColor: Colors.transparent,
            //         splashColor: Colors.transparent,
            //         onTap: () {
            //          // _showEditDialog(context, docId, privacyPolicy);
            //         },
            //         child: AddButton(text: 'Edit')
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(left: 2.w, top: 7.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextWidget(
                      text: 'Add New Policy:',
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                  SizedBox(height: 1.h,),
                  Container(
                    width: 40.w,
                    child: Column(
                      children: [
                        Container(
                          // height: 20.h,
                          width: 70.w, // 50% of screen height
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black.withOpacity(0.8)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IntrinsicHeight(
                            child: TextField(
                              maxLines:
                                  null, // Allows the text to wrap within the height
                              expands:
                                  true, // Expands the TextField to fill the parent container
                              controller: _policyController,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(12.0),
                                  border: InputBorder.none,
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
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
                                        _publishPolicy();
                                      } else {
                                        _updatePolicy(context, value.editingId!);
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
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('privacy').snapshots(),
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
                    return const Center(child: Text('No privacy policies found'));
                  }
        
                  // Data exists, build the list
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(
                        text: 'Recent Privacy Policies',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var document = snapshot.data!.docs[index];
                          var privacyPolicy = document[
                              'text']; // Assuming 'privacy' is the field storing the policy
                          var createdAt = (document['created_at']
                              .toString()); // Convert Timestamp to DateTime
        
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: AppTextWidget(
                                text: privacyPolicy,
                                maxLines: 80,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                              subtitle: AppTextWidget(
                                text: 'Published on: ${createdAt.toString()}',
                                maxLines: 80,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                              trailing: SizedBox(
                                height: 50,
                                width: 20.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: secondaryColor),
                                      onPressed: () {
                                        _policyController.text = document['text'];
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
                                          action.deleteItem('privacy', document['id']);
                                        }
                                      },
                                    ),
                                  ],
                                ),
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

  void _publishPolicy() async {
    ActionProvider.startLoading();
    if (_policyController.text.isEmpty) {
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Please enter the privacy policy text');
      return; // Stop execution if the text is empty
    }

    try {
      var id = FirebaseFirestore.instance
          .collection('privacy')
          .doc()
          .id; // Generate the document ID
          await FirebaseFirestore.instance.collection('privacy').doc(id).set({
        'text': _policyController.text, // Ensure the controller text is used
        'id': id,
        'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
      });
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Privacy updated successfully');
      _policyController.clear();
    } catch (e) {
      ActionProvider
          .stopLoading(); // Stop the loading spinner if there's an error'
      log("Error updating privacy policy: $e"); // Log the error
      AppUtils().showToast(text: 'Failed to update privacy policy');
    }
  }
  void _updatePolicy(BuildContext context, String id) {
    FirebaseFirestore.instance.collection('privacy').doc(id).update({
      'text': _policyController.text,
    }).then((value) {
      _policyController.clear();
      Provider.of<ActionProvider>(context, listen: false).resetMode();
      AppUtils().showToast(text: 'Updated successfully!');
    }).catchError((error) {
      AppUtils().showToast(text: 'Failed to Update: $error');

    });
  }
  void _showEditDialog(
      BuildContext context, String docId, String currentPolicy) {
    final TextEditingController _editController =
        TextEditingController(text: currentPolicy);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Privacy Policy'),
          content: TextField(
            controller: _editController,
            maxLines: 5,
            decoration:
                const InputDecoration(hintText: 'Enter updated privacy policy'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String updatedPolicy = _editController.text.trim();

                // Ensure the user entered some text
                if (updatedPolicy.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('privacy')
                        .doc(docId)
                        .update({'privacy': updatedPolicy});

                    Navigator.of(context).pop(); // Close dialog
                    AppUtils()
                        .showToast(text: 'Privacy policy updated successfully');
                  } catch (e) {
                    log("Error updating policy: $e");
                    AppUtils().showToast(text: 'Failed to update policy');
                  }
                } else {
                  AppUtils().showToast(text: 'Policy text cannot be empty');
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
