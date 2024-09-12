import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/custom_dropDown.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/app_text_field.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/dropDOwn/dropdown.dart';

class AddNotification extends StatelessWidget {
  const AddNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: CustomAppbar(text: 'Create New Notification'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 10,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 400,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextWidget(text: 'Title',fontWeight: FontWeight.w500,),
                          SizedBox(height: 1.h,),
                          AppTextFieldBlue(hintText: 'Input Field',),
                          AppTextWidget(text: 'Message',fontWeight: FontWeight.w500,),
                          SizedBox(height: 1.h,),
                          AppTextFieldBlue(hintText: 'Input Field'),
                        ],
                      )
                    ),
                    SizedBox(width: 5.w,),
                    Container(
                      height: 70,
                      alignment: Alignment.center,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //buildDropDown(context, 2),

                          // Consumer<DropdownProviderN>(
                          //   builder: (context, dropdownProvider, child) {
                          //     return CustomDropdownWidget(
                          //       index: 2,
                          //       items: [ 'Email', 'SMS', 'Push Notification ',],
                          //      dropdownType: 'Type',
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h,),
                Container(
                  width: 45.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTextWidget(text: 'Schedule:'),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: ButtonWidget(
                                  onClicked: () {
                                    // Logic to handle form submission
                                  },
                                  text:('Cancel'),
                                  backgroundColor: secondaryColor,
                                  oneColor: true,
                                  borderColor: secondaryColor,
                                  height: 4.h,
                                  width: 8.w,
                                  textColor: Colors.white,
                                  radius: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 1.5.w,),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ButtonWidget(
                                  onClicked: () {
                                    // Logic to handle form submission
                                  },
                                  text:('Upload'),
                                  height: 4.h,
                                  width: 8.w,
                                  textColor: Colors.white,
                                  radius: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
  Consumer<DropdownProviderN> buildDropDown(BuildContext context, int index) {
    final List<String> Type = [
      'Email',
      'SMS',
      'Push Notification ',
    ];
    return Consumer<DropdownProviderN>(
      builder: (context, dropdownProvider, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 4.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: primaryColor,
                        width: 1.0,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        dropdownProvider
                            .closeOtherDropdowns(index); // Close other dropdowns
                        dropdownProvider.toggleDropdownVisibility(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AppTextWidget(
                              text: dropdownProvider.selectedType,
                              color: primaryColor,
                            ),
                            Icon(
                              dropdownProvider.isDropdownVisible(index)
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down_rounded,
                              color: primaryColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (dropdownProvider.isDropdownVisible(index))
              Positioned(
                top: 8.8.h,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: primaryColor,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: Type.map((Type) {
                      return GestureDetector(
                        onTap: () {
                          dropdownProvider.setSelectedLanguage(Type);
                          dropdownProvider.toggleDropdownVisibility(index);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 5.0),
                          child: AppTextWidget(
                            text: Type,
                            fontSize: 10,
                            textAlign: TextAlign.start,
                            softWrap: false,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

}
