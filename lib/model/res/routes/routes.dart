
import 'package:forpartum_adminpanel/model/res/routes/routes_name.dart';
import 'package:forpartum_adminpanel/screens/users/user_detail.dart';
import 'package:get/get.dart';

import '../../../screens/blog/add_blog_screen.dart';
import '../../../screens/blog/blog_screen.dart';
import '../../../screens/blog/editBlogPost.dart';
import '../../../screens/chat_support/chat_support.dart';
import '../../../screens/feedback/feedbacks.dart';
import '../../../screens/homeScreen/homeScreen.dart';
import '../../../screens/homeScreen/mainScreen.dart';
import '../../../screens/library/libraryCard_details.dart';
import '../../../screens/library/library_screen.dart';
import '../../../screens/meal_plans/addMealCategory.dart';
import '../../../screens/meal_plans/add_meal.dart';
import '../../../screens/meal_plans/add_meal_plan.dart';
import '../../../screens/meal_plans/editMealPlan.dart';
import '../../../screens/meal_plans/meal_plans.dart';
import '../../../screens/meal_plans/view_meal.dart';
import '../../../screens/menu_settings/FAQ/addNewFaq.dart';
import '../../../screens/menu_settings/FAQ/faqScreen.dart';
import '../../../screens/menu_settings/menu_setting.dart';
import '../../../screens/menu_settings/policy/addNewPolicy.dart';
import '../../../screens/menu_settings/policy/privacy.dart';
import '../../../screens/menu_settings/setting/editProfileScreen.dart';
import '../../../screens/menu_settings/setting/menuSettingsDetail_screen.dart';
import '../../../screens/menu_settings/termsNCondition/addTermsNConditions.dart';
import '../../../screens/menu_settings/termsNCondition/termsNCondition.dart';
import '../../../screens/notifications/AddNotification.dart';
import '../../../screens/notifications/notifications.dart';
import '../../../screens/splash/splash_screen.dart';
import '../../../screens/users/userTrackerHistory/userTrackerHistoryScreen.dart';

class Routes {
  static final routes = [
    GetPage(name: RoutesName.splashScreen, page: () => SplashScreen()),
    GetPage(name: RoutesName.homeScreen, page: () => HomeScreen(),),
    GetPage(name: RoutesName.mainScreen, page: () => MainScreen()),
    GetPage(name: RoutesName.userDetails, page: () => UserDetail()),
    GetPage(name: RoutesName.chatSupport, page: () => ChatSupportScreen()),
    GetPage(name: RoutesName.mealPlan, page: () => MealPlanScreen()),
    GetPage(name: RoutesName.addMealPlan, page: () => AddMealPlanScreen()),
    GetPage(name: RoutesName.viewMeals, page: () => ViewMealScreen()),
    GetPage(name: RoutesName.addMeal, page: () => AddMealScreen()),
    GetPage(name: RoutesName.addMealCategory, page: () => AddMealCategory()),
    GetPage(name: RoutesName.addMeal, page: () => BlogScreen()),
    GetPage(name: RoutesName.addBlogPost, page: () => AddBlogScreen()),
    GetPage(name: RoutesName.libraryScreen, page: () => LibraryScreen()),
    GetPage(name: RoutesName.cardDetailsScreen, page: () => MileStoneScreen(),),
    GetPage(name: RoutesName.cardDetailsScreen, page: () => MenuSetting()),
    GetPage(name: RoutesName.menuSettingsDetailScreen, page: () => MenuSettingsDetailScreen()),
    GetPage(name: RoutesName.faqDetailScreen, page: () => FaqScreen()),
    GetPage(name: RoutesName.faqAddScreen, page: () => AddNewFaq()),
    GetPage(name: RoutesName.privacyPolicy, page: () => PrivacyScreen()),
    GetPage(name: RoutesName.addNewPolicy, page: () => AddNewPolicy()),
    GetPage(name: RoutesName.termsNCondition, page: () => TermsNCondition()),
    GetPage(name: RoutesName.addtermsNCondition, page: () => AddtermsNConditions()),
    GetPage(name: RoutesName.Notifications, page: () => Notifications()),
    GetPage(name: RoutesName.addNewNotifications, page: () => AddNotification()),
    GetPage(name: RoutesName.userTrackerHistory, page: () => UserTrackerHistoryScreen()),
    GetPage(name: RoutesName.editProfile, page: () => EditProfileScreen()),
    GetPage(name: RoutesName.editBlogPost, page: () => EditBlogPost()),
    GetPage(name: RoutesName.feedbackScreen, page: () => FeedbackScreen()),
    GetPage(name: RoutesName.editMealPlan, page: () => EditMealPlan()),
  ];
}
