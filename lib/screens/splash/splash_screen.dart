import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../constant.dart';
import '../../model/res/constant/app_assets.dart';
import '../../model/res/constant/app_icons.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/app_text_field.dart';
import '../../model/res/widgets/hover_button_loader.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/auth/auth_provider.dart';

class SplashScreen extends StatelessWidget {

   SplashScreen({super.key});
   final TextEditingController _emailController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();
   var username,password;

   final GlobalKey<FormState> _key = GlobalKey<FormState>();

   @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: primaryColor,
        //   title: const Text("APP_NAME"),
        //   actions: [
        //     CustomSwitchWidget(),
        //   ],
        // ),
        backgroundColor: primaryColor,
        body: Center(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // GestureDetector(
                //     onTap: () {},
                //     child: SvgPicture.asset(AppIcons.closeButton,fit: BoxFit.cover,height: 40,)),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  height: 70.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 10.h,
                                  child: Image.asset(
                                    AppAssets.logoImage,
                                  )),
                              const AppTextWidget(
                                text: 'Login',
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        const AppTextWidget(
                          text: 'E-mail',
                          fontSize: 10,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                         AppTextField(
                          hintText: 'hintText@gmail.com',
                          radius: 80,
                          controller: _emailController,
                           validator: (email){
                            if (_emailController.text.isNotEmpty){
                              return AppUtils().validateEmail(email);

                            }
                            return 'Required';
                           },
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                         AppTextWidget(
                          text: 'Password',
                          fontSize: 10,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                         AppTextField(
                          hintText: 'xxxxxxxxxxxx',
                          radius: 80,
                          controller: _passwordController,
                           validator: (password){
                             if (_passwordController.text.isNotEmpty){
                               return AppUtils().passwordValidator(password);

                             }
                             return 'Required';
                           },
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 1.h,
                                  width: 0.5.w,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(0.3)),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const AppTextWidget(
                                  text: 'Remember me',
                                  fontSize: 10,
                                )
                              ],
                            ),
                            const AppTextWidget(
                              text: 'Forgot Password?',
                              textDecoration: TextDecoration.underline,
                              color: primaryColor,
                              fontSize: 10,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        HoverLoadingButton(text: 'Login',
                          textColor: Colors.white,
                          radius: 80,
                          height: 6.h,
                          width: 100.w,
                          fontSize: 12,
                          isIcon: false,
                          fontWeight: FontWeight.w400,
                          onClicked: () async{
                          if(_key.currentState!.validate()){
                            _key.currentState!.save();
                            ActionProvider().setLoading(true);
                          Provider.of<AuthProvider>(context,listen: false).signInUser(email: _emailController.text.toString(),
                              password: _passwordController.text.toString(), context: context);
                          }

                            //Get.offNamed(RoutesName.mainScreen);
                            // Get.to(LoginPage());
                          },
                        ),
                        // ButtonWidget(
                        //   text: 'Login',
                        //   fontWeight: FontWeight.w400,
                        //   onClicked: () {
                        //     saveData(context);
                        //     //Get.offNamed(RoutesName.mainScreen);
                        //     // Get.to(LoginPage());
                        //   },
                        //   textColor: Colors.white,
                        //   radius: 80,
                        //   height: 6.h,
                        //   width: 100.w,
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

}
