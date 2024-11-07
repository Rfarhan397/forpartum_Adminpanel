import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/screens/blog/add_category.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/navigationBar.dart';
import '../../model/res/components/responsive.dart';
import '../../model/res/routes/routes_name.dart';
import '../../provider/navigation/navigationProvider.dart';
import '../LearningCenter/learningCategory.dart';
import '../LearningCenter/learningCenterScreen.dart';
import '../blog/add_blog_screen.dart';
import '../blog/blog_screen.dart';
import '../chat_support/chat_support.dart';
import '../guidline/guidelineScreen.dart';
import '../insight/insight.dart';
import '../library/libraryCard_details.dart';
import '../library/library_screen.dart';
import '../meal_plans/addMealCategory.dart';
import '../meal_plans/add_meal.dart';
import '../meal_plans/add_meal_plan.dart';
import '../meal_plans/meal_plans.dart';
import '../meal_plans/view_meal.dart';
import '../menu_settings/FAQ/addNewFaq.dart';
import '../menu_settings/FAQ/faqScreen.dart';
import '../menu_settings/menu_setting.dart';
import '../menu_settings/policy/addNewPolicy.dart';
import '../menu_settings/policy/privacy.dart';
import '../menu_settings/setting/menuSettingsDetail_screen.dart';
import '../menu_settings/termsNCondition/addTermsNConditions.dart';
import '../menu_settings/termsNCondition/termsNCondition.dart';
import '../notifications/AddNotification.dart';
import '../notifications/notifications.dart';
import '../trackers/trackerScreen.dart';
import '../users/user_detail.dart';
import '../users/user_screen.dart';
import 'homeScreen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menuAppController = Provider.of<MenuAppController>(context);
    Widget screen;
    switch (menuAppController.selectedIndex) {
      case 0:
        screen = HomeScreen();
        break;
      case 1:
        screen = UserScreen();
        break;

      case 2:
        screen = ChatSupportScreen();
        break;

      case 3:
        screen = InsightScreen();
        break;

      case 4:
        screen = BlogScreen();
        break;

      case 5:
        screen =  MealPlanScreen();
        break;

      case 6:
        screen = Notifications();
        break;

      case 7:
        screen = const LibraryScreen();
        break;

      case 8:
        screen = MenuSetting();
        break;

        case 9:
          screen = AddMealPlanScreen();
          break;
        case 10:
          screen = ViewMealScreen();
          break;
        case 11:
          screen = AddMealScreen();
          break;
        case 12:
          screen = UserDetail();
          break;
        case 13:
          screen = AddBlogScreen();
          break;
          case 14:
          screen = LibraryCardDetails();
          break;
          case 15:
          screen = FaqScreen();
          break;
          case 16:
          screen = PrivacyScreen();
          break;
          case 17:
          screen = TermsNCondition();
          break;
          case 18:
          screen = AddtermsNConditions();
          break;
          case 19:
          screen =  MenuSettingsDetailScreen();
          break;
          case 20:
          screen =  AddNotification();
          break;
          case 21:
          screen =  AddNewFaq();
          break;
          case 22:
          screen =  AddNewPolicy();
          break;
          case 23:
          screen =  AddCategory();
          break;
          case 24:
          screen =  AddMealCategory();
          break;
          case 25:
          screen =  GuidelineScreen();
          break;
          case 26:
          screen =  LearningCenterScreen();
          break;
          case 27:
          screen =  LearningCategory();
          break;
          case 28:
          screen =  TrackerScreen();
          break;

      default:
        screen = HomeScreen();
        break;
    }
    return Scaffold(
      extendBody: true,
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: CustomNavigationBar(),
      body: Stack(
        children: [
          Row(
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  flex: 2,
                  child: CustomNavigationBar(),
                ),
              Expanded(
                flex: 10,
                child: screen,
              ),
            ],
          ),
          // if (Responsive.isDesktop(context))
            Positioned(
              left: 15.8.w, // Adjust this value as needed
              top: 2.2.h, // Adjust this value as needed
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    menuAppController.closeDrawer();
                  },
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
