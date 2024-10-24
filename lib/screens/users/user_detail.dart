import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/user_model/user_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/pagination.dart';
import '../../model/res/constant/app_assets.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../provider/navigation/navigationProvider.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityLogProvider>(context);
    final dataP = Provider.of<MenuAppController>(context);
    log("image::${dataP.parameters!.imageUrl}");
    log("status::${dataP.parameters!.status}");
    log("id::${dataP.parameters!.uid}");
    log("name::${dataP.parameters!.name}");
    log("email::${dataP.parameters!.email}");

    return Scaffold(
      appBar: const CustomAppbar(text: 'Dashboard'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const AppTextWidget(
                    text: 'Active',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Consumer<MenuAppController>(
                    builder: (context, dataP, child) {
                      return GestureDetector(
                        onTap: () {
                          log("uid is::${dataP.parameters!.uid.toString()}",);
                          dataP.toggleActive(dataP.parameters!.uid.toString(),); // Toggle the state on tap
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 50,
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: dataP.isActive ? secondaryColor : Colors.black12,
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 300),
                            alignment: dataP.isActive
                                ? Alignment.centerRight
                                : Alignment.centerLeft, // Toggle alignment
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 30,),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // Provider.of<MenuAppController>(context, listen: false)
                          //     .changeScreen(3);
                          Provider.of<MenuAppController>(context, listen: false)
                              .changeScreenWithParams(3,
                          parameters: dataP.parameters!,
                          );
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
                      AppTextWidgetFira(text: 'Add Insights',fontSize: 14,color: Colors.black,)
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        child: dataP.parameters!.imageUrl.toString().isNotEmpty ?
                        Image.network(dataP.parameters!.imageUrl.toString(),fit: BoxFit.cover,):
                        Image.asset(AppAssets.logoImage),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildColumnTile(
                            'User Name','Email Address','Status','Last log in',
                            dataP.parameters!.name.toString().isNotEmpty? dataP.parameters!.name : 'N/A',
                            dataP.parameters!.email.toString().isNotEmpty? dataP.parameters!.email : 'N/A',
                            dataP.parameters!.status.toString().isNotEmpty? dataP.parameters!.status : 'N/A',
                      dataP.parameters!.createdAt.toString().isNotEmpty ? formatTimestamp(dataP.parameters!.createdAt.toString()) : 'N/A',),
                        SizedBox(height: 3.h,),
                        buildColumnTile("Baby's Birth Date:",'Postpartum Phase:','Type of Birth:','Feeding type:',
                           dataP.parameters!.birthDate.toString().isNotEmpty? dataP.parameters!.birthDate.toString() : 'N/A',
                            'Newly Postpartum',
                            dataP.parameters!.vaginalBirth.toString().isNotEmpty? dataP.parameters!.vaginalBirth : 'N/A',
                            dataP.parameters!.feedingFormula.toString().isNotEmpty? dataP.parameters!.feedingFormula : 'N/A',
                        ),
                        SizedBox(height: 3.h,),
                        buildColumnTile("Number of Children",'Birth Details:','Dietary Preferences:','',
                            dataP.parameters!.child.toString().isNotEmpty? dataP.parameters!.child.toString() : 'N/A',
                            dataP.parameters!.singletonSection.toString().isNotEmpty? dataP.parameters!.singletonSection.toString() : 'N/A',
                            'Traditional',''
                        ),
                        SizedBox(height: 3.h,),
                        const AppTextWidget(text: 'Activity logs:',fontWeight: FontWeight.w700,fontSize: 14,),
                       SingleChildScrollView(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.end,
                           children: [
                             Container(
                               width:73.w,
                               padding: const EdgeInsets.all(15),
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10),
                                   color: const Color(0xffF1F1F1)
                               ),
                               child: const Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   TrackerTab(title: 'Sleep Tracker'),
                                   TrackerTab(title: 'Mood Tracker'),
                                   TrackerTab(title: 'Pain/Sym Tracker'),
                                   TrackerTab(title: 'Stress Tracker'),
                                   TrackerTab(title: 'Energy Tracker'),
                                 ],
                               ),

                             ),
                             Container(
                               width: 73.w,
                               child: Consumer<ActivityLogProvider>(
                                 builder: (context, provider, child) {
                                   return SingleChildScrollView(
                                     scrollDirection: Axis.vertical,
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         //SizedBox(width: 0.5.w,),
                                         _buildLogList(provider),
                                         //SizedBox(width: 6.w), // Add space between the logs
                                         _buildLogList(provider),
                                        // SizedBox(width: 6.w), // Add space between the logs
                                         _buildLogList(provider),
                                         //SizedBox(width: 6.w), // Add space between the logs
                                         _buildLogList(provider),
                                         //SizedBox(width: 5.w),
                                         _buildLogList(provider),
                                       ],
                                     ),
                                   );
                                 },
                               ),
                             ),
                              SizedBox(height: 3.h),
                             PaginationWidget(
                               currentPage: provider.currentPage,
                               totalPages: provider.totalPages,
                               onPageChanged: (page) {
                                 provider.goToPage(page);
                               },
                             ),
                             SizedBox(height: 2.h,)
                           ],
                         ),
                       )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column buildColumnTile(text1, text2, text3, text4, text5, text6, text7, text8, ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 15.w,
                            child: AppTextWidget(
                              text: text1,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                            ),
                          ),
                          //SizedBox(width: 17.w,),
                          Container(
                            width: 15.w,
                            alignment: Alignment.centerLeft,

                            child: AppTextWidget(
                              text: text2,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                            ),
                          ),
                          //SizedBox(width: 22.w,),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 15.w,

                            child: AppTextWidget(
                              text: text3,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                            ),
                          ),
                          //SizedBox(width: 18.w,),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 15.w,
                            child: AppTextWidget(
                              text: text4,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: primaryColor, // Background color
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: Row(
                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 14.5.w,
                            child: AppTextWidget(
                              text: text5,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 15.w,
                            child: AppTextWidget(
                              text: text6,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 15.w,
                            child: AppTextWidget(
                              text: text7,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 28.w,
                            child: AppTextWidget(
                              text: text8,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
  }
  // Function to convert timestamp string to readable date format
  String formatTimestamp(String timestamp) {
    if (timestamp.isNotEmpty) {
      int milliseconds = int.parse(timestamp);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      // Format the date (you can customize the format as per your needs)
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    }
    return 'N/A';
  }
  Widget _buildLogList(ActivityLogProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppTextWidget(
               text:
              'Date Logged',
             textAlign: TextAlign.center,
             fontSize: 12, fontWeight: FontWeight.w700),
            const SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  provider.logsForPage.length,
                      (index) => Text(
                    provider.logsForPage[index],
                    style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class TrackerTab extends StatelessWidget {
  final String title;

  const TrackerTab({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      // width: 14.w,
        child:  Center(
          child: AppTextWidget(text:
            title,
            fontSize: 11, fontWeight: FontWeight.w400,color: Colors.black),
        ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: secondaryColor,

      ),
    );
  }}