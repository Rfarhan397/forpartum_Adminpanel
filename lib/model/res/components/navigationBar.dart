import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../constant.dart';
import '../constant/app_assets.dart';
import '../constant/app_colors.dart';
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
                         AppTextWidget(
                          text: 'Forpartum',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h,),
                    Padding(
                      padding:  EdgeInsets.only(left: 3.w),
                      child: Container(
                        width: 12.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.w, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: primaryColor,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 1.w),
                             AppTextWidget(
                              text: 'Create new\nproject',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                      ),
                    ),
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
                const DrawerListTile(
                  index: 3,
                  screenIndex: 3,
                  title: "Insights",
                  svgSrc: "assets/icons/insights.svg",
                ), const DrawerListTile(
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
                  index: 25,
                  screenIndex: 25,
                  title: "Guidelines",
                  svgSrc: "assets/icons/setting.svg",
                ),
                const DrawerListTile(
                  index: 26,
                  screenIndex: 26,
                  title: "Learning Center",
                  svgSrc: "assets/icons/setting.svg",
                ),
                SizedBox(
                  height: defaultDrawerHeadHeight,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25,vertical: 28),
              child:   Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.all( 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: primaryColor,
                ),
                child: Image.asset(AppAssets.questionMark,

                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}
