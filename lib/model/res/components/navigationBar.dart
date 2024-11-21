import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/controller/menu_App_Controller.dart';
import 'package:forpartum_adminpanel/model/res/routes/routes_name.dart';
import 'package:forpartum_adminpanel/provider/action/action_provider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../constant.dart';
import '../constant/app_assets.dart';
import '../constant/app_colors.dart';
import '../constant/app_icons.dart';
import '../widgets/app_text.dart.dart';
import 'drawer_list_tile.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: secondaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.zero, // Remove top-right corner rounding
          bottomRight: Radius.circular(0), // Ensure bottom-right is also not rounded
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 1.w),
                        Image.asset(
                          AppAssets.logoImage,
                          height: 60,
                        ),
                        SizedBox(width: 0.4.w),
                         const AppTextWidget(
                          text: 'Forpartum',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h,),
                    // Padding(
                    //   padding:  EdgeInsets.only(left: 3.w),
                    //   child: Container(
                    //     width: 12.w,
                    //     padding: EdgeInsets.symmetric(
                    //         horizontal: 1.w, vertical: 4.0),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(30),
                    //       color: Colors.white,
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         Container(
                    //           height: 25,
                    //           width: 25,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(20),
                    //             color: primaryColor,
                    //           ),
                    //           child: const Icon(
                    //             Icons.add,
                    //             size: 18,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         SizedBox(width: 1.w),
                    //          const AppTextWidget(
                    //           text: 'Create new\nproject',
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w400,
                    //           textAlign: TextAlign.start,
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const DrawerListTile(
                  index: 0,
                  screenIndex: 0,
                  title: "Dashboard",
                  svgSrc: 'assets/icons/dashboard.svg',
                ),
                const DrawerListTile(
                  index: 1,
                  screenIndex: 1,
                  title: "Users",
                  svgSrc: "assets/icons/users.svg",
                ),
                const DrawerListTile(
                  index: 2,
                  screenIndex: 2,
                  title: "Chat Support",
                  svgSrc: "assets/icons/chat.svg",
                ),
                // const DrawerListTile(
                //   index: 3,
                //   screenIndex: 3,
                //   title: "Insights",
                //   svgSrc: "assets/icons/insights.svg",
                // ),
                const DrawerListTile(
                  index: 4,
                  screenIndex: 4,
                  title: "Blog",
                  svgSrc: "assets/icons/insights.svg",
                ),
                const DrawerListTile(
                  index: 5,
                  screenIndex: 5,
                  title: "Meal Plans",
                  svgSrc: "assets/icons/meal_plan.svg",
                ),
                const DrawerListTile(
                  index: 6,
                  screenIndex: 6,
                  title: "Notifications",
                  svgSrc: "assets/icons/notifications.svg",
                ),
                const DrawerListTile(
                  index: 7,
                  screenIndex: 7,
                  title: "Library",
                  svgSrc: "assets/icons/library.svg",
                ),
                const DrawerListTile(
                  index: 8,
                  screenIndex: 8,
                  title: "Menu settings",
                  svgSrc: "assets/icons/setting.svg",
                ),
                const DrawerListTile(
                  index: 28,
                  screenIndex: 28,
                  title: "Trackers",
                  svgSrc: AppIcons.tracker,
                ),
                const DrawerListTile(
                  index: 25,
                  screenIndex: 25,
                  title: "Guidelines",
                  svgSrc: AppIcons.gudlines,
                ),
                const DrawerListTile(
                  index: 26,
                  screenIndex: 26,
                  title: "Learning Center",
                  svgSrc: AppIcons.learning_center,
                ),
                const SizedBox(
                  height: defaultDrawerHeadHeight,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 28),
              child:   InkWell(
                onTap: () {
                  _showDeleteDialog(context);
                },
                child: Tooltip(
                  message: 'Log Out',
                  child: Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all( 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor,
                    ),
                    child: Image.asset(AppAssets.questionMark,
                  
                    ),
                  ),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
  void _showDeleteDialog(BuildContext context,) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leaving!'),
          content: Text('Are you sure you want to Log Out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Future.delayed(Duration(milliseconds: 1000));
                Get.offAllNamed(RoutesName.splashScreen);

              },
              child: const Text('Yes', style: TextStyle(color: primaryColor)),
            ),
          ],
        );
      },
    );
  }

}
