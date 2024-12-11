import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/main.dart';
import 'package:forpartum_adminpanel/model/res/components/app_button_widget.dart';
import 'package:forpartum_adminpanel/model/res/constant/app_assets.dart';
import 'package:forpartum_adminpanel/model/res/constant/app_utils.dart';
import 'package:forpartum_adminpanel/model/res/widgets/app_text_field.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/menu_App_Controller.dart';
import '../../user_model/user_model.dart';

class SecureAccessDialog extends StatelessWidget {
  final User? parameters;
  final String appPassword = '@mila2024';
  SecureAccessDialog({required this.parameters, Key? key}) : super(key: key);

  TextEditingController passwordTextFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var user = parameters;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 30.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Image.asset(
              AppAssets.logoImage,
              width: 60,
            ),
            SizedBox(height: 20),
            Text(
              'Secure Access Required',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'To access sensitive user data, please re-enter your admin password. Your security is our priority.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 30.w,
              child: AppTextField(
                obscureText: true,
                  controller: passwordTextFieldController,
                  radius: 12,
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Password'),
            ),
            SizedBox(height: 10),
            SizedBox(height: 20),
            AppButtonWidget(
                alignment: Alignment.center,
                width: 20.w,
                radius: 20,
                onPressed: () {
                  if (passwordTextFieldController.text == appPassword) {
                    // Close the dialog
                    Navigator.of(context).pop();
                    // Navigate to the next screen
                    Provider.of<MenuAppController>(context, listen: false)
                        .addBackPage(1);
                    Provider.of<MenuAppController>(context, listen: false)
                        .changeScreenWithParams(12, parameters: user);
                  } else {
                    AppUtils().showToast(text:'Incorrect password. Please try again.',bgColor: Colors.red );
                  }
                },
                text: 'Authenticate'),
          ],
        ),
      ),
    );
  }
}
