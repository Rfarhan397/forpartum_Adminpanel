import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forpartum_adminpanel/constant.dart';
import 'package:forpartum_adminpanel/controller/menu_App_Controller.dart';
import 'package:forpartum_adminpanel/model/res/components/app_back_button.dart';
import 'package:forpartum_adminpanel/model/res/components/responsive.dart';
import 'package:forpartum_adminpanel/model/res/routes/routes_name.dart';
import 'package:forpartum_adminpanel/provider/profileInfo/profileInfoProvider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../constant/app_assets.dart';
import '../constant/app_colors.dart';
import '../constant/app_icons.dart';
import '../widgets/app_text.dart.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const CustomAppbar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileInfoProvider>(context, listen: false); // Listen to updates
    // Initialize the profile listener when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profile.listenToProfileInfo();
    });
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
            SizedBox(width: 0.5.w),
            AppTextWidget(
              text: text,
              fontWeight: FontWeight.w400,
              fontSize: isMobile ? 15 : 28,
            ),
            const Spacer(flex: 3),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: profile.profileImageUrl != null && profile.profileImageUrl!.isNotEmpty
                        ? NetworkImage(profile.profileImageUrl!)
                        : const AssetImage(AppAssets.logoImage) as ImageProvider,
                  ),
                  SizedBox(width: 1.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(
                        text: profile.profileName?.isNotEmpty == true
                            ? profile.profileName!
                            : "Admin",
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 0.7.h),
                      AppTextWidget(
                        text: profile.profileRole?.isNotEmpty == true
                            ? profile.profileRole!
                            : 'Super Admin',
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(width: 0.8.w),
                  InkWell(
                    onTap: () {
                      _showCustomPopupMenu(context, _buildProfilePopUp(context));
                    },
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomPopupMenu(BuildContext context, Widget child) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      color: bgColor,
      surfaceTintColor: whiteColor,
      position: RelativeRect.fromLTRB(
        overlay.size.width + 10.w,
        kToolbarHeight,
        0,
        0,
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          child: child,
        ),
      ],
    );
  }

  Widget _buildProfilePopUp(BuildContext context) {
    final profileProvider = Provider.of<ProfileInfoProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileProvider.listenToProfileInfo();
    });
    return Consumer<ProfileInfoProvider>(
      builder: (context, profileInfo, child) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 200,
            width: 120,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: profileInfo.profileImageUrl != null
                      ? NetworkImage(profileInfo.profileImageUrl!)
                      : const AssetImage(AppAssets.logoImage) as ImageProvider,
                ),
                AppTextWidget(
                  text: profileInfo.profileName.toString(),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
                AppTextWidget(
                  text:  profileInfo.profileEmail.toString(),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                ),
                InkWell(
                  onTap: () {
                    Provider.of<MenuAppController>(context, listen: false)
                        .addBackPage(30);
                    Provider.of<MenuAppController>(context, listen: false)
                        .changeScreen(30);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppIcons.activeUser,
                          color: primaryColor,
                          height: 15,
                        ),
                        SizedBox(width: 1.h),
                        const AppTextWidget(
                          text: "View Profile",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.offAllNamed(RoutesName.splashScreen);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppIcons.insight,
                          color: primaryColor,
                          height: 15,
                        ),
                        SizedBox(width: 1.h),
                        const AppTextWidget(
                          text: "Log Out",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
