import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/components/add_button.dart';
import 'package:forpartum_adminpanel/provider/action/action_provider.dart';
import 'package:forpartum_adminpanel/provider/stream/streamProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/blog_post/blog_model.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/custom_switch_widget.dart';
import '../../model/res/components/stats_card.dart';
import '../../model/res/constant/app_icons.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/activity/acitivity_provider.dart';
import '../../provider/notification_provider/notification_provider.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProviderForNotifications>(context);
    final action = Provider.of<ActionProvider>(context);
    return Scaffold(
      appBar: const CustomAppbar(text: 'Notifications Overview'),
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
                  InkWell(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Provider.of<MenuAppController>(context, listen: false)
                            .addBackPage(6);
                        Provider.of<MenuAppController>(context, listen: false)
                            .changeScreen(20);
                      },
                      child: AddButton(text: 'Create New Notification')
                  ),
                  SizedBox(height: 4.h),
                  // Row(
                  //   children: [
                  //     StatsCard(
                  //       iconPath: AppIcons.totalUsers,
                  //       iconBackgroundColor: secondaryColor,
                  //       title: 'Total Notifications Sent',
                  //       count: notificationProvider.notifications.length.toString(),
                  //     ),
                  //     StatsCard(
                  //       iconPath: AppIcons.activeUser,
                  //       iconBackgroundColor: primaryColor,
                  //       title: 'Pending Notifications',
                  //       count: '0',
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      StreamBuilder<List<NotificationModel>>(
                        stream: Provider.of<StreamDataProvider>(context).getNotifications(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return StatsCard(
                              iconPath: AppIcons.totalUsers,
                              iconBackgroundColor: secondaryColor,
                              title: 'Total Notifications Sent',
                              count: '...',
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return StatsCard(
                              iconPath: AppIcons.totalUsers,
                              iconBackgroundColor: secondaryColor,
                              title: 'Total Notifications Sent',
                              count: '0',
                            );
                          }

                          final notifications = snapshot.data!;
                          final sentCount = notifications.length; // Assuming all fetched notifications are "sent"
                          return StatsCard(
                            iconPath: AppIcons.totalUsers,
                            iconBackgroundColor: secondaryColor,
                            title: 'Total Notifications Sent',
                            count: sentCount.toString(),
                          );
                        },
                      ),
                      StreamBuilder<List<NotificationModel>>(
                        stream: Provider.of<StreamDataProvider>(context).getNotifications(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return StatsCard(
                              iconPath: AppIcons.activeUser,
                              iconBackgroundColor: primaryColor,
                              title: 'Pending Notifications',
                              count: '...',
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return StatsCard(
                              iconPath: AppIcons.activeUser,
                              iconBackgroundColor: primaryColor,
                              title: 'Pending Notifications',
                              count: '0',
                            );
                          }

                          final notifications = snapshot.data!;
                          final pendingCount = notifications.where((notification) => notification.status == 'pending').length;
                          return StatsCard(
                            iconPath: AppIcons.activeUser,
                            iconBackgroundColor: primaryColor,
                            title: 'Pending Notifications',
                            count: pendingCount.toString(),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Container(
                        height: 80.h,
                        width: 45.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppTextWidget(
                              text: 'Recent Notifications',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildHeaderButton(context,secondaryColor,2, 'Date', secondaryColor,2.0),
                                SizedBox(width: 2.w),
                                _buildHeaderButton(context,secondaryColor,2, 'Title', secondaryColor,2.0),
                                SizedBox(width: 2.w),
                                _buildHeaderButton(context,primaryColor,1, 'Status', secondaryColor,0.0),
                                SizedBox(width: 2.w),
                                _buildHeaderButton(context, secondaryColor,2,'Action', secondaryColor,0.0),
                                SizedBox(width: 2.w),
                              ],
                            ),
                            SizedBox(height: 0.8.h),
                            Consumer<StreamDataProvider>(
                              builder: (context, value, child) {
                                return StreamBuilder<List<NotificationModel>>(
                                    stream: value.getNotifications(),
                                    builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  }

                                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return Center(child: Text("No notifications available."));
                                  }

                                  final notifications = snapshot.data!;
                                  return Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: notifications.length,
                                      itemBuilder: (context, index) {
                                        final notification = notifications[index];
                                        String readableDate = notificationProvider.formatTimestamp(notification.timestamp.toString());
                                        log("notification title is :: ${notification.title}");

                                        return Padding(
                                          padding: EdgeInsets.symmetric(vertical: 0.8.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(flex: 1,child: AppTextWidget(text:readableDate, fontSize: 12)),
                                              SizedBox(width: 3.5.w),
                                              Expanded(flex: 2,child: Padding(
                                                padding: EdgeInsets.only(left: 1.w),
                                                child: AppTextWidget(text:notification.title,textAlign: TextAlign.start, fontSize: 12),
                                              )),
                                              SizedBox(width: 3.5.w),
                                              Expanded(flex: 1,child: Padding(
                                                padding: EdgeInsets.only(left: 1.w),
                                                child: AppTextWidget(text:notification.status,fontWeight: FontWeight.bold,textAlign: TextAlign.start, fontSize: 12),
                                              )),
                                              SizedBox(width: 1.5.w),
                                              Expanded(flex: 2,child: Row(
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        var show = Provider.of<ActionProvider>(context,listen: false);
                                                        show.showConfirmDialog(
                                                            context,
                                                            notification.title,
                                                            notification.message
                                                        );
                                                      },
                                                      child: AppTextWidget(text:'[View]',textAlign: TextAlign.start, fontWeight: FontWeight.bold,fontSize: 12)
                                                  ),
                                                  SizedBox(width: 2.w),
                                                  InkWell(
                                                      onTap: () async {
                                                        bool confirmDelete = await action.showDeleteConfirmationDialog(
                                                            context,'Delete!','Are you sure you want to delete?'
                                                        );
                                                        if (confirmDelete) {
                                                          action.deleteItem('notifications',notification.id.toString());
                                                        }
                                                      },
                                                      child: AppTextWidget(text:'[Delete]',textAlign: TextAlign.start, fontWeight: FontWeight.bold,fontSize: 12)
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                );
                              },
                            ),
                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),
                      SizedBox(width: 4.w),
                      // Container(
                      //   height: 80.h,
                      //   width: 19.w,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       const AppTextWidget(
                      //         text: 'Notifications Settings',
                      //         fontSize: 20,
                      //         textAlign: TextAlign.start,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //       Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             const AppTextWidget(text: 'Notification Types:',fontWeight: FontWeight.w700,),
                      //             Icon(Icons.more_vert,size: 20,color: Colors.grey[500],)
                      //           ],
                      //         ),
                      //       ),
                      //       buildToggleContainer('Email'),
                      //       SizedBox(height: 2.h),
                      //       buildToggleContainer('Sms'),
                      //       SizedBox(height: 2.h),
                      //       buildToggleContainer('Push Notifications'),
                      //       SizedBox(height: 4.h),
                      //       Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             const AppTextWidget(text: 'Frequency Settings:',fontWeight: FontWeight.w700,),
                      //             Icon(Icons.more_vert,size: 20,color: Colors.grey[500],)
                      //           ],
                      //         ),
                      //       ),
                      //       buildToggleContainer('Daily Digest'),
                      //       SizedBox(height: 2.h),
                      //       buildToggleContainer('Weekly Summary '),
                      //       SizedBox(height: 2.h),
                      //     ],
                      //   ),
                      // )
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

  Future<bool> showDeleteConfirmationDialog(BuildContext context, String title, content) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
                AppUtils().showToast(text: 'Deleted successfully');
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  Widget _buildHeaderButton(BuildContext context, Color backgroundColor, int flex, String text, Color color, double horizontalPadding) {
    return Expanded(
      flex: flex,
      child: ButtonWidget(
        borderColor: Colors.transparent,
        horizontalPadding: horizontalPadding,
        text: text,
        backgroundColor: backgroundColor,
        oneColor: true,
        onClicked: () {},
        height: 30,
        width: 100,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Container buildToggleContainer(text) {
    return Container(
      width: 18.w,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Adjust opacity for softer shadow
              offset: const Offset(0, 5), // Shadow position
              blurRadius: 10, // Adjust the blur radius
            ),
          ]),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
           CustomSwitchWidget(),
        ],
      ),
    );
  }
}




