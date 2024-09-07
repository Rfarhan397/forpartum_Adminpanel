import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/stats_card.dart';
import '../../model/res/constant/app_icons.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/custom_richtext.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: 'Insights Overview'),
      body: Column(
        children: [
          Divider(
            height: 1,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 15.0),
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
                        count: '1,200',
                        width: 14.w,
                      ),
                      StatsCard(
                        iconPath: AppIcons.activeUser,
                        iconBackgroundColor: primaryColor,
                        title: 'Active Users: 850',
                        count: '850',
                        width: 14.w,
                      ),
                      StatsCard(
                        iconPath: AppIcons.time,
                        iconBackgroundColor: secondaryColor,
                        title: 'Avg Engagement',
                        count: '75%',
                        width: 14.w,
                      ),
                      StatsCard(
                        iconPath: AppIcons.feedback,
                        iconBackgroundColor: primaryColor,
                        title: 'New Sign Ups:',
                        count: '60%',
                        width: 14.w,
                      ),
                      StatsCard(
                        iconPath: AppIcons.feedback,
                        iconBackgroundColor: primaryColor,
                        title: 'Returning Users',
                        count: '750',
                        width: 14.w,
                      ),

                    ],
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
                            AppTextWidget(text:
                              'Symptom Tracking Insights',
                                fontSize: 20,
                                fontWeight: FontWeight.w900,

                            ),
                            SizedBox(height: 2.h),
                            AppTextWidget(text:
                            'Common Symptoms Reported: Fatigue, Headaches, Muscle Aches',
                                fontSize: 12,
                            ),
                            SizedBox(height: 2.h),
                         Row(
                           children: [
                             CustomRichText(
                               firstText:
                               'Avg Severity Ratings: ',
                               fontWeight: FontWeight.w400,
                               secondText: '3.5/5  ',
                               secondFontWeight: FontWeight.w900,
                               press: () {  },


                             ),
                             CustomRichText(
                               firstText:
                               '|  Users Reporting Symptoms:' ,
                               fontWeight: FontWeight.w400,
                               secondFontWeight: FontWeight.w900,
                               secondText: '600', press: () {  },


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
                            AppTextWidget(text:
                            'Notifications and Alerts',
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              ),
                            SizedBox(height: 1.h),
                            buildRichText('Overdue Milestones:','10 ','   |   Notification:','5'),
                            SizedBox(height: 0.5.h),
                            buildRichText('User Requests:','20 ','   |   System Alerts:','2'),

                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  AppTextWidget(text:

                  'Mood Insights',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                  SizedBox(height: 2.h),
                  buildRichText('Common Mood:','Content,Worried ',' ',''),

                  SizedBox(height: 2.h),
                  buildRichText('Avg Severity Ratings:','4/5 ','   |   Users Reporting Symptoms:','300'),
                  SizedBox(height: 4.h),
                  AppTextWidget(text:

                  'Stress & Energy Insights',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                  SizedBox(height: 2.h),
                  buildRichText('Avg Stress Level:','2.5/5  ','   |   Users Reporting High Stress:','200'),
                  SizedBox(height: 2.h),
                  buildRichText('Avg Energy Level:','3.5/5  ','   |   Users Reporting Low Energy:','250'),

                  SizedBox(height: 4.h),
                  AppTextWidget(text:

                  'Sleep Insights',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,

                  ),
                  SizedBox(height: 2.h),
                  buildRichText('Avg Sleep Duration:','36 hours  ','   |   Users Reporting Poor Sleep:','200'),

                  SizedBox(height: 2.h),
                  buildRichText('Common Sleep Issues:','Frequent Wakings, Insomnia',' ',''),

                                ],
                              ),
                ),
              ],
            ),
          )
        ],
      ),
      
    );
  }

  Row buildRichText(firstText,secondText, thirdText, fourthText) {
    return Row(
                          children: [
                            CustomRichText(
                              firstText:
                              firstText,
                              fontWeight: FontWeight.w400,
                              secondText: secondText,
                              secondFontWeight: FontWeight.w900,
                              press: () {  },


                            ),
                            CustomRichText(
                              firstText:
                              thirdText ,
                              fontWeight: FontWeight.w400,
                              secondFontWeight: FontWeight.w900,
                              secondText: fourthText, press: () {  },


                            ),
                          ],
                        );
  }
}
