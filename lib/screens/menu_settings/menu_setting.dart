import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../model/res/components/cuatom_card.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../provider/libraryCard/card_provider.dart';

class MenuSetting extends StatelessWidget {
  const MenuSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppbar(text: 'Dashboard'),
      body: Column(
        children: [
          Divider(
            height: 10,
            color: Colors.grey[300],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
              child: Consumer<CardProviderMenu>(
                builder: (context, provider, _) {
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: provider.currentCards.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 2.5,
                    ),
                    itemBuilder: (context, index) {
                      return CustomCardM(
                         index: index,
                          //setting index pages pending
                          title: provider.currentCards[index]);
                    },
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 2.h,)
        ],
      ),
    );
  }
}
