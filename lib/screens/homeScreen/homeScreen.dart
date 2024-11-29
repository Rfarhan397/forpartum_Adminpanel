import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
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
import '../../provider/user_provider/user_provider.dart';
import 'component/mobile_stat.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final dropdownProvider = Provider.of<DropdownProvider>(context);
    final notifications = Provider.of<NotificationProviderForNotifications>(context).notifications;
    final userProvider = Provider.of<UserProvider>(context);


    final users = userProvider.users;
    final activeUsersCount = users.where((user) => user.status == 'isActive').length;
    final totalUsersCount = users.length;

    // Get the current month and year
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

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
    ////feedbacks///////
    final feeedback = Provider.of<UserProvider>(context)..fetchFeedbacks();
    final feedbackCount = feeedback.feedbacks.length;

    ///age///
    final ageGroups = {
      '16-18': users.where((user) {
        final ageInt = int.tryParse(user.age ?? '0'); // Convert age to int, handle null safely
        return ageInt != null && ageInt >= 16 && ageInt <= 18;
      }).length,
      '20-30': users.where((user) {
        final ageInt = int.tryParse(user.age ?? '');
        return ageInt != null && ageInt >= 20 && ageInt <= 30;
      }).length,
      '30-40': users.where((user) {
        final ageInt = int.tryParse(user.age ?? '');
        return ageInt != null && ageInt >= 30 && ageInt <= 40;
      }).length,
      '40+': users.where((user) {
        final ageInt = int.tryParse(user.age ?? '');
        return ageInt != null && ageInt > 40;
      }).length,
    };


    final ageDistributionPercentages = ageGroups.map((ageRange, count) {
      final percentage = totalUsersCount > 0 ? (count / totalUsersCount) : 0;
      return MapEntry(ageRange, percentage.toDouble());
    });
    final previousTotalUsersCount = 100;
    final previousActiveUsersCount = 80;
    final previousNewSignupsCount = 10;
    final previousFeedbackCount = 5;

    // Calculate percentage changes
    final totalUsersPercentageChange = _calculatePercentageChange(totalUsersCount, previousTotalUsersCount);
    final activeUsersPercentageChange = _calculatePercentageChange(activeUsersCount, previousActiveUsersCount);
    final newSignupsPercentageChange = _calculatePercentageChange(newSignupsCount, previousNewSignupsCount);
    final feedbackPercentageChange = _calculatePercentageChange(feedbackCount, previousFeedbackCount);

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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     AppTextWidget(text: 'Users',fontWeight: FontWeight.w500,fontSize: isMobile? 10:18,),
                    // DropdownButton<String>(
                    //   value: dropdownProvider.selectedValue,
                    //   items: <String>['Last 30 Days', 'Last 10 Days', 'Yesterday'].map((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: AppTextWidget(text: value),
                    //     );
                    //   }).toList(),
                    //   onChanged: (String? newValue) {
                    //     if (newValue != null) {
                    //       dropdownProvider.setSelectedValue(newValue);
                    //     }
                    //   },
                    //   underline: const SizedBox(),
                    //   icon: const Icon(Icons.keyboard_arrow_down_outlined,size: 15, color: Colors.black),
                    // ),
                  ],
                ),
              ),
              //!Responsive.isMobile(context) ?
                Row(
                children: [
                  Tooltip(

                    message: 'Users',
                    child: StatsCard(
                      onTap: () {
                        Provider.of<MenuAppController>(context, listen: false)
                            .changeScreen(1);
                      },
                      iconPath: AppIcons.totalUsers,
                      progressIcon: totalUsersPercentageChange >= 0 ? 'assets/icons/arrowUp.svg' : 'assets/icons/arrowDown.svg',
                      iconBackgroundColor: secondaryColor,
                      title: 'Total Users',
                      count: totalUsersCount.toString(),
                      percentageIncrease: '${totalUsersPercentageChange.abs().toStringAsFixed(2)}% ${totalUsersPercentageChange >= 0 ? 'increase' : 'decrease'} from last month',
                      increaseColor: totalUsersPercentageChange >= 0 ? Colors.green : Colors.red,

                    ),
                  ),
                  StatsCard(
                    progressIcon: activeUsersPercentageChange >= 0 ? 'assets/icons/arrowUp.svg' : 'assets/icons/arrowDown.svg',
                    iconPath: AppIcons.activeUser,
                    iconBackgroundColor: primaryColor,
                    title: 'Active Users',
                    count: activeUsersCount.toString(),
                    percentageIncrease: '${activeUsersPercentageChange.abs().toStringAsFixed(2)}% ${activeUsersPercentageChange >= 0 ? 'increase' : 'decrease'} from last month',
                    increaseColor: activeUsersPercentageChange >= 0 ? Colors.green : Colors.red,

                  ),
                  StatsCard(
                    progressIcon: newSignupsPercentageChange >= 0 ? 'assets/icons/arrowUp.svg' : 'assets/icons/arrowDown.svg',
                    iconPath: AppIcons.time,
                    iconBackgroundColor: secondaryColor,
                    title: 'New Signups',
                    count: newSignupsCount.toString(),
                    percentageIncrease: '${newSignupsPercentageChange.abs().toStringAsFixed(2)}% ${newSignupsPercentageChange >= 0 ? 'increase' : 'decrease'} from last month',
                    increaseColor: newSignupsPercentageChange >= 0 ? Colors.green : Colors.red,

                  ),
                  Tooltip(
                    message: 'Feedbacks',
                    child: StatsCard(
                      onTap: () {
                        Provider.of<MenuAppController>(context, listen: false)
                            .changeScreen(0);
                        Provider.of<MenuAppController>(context, listen: false)
                            .changeScreen(32);
                      },
                      progressIcon: feedbackPercentageChange >= 0 ? 'assets/icons/arrowUp.svg' : 'assets/icons/arrowDown.svg',
                      iconPath: AppIcons.feedback,
                      iconBackgroundColor: primaryColor,
                      title: 'Feedback',
                      count: feedbackCount.toString(),
                      percentageIncrease: '${feedbackPercentageChange.abs().toStringAsFixed(2)}% ${feedbackPercentageChange >= 0 ? 'increase' : 'decrease'} from last month',
                      increaseColor: feedbackPercentageChange >= 0 ? Colors.green : Colors.red,

                    ),
                  ),

                ],
              ) ,
                  //: const MobileStat(),
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
                    //        AppTextWidget(text: 'Alerts and Notifications',
                    //         fontWeight: FontWeight.w500,fontSize: isMobile? 10:14,),
                    //       SizedBox(height: 2.h,),
                    //       Expanded(
                    //         child: ListView.builder(
                    //           physics: const NeverScrollableScrollPhysics(),
                    //           itemCount: notifications.length,
                    //           itemBuilder: (context, index) {
                    //             final notification = notifications[index];
                    //             return Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Container(
                    //                   height: 30,
                    //                   width: 28.w,
                    //                   padding: const EdgeInsets.all(4.0),
                    //                   decoration: BoxDecoration(
                    //                     color: notification.categoryColor,
                    //                     borderRadius: BorderRadius.circular(15.0),
                    //                   ),
                    //                   child: Center(
                    //                     child: AppTextWidget(
                    //                       text:
                    //                       notification.category,
                    //                       color: Colors.white, fontWeight: FontWeight.w400),
                    //                   ),
                    //                 ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(vertical: 12.0),
                    //                   child: Row(
                    //                     children: [
                    //                       AppTextWidget(text:notification.date,fontWeight: FontWeight.w400, fontSize: 10),
                    //                        SizedBox(width: 1.w),
                    //                       Expanded(child: AppTextWidget(text:notification.description,fontWeight: FontWeight.w400,textAlign: TextAlign.start, fontSize: 10)),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             );
                    //           },
                    //   ),
                    // ),
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
                            AgeDistribution(ageDistribution: ageDistributionPercentages,),
                             SizedBox(height: 2.h),
                           // GeographicalDistribution(),
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
        child: Row(
          children: [
            AppTextWidget(text: text, color: Colors.white),
            SizedBox(width: 0.5.w),
            Icon(Icons.keyboard_arrow_down,size: 15, color: Colors.white),
          ],
        )
        // DropdownButtonHideUnderline(
        //   child: DropdownButton<String>(
        //     dropdownColor: color,
        //     value: text,
        //     icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        //     iconSize: 15,
        //     style: const TextStyle(color: Colors.white, fontSize: 12),
        //     onChanged: (String? newValue) {
        //       // Handle dropdown value change
        //       if (newValue != null) {
        //         // Do something when a new value is selected
        //       }
        //     },
        //     items: <String>[text, 'Option 1', 'Option 2', 'Option 3'] // Dropdown menu items
        //         .map<DropdownMenuItem<String>>((String value) {
        //       return DropdownMenuItem<String>(
        //         value: value,
        //         child: Center(child: AppTextWidgetNunito(text: value,color: Colors.white,)),
        //       );
        //     }).toList(),
        //   ),
        // ),
      ),
    );
  }
// Helper function to calculate the percentage change
  double _calculatePercentageChange(int currentValue, int previousValue) {
    if (previousValue == 0) {
      return 100.0; // Assume 100% increase if there was no data last month
    }
    return ((currentValue - previousValue) / previousValue) * 100;
  }

  // Helper function to get age from a timestamp (assuming `age` is in timestamp format)
  int _getAge(int birthYear) {
    final currentYear = DateTime.now().year;
    return currentYear - birthYear;
  }
}