import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/stats_card.dart';
import '../../model/res/constant/app_icons.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/app_text_field.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../model/res/widgets/custom_richtext.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/user_provider/user_provider.dart';

class InsightScreen extends StatelessWidget {
  InsightScreen({super.key});

  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    final users = userProvider.users;
    final activeUsersCount = users.where((user) => user.status == 'isActive').length;
    final totalUsersCount = users.length;
    // Get the current month and year
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;
    final dataP = Provider.of<MenuAppController>(context);
    // Filter users who created their accounts in the current month
    final newSignupsCount = users.where((user) {
      final createdAtTimestampString = user.createdAt; // Assuming createdAt is a String?
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
        child: Column(
          children: [
            Divider(
              height: 1,
              color: Colors.grey[300],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80.w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        StatsCard(
                          iconPath: AppIcons.totalUsers,
                          iconBackgroundColor: secondaryColor,
                          title: 'Total Users',
                          count: totalUsersCount.toString(),
                          width: 14.w,
                        ),
                        StatsCard(
                          iconPath: AppIcons.activeUser,
                          iconBackgroundColor: primaryColor,
                          title: 'Active Users',
                          count: activeUsersCount.toString(),
                          width: 14.w,
                        ),
                        // StatsCard(
                        //   iconPath: AppIcons.time,
                        //   iconBackgroundColor: secondaryColor,
                        //   title: 'Avg Engagement',
                        //   count: '75%',
                        //   width: 14.w,
                        // ),
                        StatsCard(
                          iconPath: AppIcons.feedback,
                          iconBackgroundColor: primaryColor,
                          title: 'New Sign Ups:',
                          count: newSignupsCount.toString(),
                          width: 14.w,
                        ),
                        // StatsCard(
                        //   iconPath: AppIcons.feedback,
                        //   iconBackgroundColor: primaryColor,
                        //   title: 'Returning Users',
                        //   count: '750',
                        //   width: 14.w,
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    child: SizedBox(
                      width: 50.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextWidget(
                            text: 'Insights:',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          AppTextWidget(text: 'Question:'),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            height: 8.h,
                            width: 25.w,
                            child: AppTextFieldBlue(
                              controller: _questionController,
                              hintText: 'How do I use?',
                              radius: 5,
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          AppTextWidget(text: 'Description:'),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            height: 10.h,
                            width: 40.w, // 50% of screen height
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.8)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              maxLines: null,
                              expands: true,
                              controller: _answerController,
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
                          SizedBox(
                            height: 3.h,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ButtonWidget(
                                text: 'Publish',
                                onClicked: () {
                                  _publishInsight(dataP.parameters!.uid.toString());
                                },
                                width: 100,
                                height: 35,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTextWidget(
                                    text: 'Symptom Tracking Insights',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  SizedBox(height: 2.h),
                                  AppTextWidget(
                                    text:
                                        'Common Symptoms Reported: Fatigue, Headaches, Muscle Aches',
                                    fontSize: 12,
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    children: [
                                      CustomRichText(
                                        firstText: 'Avg Severity Ratings: ',
                                        fontWeight: FontWeight.w400,
                                        secondText: '3.5/5  ',
                                        secondFontWeight: FontWeight.w900,
                                        press: () {},
                                      ),
                                      CustomRichText(
                                        firstText:
                                            '|  Users Reporting Symptoms:',
                                        fontWeight: FontWeight.w400,
                                        secondFontWeight: FontWeight.w900,
                                        secondText: '600',
                                        press: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AppTextWidget(
                                    text: 'Notifications and Alerts',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  SizedBox(height: 1.h),
                                  buildRichText('Overdue Milestones:', '10 ',
                                      '   |   Notification:', '5'),
                                  SizedBox(height: 0.5.h),
                                  buildRichText('User Requests:', '20 ',
                                      '   |   System Alerts:', '2'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        AppTextWidget(
                          text: 'Mood Insights',
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                        SizedBox(height: 2.h),
                        buildRichText(
                            'Common Mood:', 'Content,Worried ', ' ', ''),
                        SizedBox(height: 2.h),
                        buildRichText('Avg Severity Ratings:', '4/5 ',
                            '   |   Users Reporting Symptoms:', '300'),
                        SizedBox(height: 4.h),
                        AppTextWidget(
                          text: 'Stress & Energy Insights',
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                        SizedBox(height: 2.h),
                        buildRichText('Avg Stress Level:', '2.5/5  ',
                            '   |   Users Reporting High Stress:', '200'),
                        SizedBox(height: 2.h),
                        buildRichText('Avg Energy Level:', '3.5/5  ',
                            '   |   Users Reporting Low Energy:', '250'),
                        SizedBox(height: 4.h),
                        AppTextWidget(
                          text: 'Sleep Insights',
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                        SizedBox(height: 2.h),
                        buildRichText('Avg Sleep Duration:', '36 hours  ',
                            '   |   Users Reporting Poor Sleep:', '200'),
                        SizedBox(height: 2.h),
                        buildRichText('Common Sleep Issues:',
                            'Frequent Wakings, Insomnia', ' ', ''),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _publishInsight(String userId) async {
    ActionProvider.startLoading();

    // Check if text fields are empty
    if (_questionController.text.isEmpty || _answerController.text.isEmpty) {
      AppUtils().showToast(text: 'Please enter both question and answer');
      ActionProvider.stopLoading();
      return; // Stop execution if text fields are empty
    }

    try {
      // Generate the document ID for the insight
      var id = FirebaseFirestore.instance.collection('users').doc(userId).collection('insights').doc().id;

      // Add the insight to the user's 'insights' subcollection
      await FirebaseFirestore.instance
          .collection('users') // Users collection
          .doc(userId) // Specific user document by userId
          .collection('insights') // Subcollection for insights
          .doc(id) // Document with the generated id
          .set({
        'question': _questionController.text, // Add the question
        'answer': _answerController.text, // Add the answer
        'id': id, // Add the document id
        'created_at': DateTime.now().millisecondsSinceEpoch.toString(), // Timestamp
      });

      // Stop the loading and clear input fields
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Insight added successfully');
      _questionController.clear();
      _answerController.clear();
    } catch (e) {
      log("Error adding insight: $e"); // Log the error
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Failed to add insight');
    }
  }


  Row buildRichText(firstText, secondText, thirdText, fourthText) {
    return Row(
      children: [
        CustomRichText(
          firstText: firstText,
          fontWeight: FontWeight.w400,
          secondText: secondText,
          secondFontWeight: FontWeight.w900,
          press: () {},
        ),
        CustomRichText(
          firstText: thirdText,
          fontWeight: FontWeight.w400,
          secondFontWeight: FontWeight.w900,
          secondText: fourthText,
          press: () {},
        ),
      ],
    );
  }
}
