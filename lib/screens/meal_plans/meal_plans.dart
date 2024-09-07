import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/stats_card.dart';
import '../../model/res/constant/app_icons.dart';
import '../../model/res/routes/routes.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../provider/dropDOwn/dropdown.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dropdownProvider = Provider.of<DropdownProvider>(context);

    return Scaffold(
      appBar: const CustomAppbar(text: 'Meal Plan Overview'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Provider.of<MenuAppController>(context, listen: false)
                                  .changeScreen(9);

                              // Get.toNamed(RoutesName.addMealPlan);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: primaryColor,
                              ),
                              child: const Center(
                                child: Icon(Icons.add,color: Colors.white,),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          const AppTextWidget(text: 'Create New Meal Plan'),
                        ],
                      ),
                      SizedBox(width: 10.w,),
                      Container(
                        width: 200,
                        height: 30,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(child: AppTextWidget(text: 'Meal Plan Management')),
                      ),
                    ],
                  ),
                ),
                DropdownButton<String>(
                  value: dropdownProvider.selectedValue,
                  items: <String>['Last 30 Days', 'Last 10 Days', 'Yesterday'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: AppTextWidget(text: value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      dropdownProvider.setSelectedValue(newValue);
                    }
                  },
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down_outlined,size: 15, color: Colors.black),
                ),
              ],
            ),
          ),
          Row(
           children: [
             MealCard(
               iconPath: AppIcons.totalUsers,
               iconBackgroundColor: secondaryColor,
               title: 'Total Meal Plans',
               count: '20',
               increaseColor: Colors.green,
             ),
             MealCard(
               iconPath: AppIcons.activeUser,
               iconBackgroundColor: primaryColor,
               title: 'Active Meal Plans',
               count: '50',
               increaseColor: Colors.red,
             ),
             MealCard(
               iconPath: AppIcons.time,
               iconBackgroundColor: secondaryColor,
               title: 'Most Popular Plan',
               count: 'Mother Essences',
               increaseColor: Colors.green,
             ),
             MealCard(
               iconPath: AppIcons.feedback,
               iconBackgroundColor: primaryColor,
               title: 'Avg rating',
               count: '4.5/5',
               increaseColor: Colors.green,
             ),
           ],
         ),
          SizedBox(height: 2.h,),
         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Container(
               width: 35.w,
               // height: 60.h,
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     const AppTextWidget(text: 'Meal Management Plan',fontSize: 28,fontWeight: FontWeight.w400,),
                     SizedBox(height: 4.h,),
                     // Row(
                     //   mainAxisAlignment: MainAxisAlignment.start,
                     //   crossAxisAlignment: CrossAxisAlignment.start,
                     //   children: [
                     //     Column(
                     //       crossAxisAlignment: CrossAxisAlignment.start,
                     //       children: [
                     //         Container(
                     //           padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                     //           decoration: BoxDecoration(
                     //               color: primaryColor,
                     //               borderRadius: BorderRadius.circular(25)
                     //           ),
                     //           child: const AppTextWidget(text: 'Meal Plan Name',fontSize:10,fontWeight: FontWeight.w400,color: Colors.white),),
                     //         const Padding(
                     //           padding: EdgeInsets.all( 8.0),
                     //           child: Column(
                     //             crossAxisAlignment: CrossAxisAlignment.start,
                     //             children: [
                     //               SizedBox(height: 5,),
                     //               AppTextWidget(text: 'Mother Essences',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Blood Sugar Reg',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Gut Health',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Skin & Hair',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Hormones Balance',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Mother Essences',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Blood Sugar Reg',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Gut Health',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Skin & Hair',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Hormones Balance',fontSize: 10,),
                     //             ],
                     //           ),
                     //         )
                     //
                     //       ],),
                     //     SizedBox(width: 2.w,),
                     //     Column(
                     //       crossAxisAlignment: CrossAxisAlignment.start,
                     //       children: [
                     //         Container(
                     //           padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                     //           decoration: BoxDecoration(
                     //               color: primaryColor,
                     //               borderRadius: BorderRadius.circular(25)
                     //           ),
                     //           child: const AppTextWidget(text: 'Status',fontSize:10,color: Colors.white),),
                     //         const Padding(
                     //           padding: EdgeInsets.all( 8.0),
                     //           child: Column(
                     //             crossAxisAlignment: CrossAxisAlignment.start,
                     //             children: [
                     //               SizedBox(height: 5,),
                     //               AppTextWidget(text: 'Active',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Active',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Active',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Active',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Active',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Active',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Active',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Active',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Active',fontSize: 10,),
                     //               SizedBox(height: 10,),
                     //               AppTextWidget(text: 'Active',fontSize: 10,),
                     //             ],
                     //           ),
                     //         )
                     //
                     //       ],),
                     //     SizedBox(width: 2.w,),
                     //     Column(
                     //       crossAxisAlignment: CrossAxisAlignment.start,
                     //       children: [
                     //         Container(
                     //           padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                     //           decoration: BoxDecoration(
                     //               color: primaryColor,
                     //               borderRadius: BorderRadius.circular(25)
                     //           ),
                     //           child: const AppTextWidget(text: 'Actions',fontSize:10,fontWeight: FontWeight.w400,color: Colors.white),),
                     //         SizedBox(height:12,),
                     //         Column(
                     //           crossAxisAlignment: CrossAxisAlignment.start,
                     //           children: [
                     //             buildRow(),
                     //             SizedBox(height:12,),
                     //
                     //             buildRow(),
                     //             SizedBox(height:12,),
                     //             buildRow(),
                     //             SizedBox(height:12,),
                     //
                     //             buildRow(),                                  SizedBox(height:12,),
                     //             buildRow(),                                 SizedBox(height:12,),
                     //             buildRow(),                                 SizedBox(height:12,),
                     //             buildRow(),                                 SizedBox(height:12,),
                     //             buildRow(),                                 SizedBox(height:12,),
                     //             buildRow(),
                     //           ],
                     //         )
                     //
                     //       ],),
                     //
                     //   ],
                     // )
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         // Row(
                         //   mainAxisAlignment: MainAxisAlignment.start,
                         //   crossAxisAlignment: CrossAxisAlignment.start,
                         //   children: [
                         //     Container(
                         //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                         //       decoration: BoxDecoration(
                         //         color: primaryColor,
                         //         borderRadius: BorderRadius.circular(25),
                         //       ),
                         //       child: const AppTextWidget(
                         //         text: 'Meal Plan Name',
                         //         fontSize: 10,
                         //         fontWeight: FontWeight.w400,
                         //         color: Colors.white,
                         //       ),
                         //     ),
                         //     SizedBox(width: 2.w),
                         //     Container(
                         //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                         //       decoration: BoxDecoration(
                         //         color: primaryColor,
                         //         borderRadius: BorderRadius.circular(25),
                         //       ),
                         //       child: const AppTextWidget(
                         //         text: 'Status',
                         //         fontSize: 10,
                         //         color: Colors.white,
                         //       ),
                         //     ),
                         //     SizedBox(width: 2.w),
                         //     Container(
                         //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                         //       decoration: BoxDecoration(
                         //         color: primaryColor,
                         //         borderRadius: BorderRadius.circular(25),
                         //       ),
                         //       child: const AppTextWidget(
                         //         text: 'Actions',
                         //         fontSize: 10,
                         //         fontWeight: FontWeight.w400,
                         //         color: Colors.white,
                         //       ),
                         //     ),
                         //   ],
                         // ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             buildHeaderButton('Meal Plan Name'),
                             SizedBox(width: 3.w,),
                             buildHeaderButton('Status'),
                             SizedBox(width: 7.w,),
                             buildHeaderButton('Actions'),
                           ],
                         ),
                         SizedBox(height: 8),
                         // Row(
                         //   mainAxisAlignment: MainAxisAlignment.start,
                         //   crossAxisAlignment: CrossAxisAlignment.start,
                         //   children: [
                         //     Container(
                         //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                         //
                         //       child: Row(
                         //         mainAxisAlignment: MainAxisAlignment.start,
                         //         crossAxisAlignment: CrossAxisAlignment.start,
                         //         children: [
                         //           AppTextWidget(text: 'Mother Essences', fontSize: 10),                             SizedBox(width: 2.w),
                         //
                         //           AppTextWidget(text: 'Active', fontSize: 10),                             SizedBox(width: 2.w),
                         //
                         //           buildRow(),
                         //         ],
                         //       )
                         //     ),
                         //     SizedBox(width: 2.w),
                         //
                         //
                         //     Padding(
                         //       padding: const EdgeInsets.all(8.0),
                         //       child: Column(
                         //         crossAxisAlignment: CrossAxisAlignment.start,
                         //         children: const [
                         //           SizedBox(height: 5),
                         //           AppTextWidget(text: 'Mother Essences', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Blood Sugar Reg', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Gut Health', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Skin & Hair', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Hormones Balance', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Mother Essences', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Blood Sugar Reg', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Gut Health', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Skin & Hair', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Hormones Balance', fontSize: 10),
                         //         ],
                         //       ),
                         //     ),
                         //     SizedBox(width: 2.w),
                         //     Padding(
                         //       padding: const EdgeInsets.all(8.0),
                         //       child: Column(
                         //         crossAxisAlignment: CrossAxisAlignment.start,
                         //         children: const [
                         //           SizedBox(height: 5),
                         //           AppTextWidget(text: 'Active', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Active', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Active', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Active', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Active', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Active', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Active', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Active', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Active', fontSize: 10),
                         //           SizedBox(height: 10),
                         //           AppTextWidget(text: 'Active', fontSize: 10),
                         //         ],
                         //       ),
                         //     ),
                         //     SizedBox(width: 2.w),
                         //     Column(
                         //       crossAxisAlignment: CrossAxisAlignment.start,
                         //       children: List.generate(10, (index) {
                         //         return Column(
                         //           children: [
                         //             buildRow(),
                         //             SizedBox(height: 12),
                         //           ],
                         //         );
                         //       }),
                         //     ),
                         //   ],
                         // ),
                         ListView(
                           shrinkWrap: true,
                           children: [
                             buildListItem('Mother Essences', 'Active'),
                             buildListItem('Blood Sugar Reg', 'Active'),
                             buildListItem('Gut Health', 'Active'),
                             buildListItem('Skin & Hair', 'Active'),
                             buildListItem('Hormones Balance', 'Active'),
                             buildListItem('Mother Essences', 'Active'),
                             buildListItem('Blood Sugar Reg', 'Active'),
                             buildListItem('Gut Health', 'Active'),
                             buildListItem('Skin & Hair', 'Active'),
                             buildListItem('Hormones Balance', 'Active'),
                           ],
                         ),
                       ],
                     )

                   ],
                 ),
               ),
             ),
             Container(
               height: 60.h,
               child:  Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   AppTextWidget(text: 'User Engagement',fontWeight: FontWeight.w400,fontSize: 28,),
                   SizedBox(height:2.h),
                   Row(
                     children: [
                       buildContainer('Total User Enrolled:','500'),
                       SizedBox(width: 4.w,),
                       buildContainer('Avg Completion Rate:','80%'),
                     ],
                   ),
                   SizedBox(height:2.h),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         width: 23.w,
                         padding: EdgeInsets.symmetric(horizontal: 15,vertical: 6),
                         alignment: Alignment.centerLeft,
                         decoration: BoxDecoration(
                           color: secondaryColor,
                           borderRadius: BorderRadius.circular(25),
                         ),
                         child: AppTextWidget(text: 'Most Active Users',color: Colors.white,),
                       ),
                     ],
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                     child: AppTextWidget(text: 'User A: 10 Plans ',textAlign: TextAlign.start,fontSize: 10,fontWeight: FontWeight.w500,),
                   ),Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                     child: AppTextWidget(text: 'User B: 8 Plans ',textAlign: TextAlign.start,fontSize: 10,fontWeight: FontWeight.w500,),
                   ),
                 ],
               ),
             )
           ],
         )
        ],
      ),
    );
  }

  Container buildContainer(title,count) {
    return Container(

                   padding: EdgeInsets.only(top: 14,left: 14,right: 18,bottom: 20),
                   decoration: BoxDecoration(
                     color: Color(0xffFBF0F3),
                     borderRadius: BorderRadius.circular(15),
                   ),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       //SizedBox(height: 1.h),
                       AppTextWidget(text:
                         title,
                           fontSize: 10,
                           color: Colors.grey.shade400,
                           fontWeight: FontWeight.w500,
                       ),
                       SizedBox(height: 1.h),
                       AppTextWidget(text:
                         count,

                           fontSize: 24,
                           color: Colors.black,
                           fontWeight: FontWeight.w400,
                       ),
                     ],
                   ),
                 );
  }
  Widget buildListItem(String title, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AppTextWidget(text:
                title, fontSize: 10,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          SizedBox(width: 2.w,),
          Expanded(
            child: AppTextWidget(text:
              status,
              fontSize: 10,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 AppTextWidget(text:
                  '[Edit]',
                      fontSize: 10
                    ,textAlign: TextAlign.start,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                ),
                SizedBox(width: 16),
                 AppTextWidget(text:
                  '[Delete]',
                      fontSize: 10,textAlign: TextAlign.start,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget(text: '[Edit]',textAlign: TextAlign.start,fontWeight:FontWeight.w700,fontSize: 10,),
        SizedBox(width: 20,),
        AppTextWidget(text: '[Delete]',fontSize: 10,textAlign: TextAlign.start),
      ],
    );
  }
  Widget buildHeaderButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child:  AppTextWidget(text:
      text,
        color: Colors.white, fontSize: 10),
    );
  }
}
