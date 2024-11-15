import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../controller/menu_App_Controller.dart';
import '../constant/app_assets.dart';
import '../routes/routes_name.dart';
import '../widgets/app_text.dart.dart';

class CustomCard extends StatelessWidget {
  final String title;

  const CustomCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {

        switch (title) {
          case 'CBT Sessions':
            // Provider.of<MenuAppController>(context, listen: false)
            //     .changeScreen(14);
            break;
          case 'Milestone':

            Provider.of<MenuAppController>(context, listen: false)
                .addBackPage(7);
            Provider.of<MenuAppController>(context, listen: false)
                .changeScreen(14);
            break;
          case 'Tackers':
            Provider.of<MenuAppController>(context, listen: false)
                .addBackPage(7);
            Provider.of<MenuAppController>(context, listen: false)
                .changeScreen(28);
            break;
          default:
          // Optionally handle an unknown title case
            break;
        }
        },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(AppAssets.libraryCard),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: AppTextWidget(
            text:
            title,
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
class CustomCardM extends StatelessWidget {
  final String title;
  final int index;


  const CustomCardM({required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    final List<String> routes = [
      RoutesName.faqDetailScreen,
      RoutesName.privacyPolicy,
      RoutesName.termsNCondition,
      RoutesName.menuSettingsDetailScreen,
      // Add more routes here as needed
    ];
    final List<int> routesIndex = [
      15,
      16,
      17,
        19,
      // Add more routes here as needed
    ];
    return InkWell(
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Provider.of<MenuAppController>(context, listen: false)
            .addBackPage(8);
        Provider.of<MenuAppController>(context, listen: false)
            .changeScreen(routesIndex[index]);
        //Get.toNamed(routes[index]);
        //Get.toNamed(RoutesName.menuSettingsDetailScreen);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(AppAssets.libraryCard),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: AppTextWidget(
            text:
            title,
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
