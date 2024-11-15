import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/custom_dropDown.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../provider/dropDOwn/dropdown.dart';

class AddMealPlanScreen extends StatelessWidget {
  const AddMealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppbar(text: 'Dashboard'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Divider(
            height: 1,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                AppTextWidgetFira(
                  text: 'Meal Plan Name',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                Row(
                  children: [
                    Container(
                      width: 30.w,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                fillColor: Color(0xffF7FAFC),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffD1DBE8)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffD1DBE8)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffD1DBE8)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: 'Mother Essence',
                                hintStyle: TextStyle(
                                    fontSize: 14, color: Color(0xff4F7396))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AppTextWidgetFira(
                            text: 'Description',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 1.h,),
                          Container(
                            width: 25.w,
                            height: 50.h,
                            child: TextFormField(
                              maxLines: 15,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffD1DBE8)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 40.0, horizontal: 25),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xffF7FAFC),
                                border: Border.all(
                                  color: Color(0xffD1DBE1),
                                  width: 1,
                                ),
                              ),
                              child: AppTextWidgetFira(
                                text: 'Upload Image',
                                color: Color(0xff4F7396),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Container(
                      width: 30.w,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Consumer<DropdownProviderN>(
                              //   builder: (context, dropdownProvider, child) {
                              //     return CustomDropdownWidget(
                              //       index: 1,
                              //       items: ['Dietary', 'Dietary'],
                              //       dropdownType: 'Dietary Category',
                              //     );
                              //   },
                              // ),                              SizedBox(width: 1.w),

                              // Consumer<DropdownProviderN>(
                              //   builder: (context, dropdownProvider, child) {
                              //     return CustomDropdownWidget(
                              //       index: 2,
                              //       items: ['Status', 'Status'],
                              //       dropdownType: 'Status',
                              //     );
                              //   },
                              // ),
                              SizedBox(width: 1.w),
                              // Consumer<DropdownProviderN>(
                              //   builder: (context, dropdownProvider, child) {
                              //     return CustomDropdownWidget(
                              //       index: 3,
                              //       items: ['Meal Plan Duration', 'Meal Plan Duration'],
                              //       dropdownType: 'Meal Plan Duration',
                              //     );
                              //   },
                              // ),
                              // Consumer<DropdownProvider>(
                              //   builder: (context, provider, child) {
                              //     return Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         GestureDetector(
                              //           onTap: provider.toggleDropdown,
                              //           child: Container(
                              //             padding: EdgeInsets.symmetric(
                              //                 horizontal: 8.0, vertical: 2.0),
                              //             decoration: BoxDecoration(
                              //               border: Border.all(
                              //                   color: primaryColor),
                              //               borderRadius:
                              //               BorderRadius.circular(8.0),
                              //             ),
                              //             child: Row(
                              //               mainAxisSize: MainAxisSize.min,
                              //               children: [
                              //                 AppTextWidgetFira(text:
                              //                 provider.selectedCategory,
                              //                     color: primaryColor),
                              //                 Icon(
                              //                   provider.isDropdownOpen
                              //                       ? Icons.arrow_drop_up
                              //                       : Icons.arrow_drop_down,
                              //                   color: primaryColor,
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //         if (provider.isDropdownOpen)
                              //           Container(
                              //             margin: EdgeInsets.only(top: 8.0),
                              //             decoration: BoxDecoration(
                              //               border: Border.all(
                              //                   color: primaryColor),
                              //               borderRadius:
                              //               BorderRadius.circular(10.0),
                              //             ),
                              //             child: Column(
                              //               crossAxisAlignment:
                              //               CrossAxisAlignment.stretch,
                              //               children: categories.map((category) {
                              //                 return GestureDetector(
                              //                   onTap: () => provider
                              //                       .selectCategory(category),
                              //                   child: Padding(
                              //                     padding:
                              //                     const EdgeInsets.symmetric(
                              //                         vertical: 8.0,
                              //                         horizontal: 16.0),
                              //                     child: AppTextWidgetFira(text: category),
                              //                   ),
                              //                 );
                              //               }).toList(),
                              //             ),
                              //           ),
                              //       ],
                              //     );
                              //   },
                              // ),
                              // SizedBox(width: 1.w,),
                              // Consumer<DropdownProvider>(
                              //   builder: (context, provider, child) {
                              //     return Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         GestureDetector(
                              //           onTap: provider.toggleDropdown,
                              //           child: Container(
                              //             padding: EdgeInsets.symmetric(
                              //                 horizontal: 8.0, vertical: 2.0),
                              //             decoration: BoxDecoration(
                              //               border: Border.all(
                              //                   color: primaryColor),
                              //               borderRadius:
                              //               BorderRadius.circular(8.0),
                              //             ),
                              //             child: Row(
                              //               mainAxisSize: MainAxisSize.min,
                              //               children: [
                              //                 AppTextWidgetFira(text:
                              //                 provider.selectedStatusCategory,
                              //                     color: primaryColor),
                              //                 Icon(
                              //                   provider.isDropdownOpen
                              //                       ? Icons.arrow_drop_up
                              //                       : Icons.arrow_drop_down,
                              //                   color: primaryColor,
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //         if (provider.isDropdownOpen)
                              //           Container(
                              //             margin: EdgeInsets.only(top: 8.0),
                              //             decoration: BoxDecoration(
                              //               border: Border.all(
                              //                   color: primaryColor),
                              //               borderRadius:
                              //               BorderRadius.circular(10.0),
                              //             ),
                              //             child: Column(
                              //               crossAxisAlignment:
                              //               CrossAxisAlignment.stretch,
                              //               children: categories.map((category) {
                              //                 return GestureDetector(
                              //                   onTap: () => provider
                              //                       .selectCategory(category),
                              //                   child: Padding(
                              //                     padding:
                              //                     const EdgeInsets.symmetric(
                              //                         vertical: 8.0,
                              //                         horizontal: 16.0),
                              //                     child: AppTextWidgetFira(text: category),
                              //                   ),
                              //                 );
                              //               }).toList(),
                              //             ),
                              //           ),
                              //       ],
                              //     );
                              //   },
                              // ),
                              // SizedBox(width: 1.w,),
                              // Consumer<DropdownProvider>(
                              //   builder: (context, provider, child) {
                              //     return Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         GestureDetector(
                              //           onTap: provider.toggleDropdown,
                              //           child: Container(
                              //             padding: EdgeInsets.symmetric(
                              //                 horizontal: 16.0, vertical: 2.0),
                              //             decoration: BoxDecoration(
                              //               border: Border.all(
                              //                   color: primaryColor),
                              //               borderRadius:
                              //               BorderRadius.circular(8.0),
                              //             ),
                              //             child: Row(
                              //               mainAxisSize: MainAxisSize.min,
                              //               children: [
                              //                 AppTextWidgetFira(text:
                              //                 provider.selectedMealCategory,
                              //                     color: primaryColor),
                              //                 Icon(
                              //                   provider.isDropdownOpen
                              //                       ? Icons.arrow_drop_up
                              //                       : Icons.arrow_drop_down,
                              //                   color: primaryColor,
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //         if (provider.isDropdownOpen)
                              //           Container(
                              //             margin: EdgeInsets.only(top: 8.0),
                              //             decoration: BoxDecoration(
                              //               border: Border.all(
                              //                   color: primaryColor),
                              //               borderRadius:
                              //               BorderRadius.circular(10.0),
                              //             ),
                              //             child: Column(
                              //               crossAxisAlignment:
                              //               CrossAxisAlignment.stretch,
                              //               children: categories.map((category) {
                              //                 return GestureDetector(
                              //                   onTap: () => provider
                              //                       .selectCategory(category),
                              //                   child: Padding(
                              //                     padding:
                              //                     const EdgeInsets.symmetric(
                              //                         vertical: 8.0,
                              //                         horizontal: 16.0),
                              //                     child: AppTextWidgetFira(text: category),
                              //                   ),
                              //                 );
                              //               }).toList(),
                              //             ),
                              //           ),
                              //       ],
                              //     );
                              //   },
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AppTextWidgetFira(
                            text: 'Benefits:',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 1.h,),
                          Container(
                            width: 25.w,
                            height: 50.h,
                            child: TextFormField(
                              maxLines: 15,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffD1DBE8)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 40.0, horizontal: 25),
                                child: GestureDetector(
                                  onTap: () {
                                    // Provider.of<MenuAppController>(context, listen: false)
                                    //     .changeScreen(11);
                                    // Get.toNamed(RoutesName.viewMeals);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: secondaryColor,
                                    ),
                                    child: AppTextWidgetFira(
                                      text: 'View Meals For This Plan',
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 40.0, horizontal: 25),
                                child: InkWell(
                                  onTap: () {
                                    Provider.of<MenuAppController>(context, listen: false)
                                        .changeScreen(10);

                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.grey,
                                    ),
                                    child: AppTextWidgetFira(
                                      text: 'Edit/Upload Meals',
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 100,
                    height: 30,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(right: 15.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: primaryColor,
                    ),
                    child: AppTextWidgetFira(
                      text: 'Upload',
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
