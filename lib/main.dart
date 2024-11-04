import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/provider/action/action_provider.dart';
import 'package:forpartum_adminpanel/provider/activity/acitivity_provider.dart';
import 'package:forpartum_adminpanel/provider/auth/auth_provider.dart';
import 'package:forpartum_adminpanel/provider/blog/blog_provider.dart';
import 'package:forpartum_adminpanel/provider/chip/chip_provider.dart';
import 'package:forpartum_adminpanel/provider/cloudinary/cloudinary_provider.dart';
import 'package:forpartum_adminpanel/provider/constant/password_visibility_provider.dart';
import 'package:forpartum_adminpanel/provider/dropDOwn/dropdown.dart';
import 'package:forpartum_adminpanel/provider/libraryCard/card_provider.dart';
import 'package:forpartum_adminpanel/provider/milestone/mileStoneProvider.dart';
import 'package:forpartum_adminpanel/provider/navigation/navigationProvider.dart';
import 'package:forpartum_adminpanel/provider/notification_provider/notification_provider.dart';
import 'package:forpartum_adminpanel/provider/stream/streamProvider.dart';
import 'package:forpartum_adminpanel/provider/textColor/text_color_provider.dart';
import 'package:forpartum_adminpanel/provider/theme/theme_provider.dart';
import 'package:forpartum_adminpanel/provider/tracker/trackerProvider.dart';
import 'package:forpartum_adminpanel/provider/user_provider/user_provider.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'constant.dart';
import 'controller/menu_App_Controller.dart';
import 'firebase_options.dart';
import 'model/language/applocalization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'model/res/constant/app_colors.dart';
import 'model/res/routes/routes.dart';
import 'model/res/routes/routes_name.dart';
import 'model/services/Api/notification_API.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseApi firebaseApi = FirebaseApi();
  // await firebaseApi.initNotifications();
  if (kIsWeb) {
    await Firebase.initializeApp();
  }
  await ThemeLanguageProvider().loadThemeMode();
  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString('languageCode') ?? 'en';

  runApp(MyApp(initialLocale: Locale(languageCode),));
}

class MyApp extends StatelessWidget {
  final Locale? initialLocale;
  const MyApp({super.key, this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeLanguageProvider()..setLocale(initialLocale ?? Locale('en'))),
        ChangeNotifierProvider(create: (_) => VisibilityProvider()),
        ChangeNotifierProvider(create: (_) => ActionProvider()),
        ChangeNotifierProvider(create: (_) => MenuAppController()),
        ChangeNotifierProvider(create: (_) => TextColorProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => DropdownProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ActivityLogProvider()),
        ChangeNotifierProvider(create: (_) => ChipProvider()),
        ChangeNotifierProvider(create: (_) => BlogPostProvider()),
        ChangeNotifierProvider(create: (_) => DropdownProviderN()),
        ChangeNotifierProvider(create: (_) => CardProvider()),
        ChangeNotifierProvider(create: (_) => CardProviderMenu()),
        ChangeNotifierProvider(create: (_) => FaqProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProviderForNotifications()),
        ChangeNotifierProvider(create: (_) => CloudinaryProvider()),
        ChangeNotifierProvider(create: (_) => StreamDataProvider()),
        ChangeNotifierProvider(create: (_) => MilestoneProvider()),
        ChangeNotifierProvider(create: (_) => TrackerProvider()),
      ],
      child: Consumer<ThemeLanguageProvider>(
        builder: (context,provider,child){
          return Sizer(
            builder: (context, orientation, deviceType) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: "Forpartum",
                locale: provider.locale,
                supportedLocales: const [
                  Locale('en', ''),
                  Locale('ur', ''),
                ],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  AppLocalizationsDelegate(),
                ],
                themeMode: provider.themeMode,
                theme: ThemeData(
                  scaffoldBackgroundColor: AppColors.scaffoldColor,
                  primaryColor: primaryColor,
                  useMaterial3: true,
                  primarySwatch: Colors.deepOrange,
                  colorScheme: const ColorScheme.light(
                    primary: primaryColor,
                  ),
                ),
                darkTheme: ThemeData(
                  primaryColor: primaryColor,
                  scaffoldBackgroundColor: AppColors.scaffoldColor,
                  useMaterial3: true,
                  colorScheme: const ColorScheme.dark(
                      primary: primaryColor,
                      surface: Colors.black
                  ),
                ),
                initialRoute: RoutesName.mainScreen,
                getPages: Routes.routes,
              );
            }
          );
        },
      ),
    );
  }
}
