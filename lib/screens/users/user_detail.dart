import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/routes/routes_name.dart';
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
import '../../provider/stream/streamProvider.dart';

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
                    text: 'Status:',
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
                          log(
                            "uid is::${dataP.parameters!.uid.toString()}",
                          );
                          dataP.toggleActive(
                            dataP.parameters!.uid.toString(),
                          ); // Toggle the state on tap
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 50,
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: dataP.isActive
                                ? secondaryColor
                                : Colors.black12,
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
                  SizedBox(
                    width: 30,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<MenuAppController>(context, listen: false)
                              .addBackPage(12);
                          Provider.of<MenuAppController>(context, listen: false)
                              .changeScreen(3);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: primaryColor,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      AppTextWidgetFira(
                        text: 'Add Insights',
                        fontSize: 14,
                        color: Colors.black,
                      )
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
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: dataP.parameters!.imageUrl.toString().isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  dataP.parameters!.imageUrl.toString(),
                                  fit: BoxFit.cover,
                                ))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(AppAssets.logoImage)),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildColumnTile(
                          'User Name',
                          'Email Address',
                          'Status',
                          'Last log in',
                          // dataP.parameters!.name.toString().isNotEmpty ? dataP.parameters!.name : 'N/A',
                          dataP.parameters!.name.toString().isNotEmpty ? '*****************' : 'N/A',
                          // dataP.parameters!.email.toString().isNotEmpty ? dataP.parameters!.email : 'N/A',
                          dataP.parameters!.email.toString().isNotEmpty ? '*****************' : 'N/A',
                          dataP.parameters!.status.toString().isNotEmpty ? dataP.parameters!.status : 'N/A',
                          dataP.parameters!.createdAt.toString().isNotEmpty ? formatTimestamp(dataP.parameters!.createdAt.toString()) : 'N/A',
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        buildColumnTile(
                          "Baby's Birth Date:",
                          'Postpartum Phase:',
                          'Type of Birth:',
                          'Feeding type:',
                          dataP.parameters!.birthDate.toString().isNotEmpty
                              ? dataP.parameters!.birthDate.toString()
                              : 'N/A',
                          'Newly Postpartum',
                          dataP.parameters!.vaginalBirth.toString().isNotEmpty
                              ? dataP.parameters!.vaginalBirth
                              : 'N/A',
                          dataP.parameters!.feedingFormula.toString().isNotEmpty
                              ? dataP.parameters!.feedingFormula
                              : 'N/A',
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        buildColumnTile(
                            "Number of Children",
                            'Birth Details:',
                            'Dietary Preferences:',
                            '',
                            dataP.parameters!.child.toString().isNotEmpty
                                ? dataP.parameters!.child.toString()
                                : 'N/A',
                            dataP.parameters!.singletonSection
                                    .toString()
                                    .isNotEmpty
                                ? dataP.parameters!.singletonSection.toString()
                                : 'N/A',
                            'Traditional',
                            ''),
                        MilestoneListWidget(
                          userUid: dataP.parameters!.uid.toString(),
                          isComplete: true,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        const AppTextWidget(
                          text: 'Activity logs:',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 73.w,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xffF1F1F1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TrackerTab(
                                      title: 'Sleep Tracker',
                                      onTap: () {
                                        Provider.of<MenuAppController>(context,
                                                listen: false)
                                            .addBackPage(12);
                                        Provider.of<MenuAppController>(context,
                                                listen: false)
                                            .changeScreens(
                                          29,
                                          type: 'sleep',
                                        );
                                      },
                                    ),
                                    TrackerTab(
                                      title: 'Mood Tracker',
                                      onTap: () {
                                        Provider.of<MenuAppController>(context,
                                                listen: false)
                                            .addBackPage(12);

                                        Provider.of<MenuAppController>(context,
                                                listen: false)
                                            .changeScreens(
                                          29,
                                          // parameters: dataP.parameters!,
                                          type: 'mood',
                                        );
                                      },
                                    ),
                                    TrackerTab(
                                      title: 'Pain/Sym Tracker',
                                      onTap: () {
                                        Provider.of<MenuAppController>(context,
                                                listen: false)
                                            .addBackPage(12);


                                        Provider.of<MenuAppController>(context,
                                                listen: false)
                                            .changeScreens(
                                          29,
                                          // parameters: dataP.parameters!,
                                          type: 'pain',
                                        );
                                      },
                                    ),
                                    TrackerTab(
                                      title: 'Stress Tracker',
                                      onTap: () {
                                        Provider.of<MenuAppController>(context,
                                                listen: false)
                                            .addBackPage(12);

                                        Provider.of<MenuAppController>(context,
                                                listen: false)
                                            .changeScreens(
                                          29,
                                          // parameters: dataP.parameters!,
                                          type: 'stress',
                                        );
                                      },
                                    ),
                                    TrackerTab(
                                      title: 'Energy Tracker',
                                      onTap: () {
                                        Provider.of<MenuAppController>(context,
                                                listen: false)
                                            .addBackPage(12);

                                        Provider.of<MenuAppController>(context,
                                                listen: false)
                                            .changeScreens(
                                          29,
                                          // parameters: dataP.parameters!,
                                          type: 'energy',
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 73.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        width: 200,
                                        height: 500,
                                        child: TrackerLodData(
                                          type: "sleep",
                                          uid: dataP.parameters!.uid.toString(),
                                        )),
                                    //SizedBox(width: 6.w), // Add space between the logs
                                    SizedBox(
                                        width: 200,
                                        height: 500,
                                        child: TrackerLodData(
                                          type: "mood",
                                          uid: dataP.parameters!.uid.toString(),
                                        )),
                                    // SizedBox(width: 6.w), // Add space between the logs
                                    SizedBox(
                                        width: 200,
                                        height: 500,
                                        child: TrackerLodData(
                                          type: "pain",
                                          uid: dataP.parameters!.uid.toString(),
                                        )),
                                    //SizedBox(width: 6.w), // Add space between the logs
                                    SizedBox(
                                        width: 200,
                                        height: 500,
                                        child: TrackerLodData(
                                          type: "stress",
                                          uid: dataP.parameters!.uid.toString(),
                                        )),
                                    //SizedBox(width: 5.w),
                                    SizedBox(
                                        width: 200,
                                        height: 500,
                                        child: TrackerLodData(
                                          type: "energy",
                                          uid: dataP.parameters!.uid.toString(),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(height: 3.h),
                              // PaginationWidget(
                              //   currentPage: provider.currentPage,
                              //   totalPages: provider.totalPages,
                              //   onPageChanged: (page) {
                              //     provider.goToPage(page);
                              //   },
                              // ),
                              // SizedBox(
                              //   height: 2.h,
                              // )
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

  Column buildColumnTile(
    text1,
    text2,
    text3,
    text4,
    text5,
    text6,
    text7,
    text8,
  ) {
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
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
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
                text: 'Date Logged',
                textAlign: TextAlign.center,
                fontSize: 12,
                fontWeight: FontWeight.w700),
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
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
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

class TrackerLodData extends StatelessWidget {
  final String type, uid;
  int? limit;
  TrackerLodData(
      {super.key, required this.type, this.limit, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Consumer<StreamDataProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<List<Tracker>>(
          stream: provider.getTrackerLogs(limit: limit, type: type, uid: uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("loading..."));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No log found'));
            }

            List<Tracker> trackerList = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  AppTextWidget(
                    text: 'Date Logged',
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8.0),
                    itemCount: trackerList.length,
                    itemBuilder: (ctx, index) {
                      Tracker trackerLog = trackerList[index];
                      return AppTextWidget(
                        text:
                            "${convertTimestampToDate(int.parse(trackerLog.createdAt.toString()))}",
                        fontSize: 14,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String convertTimestampToDate(int timestamp) {
    // Convert timestamp from milliseconds to DateTime object
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Format the date to 'MM-dd-yyyy'
    final DateFormat formatter = DateFormat('MM-dd-yyyy');
    return formatter.format(date);
  }
}

class TrackerTab extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const TrackerTab({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Center(
          child: AppTextWidget(
            text: title,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: secondaryColor,
        ),
      ),
    );
  }
}
class MilestoneListWidget extends StatelessWidget {
  final bool isComplete;
  final String userUid;
  const MilestoneListWidget({super.key, this.isComplete = false, required this.userUid,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      // height: 20.h,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 0.5.w),
            child: Consumer<StreamDataProvider>(
              builder: (context, provider, child) {
                return StreamBuilder<List<MilestoneModel>>(
                  stream: provider.getMilestone(userUid: userUid,isComplete: isComplete,),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No milestone found'));
                    }

                    List<MilestoneModel> milestoneList = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextWidget(text: 'Completed milestones:',fontSize: 16,fontWeight: FontWeight.w500,),
                        SizedBox(height: 1.h,),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: milestoneList.length,
                          itemBuilder: (ctx, index) {
                            MilestoneModel milestone = milestoneList[index];
                            final isComplete = milestone.milestones.contains(userUid);
                            return _milestoneBox(
                              title: milestone.title,
                              isComplete: isComplete,
                              milestoneId: milestone.id,
                              onToggleSelection: () {
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 5.h),

        ],
      ),
    );
  }

  Widget _milestoneBox({
    required String title,
    required bool isComplete,
    required String milestoneId,
    required VoidCallback onToggleSelection,
  }) {
    return GestureDetector(
      onTap: onToggleSelection,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4),
        margin: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.w),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5),
          //     blurRadius: 10,
          //   ),
          // ],
        ),
        child: AppTextWidget(
          text: title,
          fontSize: 14.0,
          textAlign: TextAlign.start,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}