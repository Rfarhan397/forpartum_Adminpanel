import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forpartum_adminpanel/model/res/components/responsive.dart';
import 'package:sizer/sizer.dart';

import '../widgets/app_text.dart.dart';

class StatsCard extends StatelessWidget {
  final String iconPath;
  final double? width;
  final String? progressIcon;
  final Color iconBackgroundColor;
  final String title;
  final String count;
  final String? percentageIncrease;
  final Color? increaseColor;

   StatsCard({
    Key? key,
    required this.iconPath,
    required this.iconBackgroundColor,
    required this.title,
    required this.count,
     this.percentageIncrease,
     this.increaseColor,
     this.progressIcon,
     this.width ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:  Container(
        width: width ?? 18.5.w ,
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
        decoration: BoxDecoration(
          color: Color(0xffFBF0F3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            CircleAvatar(
              backgroundColor: iconBackgroundColor,
              child: Image.asset(iconPath, color: Colors.white, fit: BoxFit.cover,height: 20,),
            ),
            SizedBox(height: 2.h),
            AppTextWidget(
              text:
              title,
                fontSize:  isMobile ? 8:isTablet ? 10:12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 1.h),
            AppTextWidget(text:
              count,
                fontSize: isMobile ? 14:isTablet ? 18:22,
                color: Colors.black,
                fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                SvgPicture.asset(progressIcon ?? 'IconError', color: increaseColor, height: 16),
                SizedBox(width: 0.2.w),
                AppTextWidget(text:
                percentageIncrease??'',
                    fontSize: isMobile ? 5:isTablet ? 6:10,
                    softWrap: true,

                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                ),
              ],
            ),
            SizedBox(height: 1.h),

          ],
        ),
      ),
    );
  }
}
class MealCard extends StatelessWidget {
  final String iconPath;
  final Color iconBackgroundColor;
  final String title;
  final String count;
  final Color increaseColor;

  const MealCard({
    Key? key,
    required this.iconPath,
    required this.iconBackgroundColor,
    required this.title,
    required this.count,
    required this.increaseColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 16.w,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xffFBF0F3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: iconBackgroundColor,
              child: Image.asset(iconPath, color: Colors.white, fit: BoxFit.cover,height: 20,),
            ),
            SizedBox(height: 1.h),
            AppTextWidget(text:
            title,
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 1.h),
            AppTextWidget(text:
            count,
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}