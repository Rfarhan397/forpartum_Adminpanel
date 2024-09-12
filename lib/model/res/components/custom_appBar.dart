import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/components/responsive.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../constant/app_colors.dart';
import '../widgets/app_text.dart.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const CustomAppbar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return AppBar(
      elevation: 0,
      surfaceTintColor: AppColors.scaffoldColor,
      backgroundColor: AppColors.scaffoldColor,
      title: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 0.5.w,),
            AppTextWidget(text: text, fontWeight: FontWeight.w400, fontSize: isMobile? 15: 28),
            Spacer(
              flex: 3,
            ),
            if(!isMobile)
              Container(
              width: 250,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for anything...',
                          fillColor: Colors.white,
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.grey.shade400
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    //backgroundImage:
                    //AssetImage(AppAssets.alex)
                   // NetworkImage('https://s3-alpha-sig.figma.com/img/44ce/677a/3a8bdf19c7b4f7e27422dcf2c356ae9e?Expires=1725235200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=iARFpGK6cNiNDUu-EZdZReyIq5Flp3f-mPQgz1RZ7NIDx~5K-JrVqw3BYDNBnRw6If7L~wT6sJzN4eOjMUnlrdf5fmMK59mlbbrA5ZkcXHIxtEynNj495pTegN7NDHt99Kw5jaT-o2PSuduVB3WO6qG5Ba~OWrjKXPD6cx-2zkwTk1Pkt4dMnZkl8WJzIiUsN6RgB-3gU7~p3x~kXGvF6tlegc2QlXC5KtJ2VY3oZwORkEKlowpasv5Hy3GLiNnTtgj6djpToK0KuWmCc3bZ2p9zWqJ0PknPpDBO0510xXMO-ey4usJUXrlaltb0Rf2oTBRJWQRFfo1zvqDg5ZPblQ__'),
                  ),
                  SizedBox(width: 1.w,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(text: 'Alex meian', fontSize: 12, color: Colors.black,fontWeight: FontWeight.w500,),
                      SizedBox(height: 0.7.h),
                      AppTextWidget(text: 'Prodcut manager', fontSize: 10, color: Colors.grey),
                    ],
                  ),
                  SizedBox(width: 0.8.w),
                  Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black.withOpacity(0.5)),
                ],
              ),
            )
            // DropdownButton<String>(
            //   items: <String>['Profile', 'Settings', 'Logout'].map((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            //   onChanged: (_) {},
            //   underline: SizedBox(),
            //   icon: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
