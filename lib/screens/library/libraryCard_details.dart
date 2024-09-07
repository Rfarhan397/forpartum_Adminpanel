import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/app_text_field.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/chip/chip_provider.dart';

class LibraryCardDetails extends StatelessWidget {
  LibraryCardDetails({super.key});
  final List<String> categories = [
    '1-12 Months Postpartum ',
    '12-24 Months Postpartum ',
    '24-36+ Months Postpartum ',
  ];
  @override
  Widget build(BuildContext context) {
    final chipProvider = Provider.of<ChipProvider>(context);

    return Scaffold(
        appBar: const CustomAppbar(text: 'Milestone Tracker'),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(
                height: 1.0,
                color: Colors.grey[300],
              ),
              SizedBox(height: 1.h),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: categories.map((category) {
                    final isSelected =
                        chipProvider.selectedCategory == category;
                    final isHovered = chipProvider.hoveredCategory == category;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: MouseRegion(
                        onEnter: (_) {
                          chipProvider.setHoveredCategory(category);
                        },
                        onExit: (_) {
                          chipProvider.clearHoveredCategory();
                        },
                        child: GestureDetector(
                          onTap: () {
                            chipProvider.selectCategory(category);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 14.0),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryColor
                                  : isHovered
                                      ? primaryColor
                                      : secondaryColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: AppTextWidget(
                              text: category,
                              color: isSelected
                                  ? Colors.white
                                  : isHovered
                                      ? Colors.white
                                      : Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    width: 30.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                        ListView.builder(
                          itemCount: 9,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  child: AppTextWidget(
                                      text: index % 2 == 0
                                          ? 'How to apply for a campaign?'
                                          : 'How to know status of a campaign?',
                                      textAlign: TextAlign.start,
                                      fontSize: 12),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey[300],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w,),
                  SizedBox(
                      width: 25.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const AppTextWidget(text:
                            'Add New Milestone',
                                fontSize: 14, fontWeight: FontWeight.bold),
                          const SizedBox(height: 20),
                          const AppTextField(
                            radius: 8,
                              hintText: 'Postpartum Nutrition',
                          ),
                          SizedBox(height: 15.h,),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ButtonWidget(text: 'Upload', onClicked: () {

                            },
                                width: 10.w, height: 5.h, fontWeight: FontWeight.w500),
                          )

                        ],
                      )),
                ]),
              )
            ])));
  }
}
