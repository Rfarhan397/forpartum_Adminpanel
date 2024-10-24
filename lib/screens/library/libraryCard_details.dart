import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/main.dart';
import 'package:forpartum_adminpanel/model/blog_post/blog_model.dart';
import 'package:forpartum_adminpanel/model/res/constant/app_utils.dart';
import 'package:forpartum_adminpanel/provider/action/action_provider.dart';
import 'package:forpartum_adminpanel/provider/milestone/mileStoneProvider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/app_text_field.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/chip/chip_provider.dart';
import '../../provider/stream/streamProvider.dart';

class LibraryCardDetails extends StatelessWidget {
  LibraryCardDetails({super.key});
  final List<String> categories = [
    '1-12 Months Postpartum ',
    '12-24 Months Postpartum ',
    '24-36+ Months Postpartum ',
  ];
  TextEditingController milestoneController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final milestone = Provider.of<MilestoneProvider>(context);
    final action = Provider.of<ActionProvider>(context);

    return Scaffold(
        appBar: const CustomAppbar(text: 'Milestone Tracker'),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(
                height: 1.0,
                color: Colors.grey[300],
              ),
              SizedBox(height: 1.h),
              // Padding(
              //   padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: categories.map((category) {
              //       final isSelected =
              //           chipProvider.selectedCategory == category;
              //       final isHovered = chipProvider.hoveredCategory == category;
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //         child: MouseRegion(
              //           onEnter: (_) {
              //             chipProvider.setHoveredCategory(category);
              //           },
              //           onExit: (_) {
              //             chipProvider.clearHoveredCategory();
              //           },
              //           child: GestureDetector(
              //             onTap: () {
              //               chipProvider.selectCategory(category);
              //             },
              //             child: Container(
              //               padding: const EdgeInsets.symmetric(
              //                   vertical: 5.0, horizontal: 14.0),
              //               decoration: BoxDecoration(
              //                 color: isSelected
              //                     ? primaryColor
              //                     : isHovered
              //                         ? primaryColor
              //                         : secondaryColor,
              //                 borderRadius: BorderRadius.circular(8.0),
              //               ),
              //               child: AppTextWidget(
              //                 text: category,
              //                 color: isSelected
              //                     ? Colors.white
              //                     : isHovered
              //                         ? Colors.white
              //                         : Colors.white,
              //                 fontWeight: FontWeight.w400,
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     }).toList(),
              //   ),
              // ),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    width: 30.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                        Consumer<StreamDataProvider>(
                          builder: (context, provider, child) {
                            return StreamBuilder<List<AddMilestone>>(
                              stream: provider.getMilestones(),
                              builder: (context, snapshot) {

                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                }
                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Center(child: Text('No milestone found'));
                                }

                                List<AddMilestone> addMilestone = snapshot.data!;
                                log("Length of milestone is:: ${snapshot.data!.length}");
                                return ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8.0),
                                  itemCount: addMilestone.length,
                                  itemBuilder: (ctx, index) {
                                    AddMilestone model = addMilestone[index];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                       Row(
                                         children: [
                                           Padding(
                                             padding: EdgeInsets.symmetric(
                                                 horizontal: 3.w, vertical: 0.5.h),
                                             child: AppTextWidget(
                                                 text: model.title.capitalize!,
                                                 textAlign: TextAlign.start,
                                                 color: Color(0xff5B5B5B),
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 12),
                                           ),
                                           Spacer(),
                                           // Update Icon
                                           IconButton(
                                             icon: Icon(Icons.edit, color: secondaryColor),
                                             onPressed: () {
                                               // _updateMilestone(context, model.id);
                                               milestoneController.text = model.title;
                                               action.setEditingMode(model.id);
                                               _scrollToTextField();

                                             },
                                           ),

                                           // Delete Icon
                                           IconButton(
                                             icon: Icon(Icons.delete, color: primaryColor),
                                             onPressed: () async {
                                               bool confirmDelete = await _showDeleteConfirmationDialog(context);
                                               if (confirmDelete) {
                                                 action.deleteItem('milestones', model.id);
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
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w,),
                  SizedBox(
                      width: 25.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const AppTextWidget(text:
                            'Add New Milestone',
                                fontSize: 14, fontWeight: FontWeight.bold),
                          const SizedBox(height: 20),
                           AppTextField(
                            controller: milestoneController,
                            radius: 8,
                              hintText: 'Postpartum Nutrition',
                          ),
                          SizedBox(height: 15.h,),
                          Consumer<ActionProvider>(
                            builder: (context, value, child) {
                              return  Align(
                                alignment: Alignment.centerRight,
                                child: ButtonWidget(
                                    text: value.buttonText,
                                    onClicked: () {
                                      if (value.editingId == null) {
                                        uploadMilestone(context);
                                      } else {
                                        updateMilestone(context,value.editingId!);
                                      }

                                    },
                                    width: 10.w, height: 5.h, fontWeight: FontWeight.w500),
                              );
                            },
                          )

                        ],
                      )),
                ]),
              )
            ])));
  }

  void uploadMilestone(BuildContext context) {
    var chipProvider = Provider.of<ChipProvider>(context, listen: false);
    var id = FirebaseFirestore.instance.collection('milestones').doc().id.toString();

    try {
      ActionProvider.startLoading();
      FirebaseFirestore.instance.collection('milestones').doc(id).set({
        'months': chipProvider.selectedCategory,
        'title': milestoneController.text,
        "id": id.toString(),
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'status': 'all',
      }).then((_) {
        // Handle success here, like showing a message or performing navigation.
        AppUtils().showToast(text: 'Milestone uploaded successfully');
        milestoneController.clear();
        ActionProvider.stopLoading();
      });
    } catch (e) {
      // Handle any errors here
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Failed to upload milestone: $e');
    }
  }
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Milestone'),
          content: Text('Are you sure you want to delete this milestone?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  void updateMilestone(BuildContext context, String id) {
    FirebaseFirestore.instance.collection('milestones').doc(id).update({
      'title': milestoneController.text,
    }).then((value) {
      milestoneController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Milestone updated successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update Milestone: $error')),
      );
    });
  }
  void _scrollToTextField() {
    // Scroll to the TextField position
    _scrollController.animateTo(
      10.0, // Adjust this value based on your layout
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
