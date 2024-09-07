import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constant.dart';
import '../../../controller/menu_App_Controller.dart';
import '../../../model/res/components/FAQ_widget.dart';
import '../../../model/res/components/custom_appBar.dart';
import '../../../model/res/routes/routes_name.dart';
import '../../../model/res/widgets/app_text.dart.dart';

class FaqDetailscreen extends StatelessWidget {
  const FaqDetailscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: 'FAQ',),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Provider.of<MenuAppController>(context, listen: false)
                        .changeScreen(21);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: primaryColor,
                    ),
                    child: Center(
                      child: Icon(Icons.add,color: Colors.white,),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                AppTextWidget(text: 'Add New FAQ',fontSize: 14,color: Colors.black,)
              ],
            ),
            SizedBox(height: 4.h,),
            AppTextWidget(text: 'FAQ',fontSize: 12,color: Colors.black,fontWeight: FontWeight.w700,),
            FaqWidget(),
          ],
        ),
      ),
    );
  }
}
