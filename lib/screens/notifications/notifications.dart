
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/custom_switch_widget.dart';
import '../../model/res/components/stats_card.dart';
import '../../model/res/constant/app_icons.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/activity/acitivity_provider.dart';
import '../../provider/notification_provider/notification_provider.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = Provider.of<NotificationProviderForNotifications>(context).notifications;

    return Scaffold(
      appBar: CustomAppbar(text: 'Notifications Overview'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              height: 1,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<MenuAppController>(context, listen: false)
                              .changeScreen(20);
                          //Get.toNamed(RoutesName.addNewNotifications);
                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: primaryColor,
                          ),
                          child: Center(
                            child: Icon(Icons.add,size:20,color: Colors.white,),
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      AppTextWidget(text: 'Create New Notifcation',fontSize: 14,color: Colors.black,)
                    ],
                  ),
                  SizedBox( height: 4.h,),
                   Row(
                    children: [
                      StatsCard(
                        iconPath: AppIcons.totalUsers,
                        iconBackgroundColor: secondaryColor,
                        title: 'Total Notifications Sent',
                        count: '1,200',
        
                      ),
                      StatsCard(
                        iconPath: AppIcons.activeUser,
                        iconBackgroundColor: primaryColor,
                        title: 'Pending Notifications',
                        count: '50',
        
                      ),
                      StatsCard(
                        iconPath: AppIcons.time,
                        iconBackgroundColor: secondaryColor,
                        title: 'Open Rate',
                        count: '75%',
        
                      ),
                      StatsCard(
                        iconPath: AppIcons.feedback,
                        iconBackgroundColor: primaryColor,
                        title: 'Click-Through Rate:',
                        count: '60%',
                      ),
        
                    ],
                  ),
                  SizedBox( height: 2.h,),
                  Row(
                    children: [
                      Container(
                        height: 80.h,
                        width: 45.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppTextWidget(text: 'Recent Notifications', fontWeight: FontWeight.w500, fontSize: 20,),
                            SizedBox(height: 2.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              _buildHeaderButtonWithDropDown(context, 'Date', primaryColor),
                              SizedBox(width: 2.w,),
                              _buildHeaderButton(context,secondaryColor,2, 'Notification Title', secondaryColor,2.0),
                                SizedBox(width: 2.w,),
                              _buildHeaderButton(context,primaryColor,1, 'Status', secondaryColor,0.0),
                                SizedBox(width: 2.w,),
                              _buildHeaderButton(context, secondaryColor,1,'Action', secondaryColor,0.0),
                                SizedBox(width: 2.w,),
                            ],),
                            SizedBox(height: 0.8.h),
                            Expanded(
                              child: Consumer<ActivityProvider>(
                                builder: (context, provider, child) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: provider.activitiesForNotifications.length,
                                    itemBuilder: (context, index) {
                                      final activity = provider.activitiesForNotifications[index];
                                      return Padding(
                                        padding:  EdgeInsets.symmetric(vertical: 0.8.w),
                                        child: 
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(flex: 1,child: AppTextWidget(text:activity.date, fontSize: 12)),
                                                SizedBox(width: 3.5.w),
                                                Expanded(flex: 2,child: AppTextWidget(text:activity.description,textAlign: TextAlign.start, fontSize: 12)),
                                                SizedBox(width: 3.5.w),
                                                Expanded(flex: 1,child: AppTextWidget(text:activity.status,fontWeight: FontWeight.bold,textAlign: TextAlign.start, fontSize: 12)),
                                              SizedBox(width: 3.5.w),
                                                Expanded(flex: 1,child: AppTextWidget(text:activity.action,textAlign: TextAlign.start, fontWeight: FontWeight.bold,fontSize: 12)),
                                              ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const AppTextWidget(text: 'Alerts and Warnings',
                                fontSize: 20, fontWeight: FontWeight.w500),
                            SizedBox(height: 2.h,),
                            Expanded(
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: notifications.length,
                                itemBuilder: (context, index) {
                                  final notification = notifications[index];
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 3.5.h,
                                        width: 28.w,
                                        padding: const EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                          color: notification.categoryColor,
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: AppTextWidget(
                                              text:
                                              notification.category,
                                              textAlign: TextAlign.start,
                                              color: Colors.white, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          children: [
                                            AppTextWidget(text:notification.date, fontSize: 12),
                                            SizedBox(width: 1.w),
                                            Expanded(child: AppTextWidget(text:notification.description,textAlign: TextAlign.start, fontSize: 12)),
                                          ],
                                        ),
                                      ),Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          children: [
                                            AppTextWidget(text:notification.date, fontSize: 12),
                                            SizedBox(width: 1.w),
                                            Expanded(child: AppTextWidget(text:notification.description,textAlign: TextAlign.start, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 2.h,),
                          ],),
                      ),
                      SizedBox(width: 4.w,),
                      Container(
                        height: 80.h,
                        width: 19.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextWidget(
                              text: 'Notifications Settings',
                              fontSize: 20,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w500,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                AppTextWidget(text: 'Notification Types:',fontWeight: FontWeight.w700,),
                                Icon(Icons.more_vert,size: 20,color: Colors.grey[500],)

                              ],),
                            ),
                            buildToggleContainer('Email'),
                            SizedBox(height: 2.h,),

                            buildToggleContainer('Sms'),
                            SizedBox(height: 2.h,),

                            buildToggleContainer('Push Notifications'),
                            SizedBox(height: 4.h,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AppTextWidget(text: 'Frequency Settings:',fontWeight: FontWeight.w700,),
                                  Icon(Icons.more_vert,size: 20,color: Colors.grey[500],)

                                ],),
                            ),
                            buildToggleContainer('Daily Digest'),
                            SizedBox(height: 2.h,),

                            buildToggleContainer('Weekly Summary '),
                            SizedBox(height: 2.h,),
                          ],
                        ),)


                    ],
                  )
        
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHeaderButton(BuildContext context,Color backgroundColor,int flex, String text, Color color,double horizontalPadding) {
    return Expanded(
      flex: flex,
      child: ButtonWidget(
        borderColor: Colors.transparent,
        horizontalPadding: horizontalPadding ,
        text: text,
        backgroundColor: backgroundColor,
        oneColor: true,
        onClicked:  () {},
        height: 30,
        width: 100,
        fontWeight: FontWeight.normal,
      ),
    );
  }


  Widget _buildHeaderButtonWithDropDown(BuildContext context, String text, Color color) {
    return Container(
      width: 7.w,
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(15)
      ),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: color,
            value: text,
            icon: const Icon(Icons.keyboard_arrow_down,size: 15, color: Colors.white),
            iconSize: 24,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            onChanged: (String? newValue) {
              // Handle dropdown value change
              if (newValue != null) {
                // Do something when a new value is selected
              }
            },
            items: <String>[text, 'Option 1', 'Option 2', 'Option 3'] // Dropdown menu items
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(child: AppTextWidgetNunito(text: value,color: Colors.white,)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  Container buildToggleContainer(text) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal:10.w),
      width: 18.w,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Adjust opacity for softer shadow
              offset: Offset(0, 5), // Shadow is offset to the bottom
              blurRadius: 8,
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTextWidget(
            text: text,
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          CustomSwitchWidgetF(),
        ],
      ),
    );
  }

}
