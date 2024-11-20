import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/widgets/button_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/hover_button_loader.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/dropDOwn/dropdown.dart';
import '../../provider/libraryCard/card_provider.dart';
import '../../provider/user_provider/user_provider.dart';

class InsightScreen extends StatelessWidget {
  InsightScreen({super.key});

  final TextEditingController _answerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> categories = [
    'Hair and skin',
    'Hot flashes',
    'Breast',
    'Cardiovascular',
    'Uterus',
    'Abdominal wall',
    'Fluids',
    'GI Rectal',
    'Shivering',
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final drop = Provider.of<DropdownProviderN>(context);
    final action = Provider.of<ActionProvider>(context);

    final users = userProvider.users;
    final activeUsersCount = users.where((user) => user.status == 'isActive').length;
    final totalUsersCount = users.length;

    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;
    final dataP = Provider.of<MenuAppController>(context);

    final newSignupsCount = users.where((user) {
      final createdAtTimestampString = user.createdAt;
      if (createdAtTimestampString != null) {
        final createdAtTimestamp = int.tryParse(createdAtTimestampString);
        if (createdAtTimestamp != null) {
          final createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtTimestamp);
          return createdAt.month == currentMonth && createdAt.year == currentYear;
        }
      }
      return false;
    }).length;

    return Scaffold(
      appBar: CustomAppbar(text: 'Insights Overview'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                child: SizedBox(
                  width: 50.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(
                        text: 'Insights:',
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 2.h),
                      AppTextWidget(
                        text: 'Type:',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryColor),
                        ),
                        child: DropdownButton<String>(
                          underline: SizedBox.shrink(),
                          style: TextStyle(color: Colors.black),
                          dropdownColor: Colors.white,
                          value: drop.selectedInsightCategory,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              drop.setSelectedInsightsCategory(newValue);
                            }
                          },
                          items: categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          icon: Icon(Icons.keyboard_arrow_down_outlined, color: primaryColor),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      AppTextWidget(
                        text: 'Description:',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        height: 15.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black.withOpacity(0.8)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          maxLines: null,
                          expands: true,
                          controller: _answerController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Consumer<ActionProvider>(
                        builder: (context, value, child) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: ButtonWidget(
                                text: value.publishText,
                                oneColor: true,
                                onClicked: () async{
                                  if (value.editingId == null) {
                                    await _publishInsight(context, dataP.parameters!.uid.toString());
                                  } else {
                                    //update
                                    log("Running update");
                                    _updateInsight(context, dataP.parameters!.uid.toString());
                                  }
                                },
                                width: 100,
                                height: 35,
                                fontWeight: FontWeight.normal),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(height: 4.h,),
              AppTextWidget(text: "${dataP.parameters!.name}'s Insights:",fontSize: 16,color: Colors.black,fontWeight: FontWeight.w700,),
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
                      stream:  FirebaseFirestore.instance.collection('users').doc(dataP.parameters!.uid).collection('insights').snapshots(),
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
                          return const Center(child: Text('No insights found'));
                        }
                        var data = snapshot.data!.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var document = snapshot.data!.docs[index];
                            var question = document['question'];
                            var answer = document['answer'];
                            return Consumer<FaqProvider>(
                              builder: (context, faqProvider, child) {
                                final isExpanded = faqProvider.expandedd[index];
                                return Column(
                                  children: [
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        faqProvider.toggleExpandd(index);
                                      },
                                      child: ListTile(
                                        title: AppTextWidget(
                                          text: question,
                                          textAlign: TextAlign.start,
                                          fontSize: 14,
                                        ),
                                        trailing: Icon(Icons.keyboard_arrow_down_outlined,color: Color(0xff8C8C8C),size: 15,),
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
                                                  drop.setSelectedInsightsCategory(document['question']);
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
                                                    log('uid is:: ${dataP.parameters!.uid}');
                                                    log('id is:: ${document['id']}');
                                                    deleteItem( dataP.parameters!.uid.toString(),drop.selectedInsightCategory);
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
              ),            ],
          ),
        ),
      ),
    );
  }
  void deleteItem(String id,inId) {
    FirebaseFirestore.instance.collection('users').doc(id)
        .collection('insights').doc(inId).delete().then((value) {
      // Success
    }).catchError((error) {
      // Handle error
    });
  }
   _publishInsight(BuildContext context, String userId) async {
    final drop = Provider.of<DropdownProviderN>(context, listen: false);
    ActionProvider.startLoading();

    if (_answerController.text.isEmpty) {
      AppUtils().showToast(text: 'Please enter a description');
      ActionProvider.stopLoading();
      return;
    }

    try {
      var id = FirebaseFirestore.instance.collection('users').doc(userId).collection('insights').doc().id;
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('insights').doc(drop.selectedInsightCategory).set({
        'question': drop.selectedInsightCategory,
        'answer': _answerController.text,
        'id': id,
        'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Insight added successfully');
      _answerController.clear();
    } catch (e) {
      log("Error adding insight: $e");
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Failed to add insight');
    }
  }
  void _updateInsight(BuildContext context, String id) {
    var drop = Provider.of<DropdownProviderN>(context,listen: false);
    FirebaseFirestore.instance.collection('users').doc(id).collection('insights').doc(drop.selectedInsightCategory).update({
      'question': drop.selectedInsightCategory,
      'answer': _answerController.text,
    }).then((value) {
      _answerController.clear();
      // Provider.of<ActionProvider>(context, listen: false).resetMode();
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
// class InsightScreen extends StatelessWidget {
//   InsightScreen({super.key});
//
//   TextEditingController _questionController = TextEditingController();
//   TextEditingController _answerController = TextEditingController();
//
//   final List<String> categories = [
//     'Hair and skin',
//     'Hot flashes',
//     'Breast',
//     'Cardiovascular',
//     'Uterus',
//     'Abdominal wall',
//     'Fluids',
//     'GI/Rectal',
//     'Shivering',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     final drop = Provider.of<DropdownProviderN>(context);
//
//     final users = userProvider.users;
//     final activeUsersCount = users.where((user) => user.status == 'isActive').length;
//     final totalUsersCount = users.length;
//     // Get the current month and year
//     final currentMonth = DateTime.now().month;
//     final currentYear = DateTime.now().year;
//     final dataP = Provider.of<MenuAppController>(context);
//     // Filter users who created their accounts in the current month
//     final newSignupsCount = users.where((user) {
//       final createdAtTimestampString = user.createdAt; // Assuming createdAt is a String?
//       if (createdAtTimestampString != null) {
//         final createdAtTimestamp = int.tryParse(createdAtTimestampString);
//         if (createdAtTimestamp != null) {
//           final createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtTimestamp);
//           return createdAt.month == currentMonth && createdAt.year == currentYear;
//         }
//       }
//       return false;
//     }).length;
//
//     return Scaffold(
//       appBar: CustomAppbar(text: 'Insights Overview'),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Divider(
//               height: 1,
//               color: Colors.grey[300],
//             ),
//             Padding(
//               padding:
//               const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Container(
//                   //   width: 80.w,
//                   //   child: Row(
//                   //     crossAxisAlignment: CrossAxisAlignment.start,
//                   //     mainAxisAlignment: MainAxisAlignment.start,
//                   //     children: [
//                   //       StatsCard(
//                   //         iconPath: AppIcons.totalUsers,
//                   //         iconBackgroundColor: secondaryColor,
//                   //         title: 'Total Users',
//                   //         count: totalUsersCount.toString(),
//                   //         width: 14.w,
//                   //       ),
//                   //       StatsCard(
//                   //         iconPath: AppIcons.activeUser,
//                   //         iconBackgroundColor: primaryColor,
//                   //         title: 'Active Users',
//                   //         count: activeUsersCount.toString(),
//                   //         width: 14.w,
//                   //       ),
//                   //       // StatsCard(
//                   //       //   iconPath: AppIcons.time,
//                   //       //   iconBackgroundColor: secondaryColor,
//                   //       //   title: 'Avg Engagement',
//                   //       //   count: '75%',
//                   //       //   width: 14.w,
//                   //       // ),
//                   //       StatsCard(
//                   //         iconPath: AppIcons.feedback,
//                   //         iconBackgroundColor: primaryColor,
//                   //         title: 'New Sign Ups:',
//                   //         count: newSignupsCount.toString(),
//                   //         width: 14.w,
//                   //       ),
//                   //       // StatsCard(
//                   //       //   iconPath: AppIcons.feedback,
//                   //       //   iconBackgroundColor: primaryColor,
//                   //       //   title: 'Returning Users',
//                   //       //   count: '750',
//                   //       //   width: 14.w,
//                   //       // ),
//                   //     ],
//                   //   ),
//                   // ),
//                   SizedBox(height: 2.h),
//                   Padding(
//                     padding:
//                     EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
//                     child: SizedBox(
//                       width: 50.w,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppTextWidget(
//                             text: 'Insights:',
//                             fontSize: 22,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           SizedBox(
//                             height: 2.h,
//                           ),
//                           AppTextWidget(text: 'Type:',fontWeight: FontWeight.w500,fontSize: 16,),
//                           SizedBox(
//                             height: 1.h,
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 8),
//                             decoration:
//                             BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(
//                                     color: primaryColor
//                                 )
//                             ),
//                             child: DropdownButton<String>(
//                               underline: SizedBox.shrink(),
//                               style: TextStyle(
//                                   color: whiteColor
//                               ),
//                               dropdownColor: primaryColor,
//                               value: drop.selectedInsightCategory,
//                               onChanged: (String? newValue) {
//                                 if (newValue != null) {
//                                   drop.setSelectedInsightsCategory(newValue);
//                                 }
//                               },
//                               items: categories.map((String category) {
//                                 return DropdownMenuItem<String>(
//                                   value: category,
//                                   child: Text(category,style: TextStyle(color: Colors.black),),
//                                 );
//                               }).toList(),
//                               icon: Icon(Icons.keyboard_arrow_down_outlined,color: primaryColor,),
//                             ),
//                           ),
//                           // Container(
//                           //   height: 8.h,
//                           //   width: 25.w,
//                           //   child: AppTextFieldBlue(
//                           //     controller: _questionController,
//                           //     hintText: 'How do I use?',
//                           //     radius: 5,
//                           //   ),
//                           // ),
//                           SizedBox(
//                             height: 1.h,
//                           ),
//                           AppTextWidget(text: 'Description:',fontWeight: FontWeight.w500,fontSize: 16,),
//                           SizedBox(
//                             height: 1.h,
//                           ),
//                           Container(
//                             height: 10.h,
//                             width: 40.w, // 50% of screen height
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                   color: Colors.black.withOpacity(0.8)),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: TextField(
//                               maxLines: null,
//                               expands: true,
//                               controller: _answerController,
//                               decoration: const InputDecoration(
//                                   contentPadding: EdgeInsets.all(12.0),
//                                   border: InputBorder.none,
//                                   hintText: '',
//                                   hintStyle: TextStyle(
//                                     fontWeight: FontWeight.w900,
//                                     fontSize: 15,
//                                   )),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 3.h,
//                           ),
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: HoverLoadingButton(
//                                 text: 'Publish',
//                                 isIcon: false,
//                                 oneColor: true,
//                                 loader: true,
//                                 onClicked: () async{
//                                   _publishInsight(context,dataP.parameters!.uid.toString());
//                                 },
//                                 width: 100,
//                                 height: 35,
//                                 fontWeight: FontWeight.normal),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppTextWidget(
//                                     text: 'Symptom Tracking Insights',
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w900,
//                                   ),
//                                   SizedBox(height: 2.h),
//                                   AppTextWidget(
//                                     text:
//                                     'Common Symptoms Reported: Fatigue, Headaches, Muscle Aches',
//                                     fontSize: 12,
//                                   ),
//                                   SizedBox(height: 2.h),
//                                   Row(
//                                     children: [
//                                       CustomRichText(
//                                         firstText: 'Avg Severity Ratings: ',
//                                         fontWeight: FontWeight.w400,
//                                         secondText: '3.5/5  ',
//                                         secondFontWeight: FontWeight.w900,
//                                         press: () {},
//                                       ),
//                                       CustomRichText(
//                                         firstText:
//                                         '|  Users Reporting Symptoms:',
//                                         fontWeight: FontWeight.w400,
//                                         secondFontWeight: FontWeight.w900,
//                                         secondText: '600',
//                                         press: () {},
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(width: 4.w),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   AppTextWidget(
//                                     text: 'Notifications and Alerts',
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w900,
//                                   ),
//                                   SizedBox(height: 1.h),
//                                   buildRichText('Overdue Milestones:', '10 ',
//                                       '   |   Notification:', '5'),
//                                   SizedBox(height: 0.5.h),
//                                   buildRichText('User Requests:', '20 ',
//                                       '   |   System Alerts:', '2'),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 4.h),
//                         AppTextWidget(
//                           text: 'Mood Insights',
//                           fontSize: 20,
//                           fontWeight: FontWeight.w900,
//                         ),
//                         SizedBox(height: 2.h),
//                         buildRichText(
//                             'Common Mood:', 'Content,Worried ', ' ', ''),
//                         SizedBox(height: 2.h),
//                         buildRichText('Avg Severity Ratings:', '4/5 ',
//                             '   |   Users Reporting Symptoms:', '300'),
//                         SizedBox(height: 4.h),
//                         AppTextWidget(
//                           text: 'Stress & Energy Insights',
//                           fontSize: 20,
//                           fontWeight: FontWeight.w900,
//                         ),
//                         SizedBox(height: 2.h),
//                         buildRichText('Avg Stress Level:', '2.5/5  ',
//                             '   |   Users Reporting High Stress:', '200'),
//                         SizedBox(height: 2.h),
//                         buildRichText('Avg Energy Level:', '3.5/5  ',
//                             '   |   Users Reporting Low Energy:', '250'),
//                         SizedBox(height: 4.h),
//                         AppTextWidget(
//                           text: 'Sleep Insights',
//                           fontSize: 20,
//                           fontWeight: FontWeight.w900,
//                         ),
//                         SizedBox(height: 2.h),
//                         buildRichText('Avg Sleep Duration:', '36 hours  ',
//                             '   |   Users Reporting Poor Sleep:', '200'),
//                         SizedBox(height: 2.h),
//                         buildRichText('Common Sleep Issues:',
//                             'Frequent Wakings, Insomnia', ' ', ''),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _publishInsight(context,String userId) async {
//     var drop = Provider.of<DropdownProviderN>(context);
//     ActionProvider.startLoading();
//
//     // Check if text fields are empty
//     if (_answerController.text.isEmpty) {
//       AppUtils().showToast(text: 'Please enter description');
//       ActionProvider.stopLoading();
//       return;
//     }
//     try {
//       var id = FirebaseFirestore.instance.collection('users').doc(userId).collection('insights').doc().id;
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('insights')
//           .doc(id)
//           .set({
//         'question': drop.selectedInsightCategory, // Add the question
//         'answer': _answerController.text, // Add the answer
//         'id': id, // Add the document id
//         'created_at': DateTime.now().millisecondsSinceEpoch.toString(), // Timestamp
//       });
//
//       // Stop the loading and clear input fields
//       ActionProvider.stopLoading();
//       AppUtils().showToast(text: 'Insight added successfully');
//       _questionController.clear();
//       _answerController.clear();
//     } catch (e) {
//       log("Error adding insight: $e"); // Log the error
//       ActionProvider.stopLoading();
//       AppUtils().showToast(text: 'Failed to add insight');
//     }
//   }
//
//
//   Row buildRichText(firstText, secondText, thirdText, fourthText) {
//     return Row(
//       children: [
//         CustomRichText(
//           firstText: firstText,
//           fontWeight: FontWeight.w400,
//           secondText: secondText,
//           secondFontWeight: FontWeight.w900,
//           press: () {},
//         ),
//         CustomRichText(
//           firstText: thirdText,
//           fontWeight: FontWeight.w400,
//           secondFontWeight: FontWeight.w900,
//           secondText: fourthText,
//           press: () {},
//         ),
//       ],
//     );
//   }
// }
