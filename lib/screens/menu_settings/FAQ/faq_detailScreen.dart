import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/components/add_button.dart';
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
            InkWell(
              hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              onTap: () {
                Provider.of<MenuAppController>(context, listen: false)
                    .changeScreen(21);
              },
              child:AddButton(text: 'Add New FAQ')
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
