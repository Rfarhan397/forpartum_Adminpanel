import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../constant.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/responsive.dart';
import '../../model/res/components/stats_card.dart';
import '../../model/res/constant/app_colors.dart';
import '../../model/res/constant/app_icons.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../provider/activity/acitivity_provider.dart';
import '../../provider/constant/age_distribution/age_distribution.dart';
import '../../provider/constant/graphic_pie/pie_chart.dart';
import '../../provider/dropDOwn/dropdown.dart';
import '../../provider/notification_provider/notification_provider.dart';
import 'component/mobile_stat.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final dropdownProvider = Provider.of<DropdownProvider>(context);
    final notifications = Provider.of<NotificationProvider>(context).notifications;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: const CustomAppbar(text: 'Overview',),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h,),
               Divider(color: Colors.grey.shade400,height: 1,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   AppTextWidget(text: 'Users',fontWeight: FontWeight.w500,fontSize: isMobile? 10:18,),
                  DropdownButton<String>(
                    value: dropdownProvider.selectedValue,
                    items: <String>['Last 30 Days', 'Last 10 Days', 'Yesterday'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: AppTextWidget(text: value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        dropdownProvider.setSelectedValue(newValue);
                      }
                    },
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down_outlined,size: 15, color: Colors.black),
                  ),
                ],
              ),
              !Responsive.isMobile(context) ?
                Row(
                children: [
                  StatsCard(
                    iconPath: AppIcons.totalUsers,
                    progressIcon: 'assets/icons/arrowUp.svg',
                    iconBackgroundColor: secondaryColor,
                    title: 'Total Users',
                    count: '10,000',
                    percentageIncrease: '12% increase from last month',
                    increaseColor: Colors.green,
                  ),
                  StatsCard(
                    progressIcon: 'assets/icons/arrowdown.svg',
                    iconPath: AppIcons.activeUser,
                    iconBackgroundColor: primaryColor,
                    title: 'Active Users',
                    count: '95,000',
                    percentageIncrease: '10% decrease from last month',
                    increaseColor: Colors.red,
                  ),
                  StatsCard(
                    progressIcon: 'assets/icons/arrowUp.svg',
                    iconPath: AppIcons.time,
                    iconBackgroundColor: secondaryColor,
                    title: 'New Signups',
                    count: '2,000',
                    percentageIncrease: '8% increase from last month',
                    increaseColor: Colors.green,
                  ),
                  StatsCard(
                    progressIcon: 'assets/icons/arrowUp.svg',
                    iconPath: AppIcons.feedback,
                    iconBackgroundColor: primaryColor,
                    title: 'Feedback',
                    count: '600',
                    percentageIncrease: '2% increase from last month',
                    increaseColor: Colors.green,
                  ),

                ],
              ) : const MobileStat(),
               SizedBox(height: 3.h,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 80.h,
                      width: 35.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           AppTextWidget(text: 'Recent Activity', fontWeight: FontWeight.w500,fontSize: isMobile? 10:14,),
                           SizedBox(height: 3.h,),
                          Row(
                            children: [
                              _buildHeaderButtonWithDropDown(context, 'Date', primaryColor),
                               SizedBox(width: 3.w),
                              _buildHeaderButton(context, 'Activity', secondaryColor),
                            ],
                          ),
                           SizedBox(height: 0.8.h),
                          Expanded(
                            child: Consumer<ActivityProvider>(
                              builder: (context, provider, child) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: provider.activities.length,
                                  itemBuilder: (context, index) {
                                    final activity = provider.activities[index];
                                    return Padding(
                                      padding:  EdgeInsets.symmetric(vertical: 0.8.w),
                                      child: Row(
                                        children: [
                                          AppTextWidgetNunito(text:activity.date, fontSize: 12),
                                           SizedBox(width: 3.5.w),
                                          Expanded(child: AppTextWidget(text:activity.description,textAlign: TextAlign.start, fontSize: 12)),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                           AppTextWidget(text: 'Alerts and Notifications',
                            fontWeight: FontWeight.w500,fontSize: isMobile? 10:14,),
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
                                      height: 30,
                                      width: 28.w,
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color: notification.categoryColor,
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Center(
                                        child: AppTextWidget(
                                          text:
                                          notification.category,
                                          color: Colors.white, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      child: Row(
                                        children: [
                                          AppTextWidget(text:notification.date,fontWeight: FontWeight.w400, fontSize: 10),
                                           SizedBox(width: 1.w),
                                          Expanded(child: AppTextWidget(text:notification.description,fontWeight: FontWeight.w400,textAlign: TextAlign.start, fontSize: 10)),
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
                    Container(
                      height: 80.h,
                      width: 35.w,
                      child: Padding(
                        padding:  EdgeInsets.only(right: 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AgeDistribution(),
                             SizedBox(height: 2.h),
                            GeographicalDistribution(),
                          ],
                        ),
                      ),
                    )
                            ],
                          ),
              ),
          ]
                ),
        ),
    ));
  }
  Widget _buildHeaderButton(BuildContext context, String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: AppTextWidget(text: text,fontSize: 12,color: Colors.white),
    );
  }


  Widget _buildHeaderButtonWithDropDown(BuildContext context, String text, Color color) {
    return Container(
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
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            iconSize: 15,
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

}