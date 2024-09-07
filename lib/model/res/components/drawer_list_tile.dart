import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forpartum_adminpanel/model/res/components/responsive.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../constant.dart';
import '../../../controller/menu_App_Controller.dart';
import '../../../provider/textColor/text_color_provider.dart';
import '../widgets/app_text.dart.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.index,
    required this.screenIndex,
    required this.title,
    required this.svgSrc,
  }) : super(key: key);

  final String title, svgSrc;
  final int index, screenIndex;

  @override
  Widget build(BuildContext context) {
    final textColorProvider =
    Provider.of<TextColorProvider>(context, listen: false);
    final provider = Provider.of<MenuAppController>(context, listen: false);

    return Container(
        margin: EdgeInsets.only(left: 3.5.w, right: 0.1.w),
        child: Consumer<TextColorProvider>(builder: (context, value, child) {
          return MouseRegion(
            onHover: (_) {
              textColorProvider.setHoveredIndex(index);
            },
            onExit: (_) {
              textColorProvider.setHoveredIndex(-1);
            },
            child: GestureDetector(
              onTap: () {
                provider.parameters?.clear();
                textColorProvider.setActiveIndex(index);
                Provider.of<MenuAppController>(context, listen: false)
                    .changeScreen(screenIndex);
                if (Responsive.isMobile(context)) {
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding: EdgeInsets.all(0.5.h),
                child: Container(
                  width: 10.w,
                  padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: textColorProvider.activeIndex == index ||
                        textColorProvider.hoveredIndex == index
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        svgSrc,
                        colorFilter: ColorFilter.mode(
                            textColorProvider.activeIndex == index ||
                                textColorProvider.hoveredIndex == index
                                ? primaryColor
                                : Colors.white,
                            BlendMode.srcIn),
                        height: 16,
                      ),
                      SizedBox(width: 0.5.w),
                      AppTextWidget(
                          text: title,
                          color: textColorProvider.activeIndex == index ||
                              textColorProvider.hoveredIndex == index
                              ? primaryColor
                              : Colors.white,
                          fontSize: 12),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
